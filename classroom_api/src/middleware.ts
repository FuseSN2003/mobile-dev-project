import jwt from "@elysiajs/jwt";
import Elysia from "elysia";
import { db } from "./libs/db";
import { eq } from "drizzle-orm";
import { userTable } from "./libs/db/schema";

export const middleware = new Elysia()
  .use(
    jwt({
      name: "jwt",
      secret: process.env.JWT_SECRET!,
    })
  )
  .derive({ as: "scoped" }, async ({ headers, jwt }) => {
    const token = headers["authorization"]?.split(" ")[1];

    if (!token) {
      return { user: null };
    }

    const user = await jwt.verify(token);

    if (!user) {
      return {
        user: null,
      };
    }

    const [userData] = await db
      .select()
      .from(userTable)
      .where(eq(userTable.id, user.id as string));
    if (!userData) {
      return { user: null };
    }
    return {
      user: userData,
    };
  });
