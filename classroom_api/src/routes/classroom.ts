import { db } from "@/lib/db";
import {
  classroomTable,
  studyTable,
  teachTable,
  userTable,
} from "@/lib/db/schema";
import { middleware } from "@/middleware";
import { and, eq, sql } from "drizzle-orm";
import Elysia, { t } from "elysia";

export const classroomRoute = new Elysia({
  prefix: "/c",
})
  .use(middleware)
  .post(
    "/",
    async ({ user, set, body }) => {
      if (!user) {
        set.status = 401;
        return {
          status: "error",
          message: "Unauthorized",
        };
      }

      const { name, description } = body;

      const [createdClassroom] = await db
        .insert(classroomTable)
        .values({
          name,
          description,
          createdBy: user.id,
        })
        .returning({ id: classroomTable.id });

      await db.insert(teachTable).values({
        userId: user.id,
        classroomId: createdClassroom.id,
      });

      return {
        status: "success",
        message: "Classroom created successfully",
        classroomId: createdClassroom.id,
      };
    },
    {
      body: t.Object({
        name: t.String({ minLength: 1 }),
        description: t.String(),
      }),
    }
  )
  .get("/", async ({ user }) => {
    if (!user) {
      return {
        status: "error",
        message: "Unauthorized",
      };
    }

    const teachingClassrooms = await db
      .select({
        id: classroomTable.id,
        name: classroomTable.name,
        description: classroomTable.description,
        createdBy:
          sql`(SELECT ${userTable.username} FROM ${userTable} WHERE ${userTable.id} = ${classroomTable.createdBy})`
            .mapWith(String)
            .as("createdBy"),
        studentCount:
          sql<number>`(SELECT COUNT(*) FROM ${studyTable} WHERE ${studyTable.classroomId} = ${classroomTable.id})`
            .mapWith(Number)
            .as("studentCount"),
      })
      .from(classroomTable)
      .leftJoin(teachTable, eq(teachTable.classroomId, classroomTable.id))
      .leftJoin(userTable, eq(teachTable.userId, userTable.id))
      .where(eq(teachTable.userId, user.id));

    const studyingClassrooms = await db
      .select({
        id: classroomTable.id,
        name: classroomTable.name,
        description: classroomTable.description,
        createdBy:
          sql`(SELECT ${userTable.username} FROM ${userTable} WHERE ${userTable.id} = ${classroomTable.createdBy})`
            .mapWith(String)
            .as("createdBy"),
      })
      .from(classroomTable)
      .leftJoin(studyTable, eq(studyTable.classroomId, classroomTable.id))
      .leftJoin(teachTable, eq(teachTable.classroomId, classroomTable.id))
      .leftJoin(userTable, eq(teachTable.userId, userTable.id))
      .where(eq(studyTable.userId, user.id));

    return {
      status: "success",
      teachingClassrooms,
      studyingClassrooms,
    };
  })
  .post(
    "/join",
    async ({ user, set, body }) => {
      if (!user) {
        set.status = 401;
        return {
          status: "error",
          message: "Unauthorized",
        };
      }

      const { code } = body;

      const [classroom] = await db
        .select()
        .from(classroomTable)
        .where(eq(classroomTable.code, code));

      if (!classroom) {
        set.status = 404;
        return {
          status: "error",
          message: "Invalid classroom code",
        };
      }

      const [result] = await db
        .insert(studyTable)
        .values({
          userId: user.id,
          classroomId: classroom.id,
        })
        .returning({ id: studyTable.classroomId })
        .onConflictDoUpdate({
          target: [studyTable.userId, studyTable.classroomId],
          set: { classroomId: studyTable.classroomId },
        });

      return {
        status: "success",
        message: "Joined classroom successfully",
        classroomId: result.id,
      };
    },
    {
      body: t.Object({
        code: t.String(),
      }),
    }
  )
  .get("/:classroomId", async ({ params, user, set }) => {
    if (!user) {
      set.status = 401;
      return {
        status: "error",
        message: "Unauthorized",
      };
    }

    const { classroomId } = params;

    const [classroom] = await db
      .select({
        id: classroomTable.id,
        name: classroomTable.name,
        description: classroomTable.description,
        createdBy:
          sql`(SELECT ${userTable.username} FROM ${userTable} WHERE ${userTable.id} = ${classroomTable.createdBy})`
            .mapWith(String)
            .as("createdBy"),
        code: classroomTable.code,
      })
      .from(classroomTable)
      .where(eq(classroomTable.id, classroomId));

    if (!classroom) {
      set.status = 404;
      return {
        status: "error",
        message: "Classroom not found",
      };
    }

    return {
      status: "success",
      classroom,
    };
  }).get("/:classroomId/member", async ({ params, set, user }) => {
    if (!user) {
      set.status = 401;
      return {
        status: "error",
        message: "Unauthorized",
      };
    }

    const { classroomId } = params;

    const [classroom] = await db
      .select({ id: classroomTable.id })
      .from(classroomTable)
      .where(eq(classroomTable.id, classroomId));

    if (!classroom) {
      set.status = 404;
      return {
        status: "error",
        message: "Classroom not found",
      };
    }

    const students = await db
      .select({
        id: userTable.id,
        username: userTable.username,
        email: userTable.email,
      })
      .from(studyTable)
      .where(eq(studyTable.classroomId, classroomId))
      .leftJoin(userTable, eq(studyTable.userId, userTable.id));

    const teachers = await db
      .select({
        id: userTable.id,
        username: userTable.username,
        email: userTable.email,
      })
      .from(teachTable)
      .where(eq(teachTable.classroomId, classroomId))
      .leftJoin(userTable, eq(teachTable.userId, userTable.id));

    return {
      status: "success",
      students,
      teachers,
    };
  });
