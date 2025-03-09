ALTER TABLE "assignment" ALTER COLUMN "due_date" SET DATA TYPE timestamp with time zone;--> statement-breakpoint
ALTER TABLE "assignment" ALTER COLUMN "created_at" SET DATA TYPE timestamp with time zone;--> statement-breakpoint
ALTER TABLE "file" ALTER COLUMN "created_at" SET DATA TYPE timestamp with time zone;