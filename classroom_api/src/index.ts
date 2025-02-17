import { Elysia } from "elysia";
import { node } from "@elysiajs/node";
import swagger from "@elysiajs/swagger";
import { authRoute } from "./routes/auth";
import cors from "@elysiajs/cors";
import { classroomRoute } from "./routes/classroom";

const app = new Elysia({ adapter: node() })
  .get("/", () => "Hello Elysia")
  .use(swagger({ provider: "swagger-ui" }))
  .use(cors())
  .use(authRoute)
  .use(classroomRoute)
  .listen(3000, ({ hostname, port }) => {
    console.log(`🦊 Elysia is running at ${hostname}:${port}`);
  });

export default app;