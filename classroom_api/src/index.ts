import { Elysia } from "elysia";
import { node } from "@elysiajs/node";
import swagger from "@elysiajs/swagger";
import { authRoute } from "./routes/auth";

const app = new Elysia({ adapter: node() })
  .get("/", () => "Hello Elysia")
  .use(swagger({ provider: "swagger-ui" }))
  .use(authRoute)
  .listen(3000, ({ hostname, port }) => {
    console.log(`🦊 Elysia is running at ${hostname}:${port}`);
  });

export default app;