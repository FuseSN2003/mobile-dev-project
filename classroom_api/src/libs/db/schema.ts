import {
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
  id: uuid().primaryKey().unique().defaultRandom(),
  classroomId: uuid("classroom_id")
    .notNull()
    .references(() => classroomTable.id, { onDelete: "cascade" }),
  title: text().notNull(),
  description: text().notNull(),
  dueDate: timestamp("due_date"),
  maxScore: integer("max_score"),
  createdBy: uuid("created_by")
    .notNull()
    .references(() => userTable.id, { onDelete: "cascade" }),
  createdAt: timestamp("created_at").notNull().defaultNow(),
});
