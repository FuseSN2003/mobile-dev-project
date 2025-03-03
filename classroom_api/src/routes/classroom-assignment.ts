import { db } from "@/libs/db";
import {
  assignmentAttachmentTable,
  assignmentSubmissionTable,
  assignmentTable,
  studyTable,
  teachTable,
  userTable
} from "@/libs/db/schema";
import { uploadFile } from "@/libs/upload-file";
import { middleware } from "@/middleware";
import { and, eq, sql } from "drizzle-orm";
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
              title: assignmentTable.title,
              description: assignmentTable.description,
              dueDate: assignmentTable.dueDate,
              maxScore: assignmentTable.maxScore,
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
            .where(eq(assignmentTable.classroomId, classroomId));
        } else {
          assignments = await db
            .select({
              id: assignmentTable.id,
              classroomId: assignmentTable.classroomId,
              title: assignmentTable.title,
              description: assignmentTable.description,
              dueDate: assignmentTable.dueDate,
              maxScore: assignmentTable.maxScore,
              createdBy:
                sql`(SELECT ${userTable.username} FROM ${userTable} WHERE ${userTable.id} = ${assignmentTable.createdBy})`.as(
                  "createdBy"
                ),
              createdAt: assignmentTable.createdAt,
              assigned: sql`COUNT(DISTINCT ${studyTable.userId})`
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
              assignmentSubmissionTable,
              eq(assignmentSubmissionTable.assignmentId, assignmentTable.id)
            )
            .leftJoin(
              studyTable,
              eq(studyTable.classroomId, assignmentTable.classroomId)
            )
            .where(eq(assignmentTable.classroomId, classroomId))
            .groupBy(assignmentTable.id);
        }

        console.log(assignments);

        return {
          assignments,
        };
      });
  });
