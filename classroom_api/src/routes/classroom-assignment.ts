import { db } from "@/libs/db";
import {
  assignmentAttachmentTable,
  assignmentSubmissionTable,
  assignmentTable,
  classroomTable,
  fileTable,
  studyTable,
  submissionAttachmentTable,
  teachTable,
  userTable,
} from "@/libs/db/schema";
import { uploadFile } from "@/libs/upload-file";
import { middleware } from "@/middleware";
import { and, desc, eq, is, or, sql } from "drizzle-orm";
import Elysia, { t } from "elysia";

export const classroomAssignmentRoute = new Elysia({ prefix: "/classroom" })
  .use(middleware)
  .derive({ as: "local" }, async ({ user, set, params }) => {
    if (!user) {
      set.status = 401;
      return {
        teacher: null,
        student: null,
      };
    }

    const { classroomId } = params;

    if (!classroomId === undefined) {
      set.status = 400;
      return {
        message: "Classroom ID is required",
      };
    }

    const [teacher] = await db
      .select()
      .from(teachTable)
      .where(
        and(
          eq(teachTable.userId, user.id),
          eq(teachTable.classroomId, classroomId)
        )
      );

    const [student] = await db
      .select()
      .from(studyTable)
      .where(
        and(
          eq(studyTable.userId, user.id),
          eq(studyTable.classroomId, classroomId)
        )
      );

    return {
      teacher: teacher,
      student: student,
    };
  })
  .group("/:classroomId/assignment", (app) => {
    return app
      .post(
        "/",
        async ({ user, set, teacher, params, body }) => {
          if (!user) {
            set.status = 401;
            return {
              message: "Unauthorized",
            };
          }

          if (!teacher) {
            set.status = 403;
            return {
              message: "Forbidden",
            };
          }

          const { classroomId } = params;

          const { title, description, dueDate, files, maxScore } = body;

          const [result] = await db
            .insert(assignmentTable)
            .values({
              classroomId,
              createdBy: user.id,
              title,
              description,
              dueDate: new Date(dueDate),
              maxScore: maxScore,
            })
            .returning({ id: assignmentTable.id });

          let filesIdResult = [];
          for (const file of files) {
            const result = await uploadFile(file, user.id);

            if (result.status === "error") {
              set.status = 400;
              return {
                message: result.message,
              };
            }

            filesIdResult.push(result.id);
          }

          if (filesIdResult.length !== 0) {
            await db.insert(assignmentAttachmentTable).values(
              filesIdResult.map((id) => ({
                fileId: id,
                assignmentId: result.id,
              }))
            );
          }

          return {
            message: "Assignment created",
          };
        },
        {
          body: t.Object({
            title: t.String(),
            description: t.String(),
            files: t.Files(),
            dueDate: t.String(),
            maxScore: t.Numeric({ optional: true }),
          }),
        }
      )
      .get("/", async ({ params, set, teacher, student, user }) => {
        if (!user) {
          set.status = 401;
          return {
            message: "Unauthorized",
          };
        }

        if (!teacher && !student) {
          set.status = 403;
          return {
            message: "Forbidden",
          };
        }

        const { classroomId } = params;

        let assignments = [];

        if (student) {
          assignments = await db
            .select({
              id: assignmentTable.id,
              classroomName:
                sql`(SELECT ${classroomTable.name} FROM ${classroomTable} WHERE ${classroomTable.id} = ${assignmentTable.classroomId})`.as(
                  "classroomName"
                ),
              title: assignmentTable.title,
              description: assignmentTable.description,
              dueDate: assignmentTable.dueDate,
              maxScore: assignmentTable.maxScore,
              scoreReceived: assignmentSubmissionTable.score,
              createdBy:
                sql`(SELECT ${userTable.username} FROM ${userTable} WHERE ${userTable.id} = ${assignmentTable.createdBy})`.as(
                  "createdBy"
                ),
              createdAt: assignmentTable.createdAt,
              isSubmitted: assignmentSubmissionTable.isSubmitted,
            })
            .from(assignmentTable)
            .leftJoin(
              assignmentSubmissionTable,
              eq(assignmentSubmissionTable.assignmentId, assignmentTable.id)
            )
            .where(
              and(
                eq(assignmentTable.classroomId, classroomId),
                or(
                  eq(assignmentSubmissionTable.isSubmitted, false),
                  sql`${assignmentSubmissionTable.userId} IS NULL`
                )
              )
            )
            .orderBy(desc(assignmentTable.createdAt));
        } else {
          assignments = await db
            .select({
              id: assignmentTable.id,
              classroomName:
                sql`(SELECT ${classroomTable.name} FROM ${classroomTable} WHERE ${classroomTable.id} = ${assignmentTable.classroomId})`.as(
                  "classroomName"
                ),
              title: assignmentTable.title,
              description: assignmentTable.description,
              dueDate: assignmentTable.dueDate,
              maxScore: assignmentTable.maxScore,
              createdBy:
                sql`(SELECT ${userTable.username} FROM ${userTable} WHERE ${userTable.id} = ${assignmentTable.createdBy})`.as(
                  "createdBy"
                ),
              createdAt: assignmentTable.createdAt,
            })
            .from(assignmentTable)
            .where(eq(assignmentTable.classroomId, classroomId))
            .groupBy(assignmentTable.id)
            .orderBy(desc(assignmentTable.createdAt));
        }

        return {
          assignments,
        };
      })
      .get(
        "/:assignmentId",
        async ({ params, set, teacher, student, user }) => {
          if (!user) {
            set.status = 401;
            return {
              message: "Unauthorized",
            };
          }

          if (!teacher && !student) {
            set.status = 403;
            return {
              message: "Forbidden",
            };
          }

          const { classroomId, assignmentId } = params;

          let assignment;
          let submissionAttachments: any = [];

          if (student) {
            [assignment] = await db
              .select({
                id: assignmentTable.id,
                classroomName:
                  sql`(SELECT ${classroomTable.name} FROM ${classroomTable} WHERE ${classroomTable.id} = ${assignmentTable.classroomId})`.as(
                    "classroomName"
                  ),
                title: assignmentTable.title,
                description: assignmentTable.description,
                createdBy:
                  sql`(SELECT ${userTable.username} FROM ${userTable} WHERE ${userTable.id} = ${assignmentTable.createdBy})`.as(
                    "createdBy"
                  ),
                createdAt: assignmentTable.createdAt,
                maxScore: assignmentTable.maxScore,
                dueDate: assignmentTable.dueDate,
                isSubmitted: assignmentSubmissionTable.isSubmitted,
                submittedAt: assignmentSubmissionTable.submittedAt,
                attachments: sql<string[]>`ARRAY_AGG(JSON_BUILD_OBJECT(
                    'url', ${fileTable.url}, 
                    'fileType', ${fileTable.fileType},
                    'fileName', ${fileTable.fileName}
                  )
                )
              `.as("attachments"),
              })
              .from(assignmentTable)
              .leftJoin(
                assignmentAttachmentTable,
                eq(assignmentAttachmentTable.assignmentId, assignmentTable.id)
              )
              .leftJoin(
                fileTable,
                eq(fileTable.id, assignmentAttachmentTable.fileId)
              )
              .leftJoin(
                assignmentSubmissionTable,
                eq(assignmentSubmissionTable.assignmentId, assignmentTable.id)
              )
              .where(
                and(
                  eq(assignmentTable.id, assignmentId),
                  eq(assignmentTable.classroomId, classroomId)
                )
              )
              .groupBy(
                assignmentTable.id,
                assignmentSubmissionTable.isSubmitted,
                assignmentSubmissionTable.submittedAt
              );

            if (assignment.isSubmitted) {
              submissionAttachments = await db
                .select({
                  url: fileTable.url,
                  fileType: fileTable.fileType,
                  fileName: fileTable.fileName,
                })
                .from(submissionAttachmentTable)
                .leftJoin(
                  fileTable,
                  eq(fileTable.id, submissionAttachmentTable.fileId)
                )
                .where(
                  and(
                    eq(submissionAttachmentTable.assignmentId, assignmentId),
                    eq(submissionAttachmentTable.userId, user.id)
                  )
                );
            }
          } else {
            [assignment] = await db
              .select({
                id: assignmentTable.id,
                classroomName:
                  sql`(SELECT ${classroomTable.name} FROM ${classroomTable} WHERE ${classroomTable.id} = ${assignmentTable.classroomId})`.as(
                    "classroomName"
                  ),
                title: assignmentTable.title,
                description: assignmentTable.description,
                createdBy:
                  sql`(SELECT ${userTable.username} FROM ${userTable} WHERE ${userTable.id} = ${assignmentTable.createdBy})`.as(
                    "createdBy"
                  ),
                createdAt: assignmentTable.createdAt,
                maxScore: assignmentTable.maxScore,
                dueDate: assignmentTable.dueDate,
                attachments: sql<string[]>`ARRAY_AGG(JSON_BUILD_OBJECT(
                  'url', ${fileTable.url}, 
                  'fileType', ${fileTable.fileType},
                  'fileName', ${fileTable.fileName}
                )
              )
            `.as("attachments"),
                submittedStudents: sql<string[]>`COALESCE(
                  ARRAY_AGG(DISTINCT ${userTable.username})
                  FILTER (WHERE ${assignmentSubmissionTable.isSubmitted} = TRUE),
                  '{}'
                )`.as("submittedStudents"),
                assigned: sql<number>`COUNT(DISTINCT ${studyTable.userId})`
                  .mapWith(Number)
                  .as("assigned"),
                submitted:
                  sql<number>`COUNT(DISTINCT ${assignmentSubmissionTable.userId}) FILTER (WHERE ${assignmentSubmissionTable.isSubmitted} = TRUE)`
                    .mapWith(Number)
                    .as("submitted"),
              })
              .from(assignmentTable)
              .leftJoin(
                assignmentAttachmentTable,
                eq(assignmentAttachmentTable.assignmentId, assignmentTable.id)
              )
              .leftJoin(
                fileTable,
                eq(fileTable.id, assignmentAttachmentTable.fileId)
              )
              .leftJoin(
                assignmentSubmissionTable,
                eq(assignmentSubmissionTable.assignmentId, assignmentTable.id)
              )
              .leftJoin(
                userTable,
                eq(userTable.id, assignmentSubmissionTable.userId)
              )
              .leftJoin(
                studyTable,
                eq(studyTable.classroomId, assignmentTable.classroomId)
              )
              .where(
                and(
                  eq(assignmentTable.id, assignmentId),
                  eq(assignmentTable.classroomId, classroomId)
                )
              )
              .groupBy(assignmentTable.id);
          }

          return {
            assignment,
            submissionAttachments,
          };
        }
      )
      .post(
        "/:assignmentId/submit",
        async ({ student, user, params, body, set }) => {
          if (!user) {
            return {
              message: "Unauthorized",
            };
          }

          if (!student) {
            return {
              message: "Forbidden",
            };
          }

          const { assignmentId, classroomId } = params;

          const [assignment] = await db
            .select()
            .from(assignmentTable)
            .where(
              and(
                eq(assignmentTable.id, assignmentId),
                eq(assignmentTable.classroomId, classroomId)
              )
            );

          if (!assignment) {
            return {
              message: "Assignment not found",
            };
          }

          const { files } = body;

          await db
            .insert(assignmentSubmissionTable)
            .values({
              assignmentId,
              userId: user.id,
            })
            .onConflictDoUpdate({
              target: [
                assignmentSubmissionTable.assignmentId,
                assignmentSubmissionTable.userId,
              ],
              set: {
                isSubmitted: true,
                submittedAt: new Date(),
              },
            });

          let filesIdResult = [];
          for (const file of files) {
            const result = await uploadFile(file, user.id);

            if (result.status === "error") {
              set.status = 400;
              return {
                message: result.message,
              };
            }

            filesIdResult.push(result.id);
          }

          if (filesIdResult.length !== 0) {
            await db.insert(submissionAttachmentTable).values(
              filesIdResult.map((id) => ({
                assignmentId,
                fileId: id,
                userId: user.id,
              }))
            );
          }

          return {
            message: "Assignment submitted",
          };
        },
        {
          body: t.Object({
            files: t.Files(),
          }),
        }
      )
      .delete(
        "/:assignmentId/cancel-submit",
        async ({ user, set, student, params }) => {
          if (!user) {
            set.status = 401;
            return {
              message: "Unauthorized",
            };
          }

          if (!student) {
            set.status = 403;
            return {
              message: "Forbidden",
            };
          }

          const { assignmentId, classroomId } = params;

          const [assignment] = await db
            .select()
            .from(assignmentTable)
            .where(
              and(
                eq(assignmentTable.id, assignmentId),
                eq(assignmentTable.classroomId, classroomId)
              )
            );

          if (!assignment) {
            set.status = 404;
            return {
              message: "Assignment not found",
            };
          }

          await db
            .update(assignmentSubmissionTable)
            .set({
              isSubmitted: false,
            })
            .where(
              and(
                eq(assignmentSubmissionTable.assignmentId, assignmentId),
                eq(assignmentSubmissionTable.userId, user.id)
              )
            );

          return {
            message: "Assignment submission canceled",
          };
        }
      );
  });
