import cors from "@elysiajs/cors";
import { Elysia } from "elysia";
import { authRoute } from "./routes/auth";
import { classroomRoute } from "./routes/classroom";
import swagger from "@elysiajs/swagger";
import { fileRoute } from "./routes/file";
import { classroomAssignmentRoute } from "./routes/classroom-assignment";

const app = new Elysia()
  .use(cors())
  .use(swagger())
  .onError(({ error, code, set }) => {
    switch (code) {
      case "NOT_FOUND": {
        set.status = 404;
        return {
          message: "Not found",
        };
      }

      case "VALIDATION": {
        set.status = 400;
        const pathError = error.validator
          .Errors(error.value)
          .First()
          .path.split("/")[1];

        if (
          !error.validator.Errors(error.value).First().value &&
          pathError
        ) {
          return {
            message: `${pathError} is required`,
          };
        }

        if (pathError) {
          return {
            message: `${pathError} ${error.validator
              .Errors(error.value)
              .First()
              .message.toLowerCase()}`,
          };
        }

        return {
          message: `${error.validator
            .Errors(error.value)
            .First()
            .message.toLowerCase()}`,
        };
      }
      default: {
        console.error(error);
        set.status = 500;
        return {
          message: "Internal server error",
        };
      }
    }
  })
  .get("/", () => "Hello Elysia")
  .use(authRoute)
  .use(classroomRoute)
  .use(fileRoute)
  .use(classroomAssignmentRoute)
  .listen(3000);

console.log(
  `🦊 Elysia is running at ${app.server?.hostname}:${app.server?.port}`
);