import cors from "@elysiajs/cors";
import { Elysia } from "elysia";
import { authRoute } from "./routes/auth";
import { classroomRoute } from "./routes/classroom";
import swagger from "@elysiajs/swagger";

const app = new Elysia()
  .use(cors())
  .use(swagger())
  .onError(({ set, error }) => {
    set.status = 500;
    return {
      status: "error",
      message: "Internal server error",
    };
  })
  .get("/", () => "Hello Elysia")
  .use(authRoute)
  .use(classroomRoute)
  .listen(3000);

console.log(
  `🦊 Elysia is running at ${app.server?.hostname}:${app.server?.port}`
);
