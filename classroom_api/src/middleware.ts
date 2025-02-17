import jwt from "@elysiajs/jwt";
import node from "@elysiajs/node";
import Elysia from "elysia";

export const middleware = new Elysia({ adapter: node() })
  .use(
    jwt({
      name: "jwt",
      secret: process.env.JWT_SECRET!,
    })
  )
  .derive({ as: "scoped" }, async ({ headers, jwt }) => {
    const token = headers["authorization"];

    if (!token) {
      return { user: null };
    }

    const user = await jwt.verify(token);

    if (!user) {
      return {
        user: null,
      };
    }

    return { user };
  });
