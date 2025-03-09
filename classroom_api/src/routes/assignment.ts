import { db } from "@/libs/db";
import {
  assignmentSubmissionTable,
  assignmentTable,
  classroomTable,
  fileTable,
  studyTable,
  submissionAttachmentTable,
  userTable,
} from "@/libs/db/schema";
import { middleware } from "@/middleware";
import { and, eq, max, or, sql } from "drizzle-orm";
import Elysia, { t } from "elysia";

export const assignmentRoute = new Elysia({ prefix: "/assignment" })
  .use(middleware)
  .get("/list", async ({ user, set }) => {
    if (!user) {
      set.status = 401;
      return {
        message: "Unauthorized",
      };
    }

    const assignedAssignments = await db
      .select({
        id: assignmentTable.id,
        classroomName:
          sql`(SELECT ${classroomTable.name} FROM ${classroomTable} WHERE ${classroomTable.id} = ${studyTable.classroomId})`.as(
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
        studyTable,
        eq(assignmentTable.classroomId, studyTable.classroomId)
      )
      .leftJoin(
        assignmentSubmissionTable,
        eq(assignmentTable.id, assignmentSubmissionTable.assignmentId)
      )
      .where(
        and(
          eq(studyTable.userId, user.id),
          or(
            eq(assignmentSubmissionTable.isSubmitted, false),
            sql`${assignmentSubmissionTable.userId} IS NULL`
          ),
          sql`${assignmentTable.dueDate} > NOW()`
        )
      );

    const overdueAssignments = await db
      .select({
        id: assignmentTable.id,
        classroomName:
          sql`(SELECT ${classroomTable.name} FROM ${classroomTable} WHERE ${classroomTable.id} = ${studyTable.classroomId})`.as(
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
        studyTable,
        eq(assignmentTable.classroomId, studyTable.classroomId)
      )
      .leftJoin(
        assignmentSubmissionTable,
        eq(assignmentTable.id, assignmentSubmissionTable.assignmentId)
      )
      .where(
        and(
          eq(studyTable.userId, user.id),
          or(
            eq(assignmentSubmissionTable.isSubmitted, false),
            sql`${assignmentSubmissionTable.userId} IS NULL`
          ),
          sql`${assignmentTable.dueDate} < NOW()`
        )
      );

    const submittedAssignments = await db
      .select({
        id: assignmentTable.id,
        classroomName:
          sql`(SELECT ${classroomTable.name} FROM ${classroomTable} WHERE ${classroomTable.id} = ${studyTable.classroomId})`.as(
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
        studyTable,
        eq(assignmentTable.classroomId, studyTable.classroomId)
      )
      .leftJoin(
        assignmentSubmissionTable,
        eq(assignmentTable.id, assignmentSubmissionTable.assignmentId)
      )
      .where(
        and(
          eq(studyTable.userId, user.id),
          eq(assignmentSubmissionTable.isSubmitted, true)
        )
      );

    return {
      assignedAssignments,
      overdueAssignments,
      submittedAssignments,
    };
  })
  .get("/:assignmentId/student/:studentName", async ({ user, set, params }) => {
    if (!user) {
      set.status = 401;
      return {
        message: "Unauthorized",
      };
    }

    const { assignmentId, studentName } = params;

    const [studentAssignment] = await db
      .select({
        id: assignmentTable.id,
        dueDate: assignmentTable.dueDate,
        studentName: userTable.username,
        title: assignmentTable.title,
        submittedAt: assignmentSubmissionTable.submittedAt,
        attachments: sql<string[]>`ARRAY_AGG(JSON_BUILD_OBJECT(
          'url', ${fileTable.url}, 
          'fileType', ${fileTable.fileType},
          'fileName', ${fileTable.fileName}
        ))`.as("attachments"),
        scoreReceived: assignmentSubmissionTable.score,
        maxScore: assignmentTable.maxScore,
      })
      .from(assignmentTable)
      .leftJoin(
        studyTable,
        eq(assignmentTable.classroomId, studyTable.classroomId)
      )
      .leftJoin(userTable, eq(studyTable.userId, userTable.id))
      .leftJoin(
        assignmentSubmissionTable,
        eq(assignmentTable.id, assignmentSubmissionTable.assignmentId)
      )
      .leftJoin(
        submissionAttachmentTable,
        eq(
          assignmentSubmissionTable.assignmentId,
          submissionAttachmentTable.assignmentId
        )
      )
      .leftJoin(fileTable, eq(submissionAttachmentTable.fileId, fileTable.id))
      .where(
        and(
          eq(assignmentTable.id, assignmentId),
          eq(userTable.username, studentName)
        )
      )
      .groupBy(
        assignmentTable.id,
        assignmentSubmissionTable.submittedAt,
        assignmentSubmissionTable.score,
        userTable.username
      );

    return {
      studentAssignment,
    };
  })
  .patch(
    "/:assignmentId/student/:studentName",
    async ({ user, set, params, body }) => {
      if (!user) {
        set.status = 401;
        return {
          message: "Unauthorized",
        };
      }

      const { assignmentId, studentName } = params;

      const { score } = body;

      const [assignment] = await db
        .select({
          maxScore: assignmentTable.maxScore,
        })
        .from(assignmentTable)
        .where(eq(assignmentTable.id, assignmentId));

      if (!assignment) {
        set.status = 404;
        return {
          message: "Assignment not found",
        };
      }

      if (!assignment.maxScore) {
        set.status = 400;
        return {
          message: "Assignment doesn't have a score",
        };
      }

      if (score < 0 || score > assignment.maxScore) {
        set.status = 400;
        return {
          message: "Invalid score",
        };
      }

      const [student] = await db
        .select()
        .from(userTable)
        .where(eq(userTable.username, studentName));

      if (!student) {
        set.status = 404;
        return {
          message: "Student not found",
        };
      }

      await db
        .update(assignmentSubmissionTable)
        .set({
          score,
        })
        .where(
          and(
            eq(assignmentSubmissionTable.assignmentId, assignmentId),
            eq(assignmentSubmissionTable.userId, student.id)
          )
        );
    },
    {
      body: t.Object({
        score: t.Numeric(),
      }),
    }
  );
