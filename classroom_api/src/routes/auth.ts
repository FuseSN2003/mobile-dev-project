import { db } from "@/lib/db";
import { userTable } from "@/lib/db/schema";
import { eq, or, sql } from "drizzle-orm";
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
    async ({ body, set, jwt }) => {
      const { password, confirmPassword } = body;
      const username = body.username.toLowerCase();
      const email = body.email.toLowerCase();

      if (password !== confirmPassword) {
        set.status = 400;
        return {
          status: "error",
          message: "Passwords do not match",
        };
      }

      const [existingUser] = await db
        .select({ id: userTable.id })
        .from(userTable)
        .where(
          or(
            eq(sql`lower(${userTable.username})`, username),
            eq(sql`lower(${userTable.email})`, email)
          )
        );

      if (existingUser) {
        set.status = 409;
        return {
          status: "error",
          message: "User already exists",
        };
      }

      const hashedPassword = await Bun.password.hash(password, {
        algorithm: "bcrypt",
        cost: 12,
      });

      const [result] = await db
        .insert(userTable)
        .values({
          username,
          email,
          password: hashedPassword,
        })
        .returning({
          id: userTable.id,
          username: userTable.username,
          email: userTable.email,
        });

      const token = await jwt.sign({
        id: result.id,
      });

      return {
        status: "success",
        message: "User registered successfully",
        token,
        user: result,
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
      const { password } = body;
      const username = body.username.toLowerCase();

      const [user] = await db
        .select()
        .from(userTable)
        .where(
          or(
            eq(sql`lower(${userTable.username})`, username),
            eq(sql`lower(${userTable.email})`, username)
          )
        );

      if (!user) {
        set.status = 400;
        return {
          status: "error",
          message: "Invalid username or password",
        };
      }

      const validPassword = await Bun.password.verify(password, user.password);

      if (!validPassword) {
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
        user: {
          id: user.id,
          username: user.username,
          email: user.email,
        },
        token,
      };
    },
    {
      body: t.Object({
        username: t.String(),
        password: t.String(),
      }),
    }
  )
  .get("/me", async ({ jwt, headers, set }) => {
    const token = headers["authorization"]?.split(" ")[1];

    const jwtPayload = await jwt.verify(token);

    if (!jwtPayload) {
      set.status = 401;
      return {
        message: "Invalid token",
      };
    }

    const userId = jwtPayload.id as string;

    const [user] = await db
      .select({
        id: userTable.id,
        username: userTable.username,
        email: userTable.email,
      })
      .from(userTable)
      .where(eq(userTable.id, userId));

    console.log(user);

    if (!user) {
      set.status = 401;
      return {
        status: "error",
        message: "Unauthorized",
      };
    }

    return {
      status: "success",
      message: "Authenticated",
      token,
      user,
    };
  });
