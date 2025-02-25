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
    async ({ body, set, jwt }) => {
      const { username, email, password, confirmPassword } = body;

      if (password !== confirmPassword) {
        set.status = 400;
        return {
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
          message: "User already exists",
        };
      }

      const hashedPassword = await Bun.password.hash(password, "bcrypt");

      const [result] = await db.insert(userTable).values({
        username,
        email,
        password: hashedPassword,
      }).returning({
        id: userTable.id,
        username: userTable.username,
        email: userTable.email,
      });

      const token = await jwt.sign({
        id: result.id,
      })

      return {
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
          message: "Invalid username or password",
        };
      }

      const token = await jwt.sign({
        id: user.id,
      });

      return {
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
  ).get("/me", async ({ jwt, headers, set }) => {
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

    if(!user) {
      set.status = 401;
      return {
        message: "Invalid token",
      };
    }

    return {
      message: "Authenticated",
      token,
      user,
    };
  });
