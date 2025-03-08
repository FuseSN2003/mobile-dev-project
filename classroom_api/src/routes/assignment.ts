import { db } from "@/libs/db";
import {
  assignmentSubmissionTable,
  assignmentTable,
  classroomTable,
  studyTable,
  userTable,
} from "@/libs/db/schema";
import { middleware } from "@/middleware";
import { and, eq, or, sql } from "drizzle-orm";
import Elysia from "elysia";

export const assignmentRoute = new Elysia({ prefix: "/assignment" })
  .use(middleware)
  .get("/assignment-list", async ({ user, set }) => {
    if (!user) {
      set.status = 401;
      return {
        message: "Unauthorized",
      };
    }

    const assignedAssignments = await db
      .select({
        id: assignmentTable.id,
        classroomName: sql`(SELECT ${classroomTable.name} FROM ${classroomTable} WHERE ${classroomTable.id} = ${studyTable.classroomId})`.as(
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

    const overdueAssignment = await db
      .select({
        id: assignmentTable.id,
        classroomName: sql`(SELECT ${classroomTable.name} FROM ${classroomTable} WHERE ${classroomTable.id} = ${studyTable.classroomId})`.as(
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
        classroomName: sql`(SELECT ${classroomTable.name} FROM ${classroomTable} WHERE ${classroomTable.id} = ${studyTable.classroomId})`.as(
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
      overdueAssignment,
      submittedAssignments,
    };
  });
