CREATE TABLE "assignment_attachment" (
	"assignment_id" uuid NOT NULL,
	"file_id" uuid NOT NULL,
	CONSTRAINT "assignment_attachment_file_id_assignment_id_pk" PRIMARY KEY("file_id","assignment_id")
);
--> statement-breakpoint
CREATE TABLE "file" (
	"id" uuid DEFAULT gen_random_uuid() NOT NULL,
	"file_name" text NOT NULL,
	"file_type" text NOT NULL,
	"url" text NOT NULL,
	"created_at" timestamp DEFAULT now() NOT NULL,
	"uploaded_by" uuid NOT NULL,
	CONSTRAINT "file_id_unique" UNIQUE("id")
);
--> statement-breakpoint
ALTER TABLE "assignment" DROP CONSTRAINT "assignment_id_classroom_id_pk";--> statement-breakpoint
ALTER TABLE "assignment" ADD PRIMARY KEY ("id");--> statement-breakpoint
ALTER TABLE "assignment_attachment" ADD CONSTRAINT "assignment_attachment_assignment_id_assignment_id_fk" FOREIGN KEY ("assignment_id") REFERENCES "public"."assignment"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "assignment_attachment" ADD CONSTRAINT "assignment_attachment_file_id_file_id_fk" FOREIGN KEY ("file_id") REFERENCES "public"."file"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "file" ADD CONSTRAINT "file_uploaded_by_user_account_id_fk" FOREIGN KEY ("uploaded_by") REFERENCES "public"."user_account"("id") ON DELETE cascade ON UPDATE no action;