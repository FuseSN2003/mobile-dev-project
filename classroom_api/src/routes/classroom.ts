import { db } from "@/libs/db";
import {
  classroomTable,
  studyTable,
  teachTable,
  userTable,
} from "@/libs/db/schema";
import { middleware } from "@/middleware";
import { eq, sql } from "drizzle-orm";
import Elysia, { t } from "elysia";

export const classroomRoute = new Elysia({
  prefix: "/classroom",
})
  .use(middleware)
  .post(
    "/",
    async ({ user, set, body }) => {
      if (!user) {
        set.status = 401;
        return {
          message: "Unauthorized",
        };
      }

      const [userData] = await db
        .select({ id: userTable.id })
        .from(userTable)
        .where(eq(userTable.id, user.id));

      if (!userData) {
        set.status = 401;
        return {
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
          sql`(SELECT ${userTable.username} FROM ${userTable} WHERE ${userTable.id} = ${classroomTable.createdBy})`.as(
            "createdBy"
          ),
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
          sql`(SELECT ${userTable.username} FROM ${userTable} WHERE ${userTable.id} = ${classroomTable.createdBy})`.as(
            "createdBy"
          ),
      })
      .from(classroomTable)
      .leftJoin(studyTable, eq(studyTable.classroomId, classroomTable.id))
      .leftJoin(teachTable, eq(teachTable.classroomId, classroomTable.id))
      .leftJoin(userTable, eq(teachTable.userId, userTable.id))
      .where(eq(studyTable.userId, user.id));

    return {
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
        set.status = 400;
        return {
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
        message: "Joined classroom successfully",
        classroomId: result.id,
      };
    },
    {
      body: t.Object({
        code: t.String(),
      }),
    }
  );
