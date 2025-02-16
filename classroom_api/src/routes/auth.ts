import { db } from "@/libs/db";
import { userTable } from "@/libs/db/schema";
import { eq, or } from "drizzle-orm";
import Elysia, { t } from "elysia";

export const authRoute = new Elysia({ prefix: "/auth" }).post(
  "/register",
  async ({ body, set }) => {
    const { username, email, password, confirmPassword } = body;

    if (password !== confirmPassword) {
      set.status = 400;
      return {
        status: "error",
        body: {
          message: "Passwords do not match",
        },
      };
    }

    const [existingUser] = await db
      .select()
      .from(userTable)
      .where(or(eq(userTable.username, username), eq(userTable.email, email)));

    if (existingUser) {
      set.status = 400;
      return {
        status: "error",
        message: "User already exists",
      };
    }

    const hashedPassword = await Bun.password.hash(password, "bcrypt");

    await db.insert(userTable).values({
      username,
      email,
      password: hashedPassword,
    });

    return {
      status: "success",
      message: "User registered successfully",
    };
  },
  {
    body: t.Object({
      username: t.String(),
      email: t.String(),
      password: t.String(),
      confirmPassword: t.String(),
    }),
  }
);
