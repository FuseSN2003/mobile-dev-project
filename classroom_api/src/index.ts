import { Elysia } from "elysia";
import { node } from "@elysiajs/node";
import swagger from "@elysiajs/swagger";

const app = new Elysia({ adapter: node() })
  .get("/", () => "Hello Elysia")
  .use(swagger({ provider: "swagger-ui" }))
  .listen(3000);

console.log(
  `🦊 Elysia is running at ${app.server?.hostname}:${app.server?.port}`
);
