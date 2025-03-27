import { db } from "./db";
import { fileTable } from "./db/schema";

export const fileExtension: { [key: string]: string } = {
  "image/jpeg": "jpg",
  "image/png": "png",
  "image/webp": "webp",
  "application/pdf": "pdf",
};

export const fileType = {
  image: ["image/jpeg", "image/png", "image/webp"],
  pdf: ["application/pdf"],
};

type UploadFileResult =
  | { status: "success"; id: string }
  | { status: "error"; message: string };

export const uploadFile = async (file: File, uploadedById: string): Promise<UploadFileResult> => {
  if (file.size === 0 || !file.size) {
    return {
      status: "error",
      message: "Empty file",
    };
  }

  if (
    !fileType["image"].includes(file.type) &&
    !fileType["pdf"].includes(file.type)
  ) {
    return {
      status: "error",
      message: "Not supported file type",
    };
  }

  if (!process.env.UPLOAD_FOLDER) {
    return {
      status: "error",
      message: "UPLOAD_FOLDER is not set",
    };
  }

  const id = crypto.randomUUID();
  const fileName = `${id}.${fileExtension[file.type]}`;
  const path = `${process.env.UPLOAD_FOLDER}/${fileName}`;
  const url = `/file/${fileName}`;

  try {
    await Bun.write(path, file);

    await db.insert(fileTable).values({
      id,
      fileName,
      fileType: file.type,
      url,
      uploadedBy: uploadedById,
    })

    return {
      status: "success",
      id,
    };
  } catch (error) {
    return {
      status: "error",
      message: `Failed to upload file`,
    };
  }
};
