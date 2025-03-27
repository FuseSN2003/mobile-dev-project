import {
  boolean,
  char,
  integer,
  pgTable,
  primaryKey,
  text,
  timestamp,
  uuid,
} from "drizzle-orm/pg-core";
import { generateUniqueString } from "../utils";

export const userTable = pgTable("user_account", {
  id: uuid().primaryKey().unique().defaultRandom(),
  username: text().unique().notNull(),
  email: text().unique().notNull(),
  password: text().notNull(),
});

export const classroomTable = pgTable("classroom", {
  id: uuid().primaryKey().unique().defaultRandom(),
  code: char({ length: 6 })
    .unique()
    .notNull()
    .$default(() => generateUniqueString()),
  name: text().notNull(),
  description: text().notNull(),
  createdBy: uuid("created_by")
    .notNull()
    .references(() => userTable.id),
});

export const teachTable = pgTable(
  "teach",
  {
    userId: uuid("user_id")
      .notNull()
      .references(() => userTable.id, { onDelete: "cascade" }),
    classroomId: uuid("classroom_id")
      .notNull()
      .references(() => classroomTable.id, { onDelete: "cascade" }),
  },
  (t) => [primaryKey({ columns: [t.userId, t.classroomId] })]
);

export const studyTable = pgTable(
  "study",
  {
    userId: uuid("user_id")
      .notNull()
      .references(() => userTable.id, { onDelete: "cascade" }),
    classroomId: uuid("classroom_id")
      .notNull()
      .references(() => classroomTable.id, { onDelete: "cascade" }),
  },
  (t) => [primaryKey({ columns: [t.userId, t.classroomId] })]
);

export const assignmentTable = pgTable("assignment", {
  id: uuid().primaryKey().unique().notNull().defaultRandom(),
  classroomId: uuid("classroom_id")
    .notNull()
    .references(() => classroomTable.id, { onDelete: "cascade" }),
  title: text().notNull(),
  description: text().notNull(),
  dueDate: timestamp("due_date", { withTimezone: true }),
  maxScore: integer("max_score"),
  createdBy: uuid("created_by")
    .notNull()
    .references(() => userTable.id, { onDelete: "cascade" }),
  createdAt: timestamp("created_at", { withTimezone: true })
    .notNull()
    .defaultNow(),
});

export const fileTable = pgTable("file", {
  id: uuid().unique().notNull().defaultRandom(),
  fileName: text("file_name").notNull(),
  fileType: text("file_type").notNull(),
  url: text().notNull(),

  createdAt: timestamp("created_at", { withTimezone: true })
    .notNull()
    .defaultNow(),
  uploadedBy: uuid("uploaded_by")
    .notNull()
    .references(() => userTable.id, { onDelete: "cascade" }),
});

export const assignmentAttachmentTable = pgTable(
  "assignment_attachment",
  {
    assignmentId: uuid("assignment_id")
      .notNull()
      .references(() => assignmentTable.id, { onDelete: "cascade" }),
    fileId: uuid("file_id")
      .notNull()
      .references(() => fileTable.id, { onDelete: "cascade" }),
  },
  (t) => [primaryKey({ columns: [t.fileId, t.assignmentId] })]
);

export const assignmentSubmissionTable = pgTable(
  "assignment_submission",
  {
    assignmentId: uuid("assignment_id")
      .references(() => assignmentTable.id)
      .notNull(),
    userId: uuid("user_id")
      .references(() => userTable.id)
      .notNull(),
    score: integer(),

    isSubmitted: boolean("is_submitted").notNull().default(true),
    submittedAt: timestamp("submitted_at").notNull().defaultNow(),
  },
  (t) => [primaryKey({ columns: [t.assignmentId, t.userId] })]
);

export const submissionAttachmentTable = pgTable(
  "submission_attachment",
  {
    assignmentId: uuid("assignment_id")
      .notNull()
      .references(() => assignmentTable.id, { onDelete: "cascade" }),
    userId: uuid("user_id")
      .notNull()
      .references(() => userTable.id, { onDelete: "cascade" }),
    fileId: uuid("file_id")
      .notNull()
      .references(() => fileTable.id, { onDelete: "cascade" }),
  },
  (t) => [primaryKey({ columns: [t.userId, t.assignmentId, t.fileId] })]
);
