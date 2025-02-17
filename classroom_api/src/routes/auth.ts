import { db } from "@/libs/db";
import { userTable } from "@/libs/db/schema";
import { eq, or } from "drizzle-orm";
import Elysia, { t } from "elysia";
import { jwt } from "@elysiajs/jwt";

export const authRoute = new Elysia({ prefix: "/auth" })
  .use(
    jwt({
      name: "jwt",
      secret: process.env.JWT_SECRET!,
    })
  )
  .post(
    "/register",
    async ({ body, set }) => {
      const { username, email, password, confirmPassword } = body;

      if (password !== confirmPassword) {
        set.status = 400;
        return {
          status: "error",
          message: "Passwords do not match",
        };
      }

      const [existingUser] = await db
        .select()
        .from(userTable)
        .where(
          or(eq(userTable.username, username), eq(userTable.email, email))
        );

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
        email: t.String({ format: "email" }),
        password: t.String(),
        confirmPassword: t.String(),
      }),
    }
  )
  .post(
    "/login",
    async ({ body, set, jwt }) => {
      const { username, password } = body;

      const [user] = await db
        .select()
        .from(userTable)
        .where(
          or(eq(userTable.username, username), eq(userTable.email, username))
        );

      if (!user) {
        set.status = 400;
        return {
          status: "error",
          message: "Invalid username or password",
        };
      }

      const isPasswordValid = await Bun.password.verify(
        password,
        user.password
      );

      if (!isPasswordValid) {
        set.status = 400;
        return {
          status: "error",
          message: "Invalid username or password",
        };
      }

      const token = await jwt.sign({
        id: user.id,
      });

      return {
        status: "success",
        message: "User logged in successfully",
        token,
      };
    },
    {
      body: t.Object({
        username: t.String(),
        password: t.String(),
      }),
    }
  );
