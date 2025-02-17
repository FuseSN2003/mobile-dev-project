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
  | { status: "success"; url: string }
  | { status: "error"; message: string };

export const uploadFile = async (file: File, allowType: "image" | "pdf") => {
  if (file.size === 0 || !file.size) {
    return {
      status: "error",
      message: "Empty file",
    };
  }

  if (!fileType[allowType].includes(file.type)) {
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

    return {
      status: "success",
      url,
    };
  } catch (error) {
    return {
      status: "error",
      message: `Failed to upload ${allowType} file`,
    }
  }
};
