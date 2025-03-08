import { db } from "@/libs/db";
import { fileTable } from "@/libs/db/schema";
import { eq } from "drizzle-orm";
import Elysia from "elysia";

export const fileRoute = new Elysia({ prefix: "/file" }).get(
  "/:fileName",
  async ({ params, headers }) => {
    const id = params.fileName.split(".")[0];

    const [result] = await db
      .select()
      .from(fileTable)
      .where(eq(fileTable.id, id));

    if (!result) {
      return {
        message: "File not found",
      };
    }

    const fileContent = Bun.file(
      `${process.env.UPLOAD_FOLDER}/${result.fileName}`
    );

    headers["Content-Type"] = result.fileType;
    return fileContent;
  }
);
