import { db } from "@/libs/db";
import { classroomTable, teachTable, userTable } from "@/libs/db/schema";
import { middleware } from "@/middleware";
import node from "@elysiajs/node";
import { eq } from "drizzle-orm";
import Elysia, { t } from "elysia";

export const classroomRoute = new Elysia({
  prefix: "/classroom",
  adapter: node(),
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

      const [userData] = await db
        .select({ id: userTable.id })
        .from(userTable)
        .where(eq(userTable.id, user.id));

      if (!userData) {
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
    { body: t.Object({ name: t.String(), description: t.String() }) }
  );
