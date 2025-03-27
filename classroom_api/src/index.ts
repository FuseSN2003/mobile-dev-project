import cors from "@elysiajs/cors";
import { Elysia } from "elysia";
import { authRoute } from "./routes/auth";
import { classroomRoute } from "./routes/classroom";
import swagger from "@elysiajs/swagger";
import { fileRoute } from "./routes/file";
import { classroomAssignmentRoute } from "./routes/classroom-assignment";
import { assignmentRoute } from "./routes/assignment";

const app = new Elysia()
  .use(cors())
  .use(swagger())
  .onError(({ code, error, set }) => {
    switch (code) {
      case "VALIDATION": {
        set.status = 400;

        const validatorError = error.validator.Errors(error.value).First();

        const path = validatorError.path.split("/")[1];
        const pathValue = validatorError.value;

        if (pathValue === undefined || pathValue.trim() === "") {
          return {
            status: "error",
            message: `${path} is required`,
          };
        }

        if (validatorError.schema.error) {
          return {
            status: "error",
            message: validatorError.schema.error,
          };
        }

        if (validatorError.schema.enum) {
          return {
            status: "error",
            message: `${path} must be one of ${validatorError.schema.enum.join(
              ", "
            )}`,
          };
        }

        return {
          status: "error",
          message: `${path} ${validatorError.message.toLowerCase()}`,
        };
      }
      case "NOT_FOUND": {
        set.status = 404;
        return {
          status: "error",
          message: "NOT FOUND",
        };
      }
      default: {
        console.error(error);

        set.status = 500;
        return {
          status: "error",
          message: "Internal Server Error",
        };
      }
    }
  })
  .get("/", async ({ set }) => {
    set.status = 200;
    return {
      message: "Hello Elysia",
    };
  })
  .use(authRoute)
  .use(classroomRoute)
  .use(fileRoute)
  .use(assignmentRoute)
  .use(classroomAssignmentRoute)
  .listen(3000);

console.log(
  `🦊 Elysia is running at ${app.server?.hostname}:${app.server?.port}`
);
