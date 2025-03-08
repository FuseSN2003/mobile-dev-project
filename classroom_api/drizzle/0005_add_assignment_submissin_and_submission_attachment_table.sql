CREATE TABLE "assignment_submission" (
	"assignment_id" uuid NOT NULL,
	"user_id" uuid NOT NULL,
	"score" integer,
	"is_submitted" boolean DEFAULT true NOT NULL,
	"submitted_at" timestamp DEFAULT now() NOT NULL,
	CONSTRAINT "assignment_submission_assignment_id_user_id_pk" PRIMARY KEY("assignment_id","user_id")
);
--> statement-breakpoint
CREATE TABLE "submission_attachment" (
	"assignment_id" uuid NOT NULL,
	"user_id" uuid NOT NULL,
	"file_id" uuid NOT NULL,
	CONSTRAINT "submission_attachment_user_id_assignment_id_file_id_pk" PRIMARY KEY("user_id","assignment_id","file_id")
);
--> statement-breakpoint
ALTER TABLE "assignment_submission" ADD CONSTRAINT "assignment_submission_assignment_id_assignment_id_fk" FOREIGN KEY ("assignment_id") REFERENCES "public"."assignment"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "assignment_submission" ADD CONSTRAINT "assignment_submission_user_id_user_account_id_fk" FOREIGN KEY ("user_id") REFERENCES "public"."user_account"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "submission_attachment" ADD CONSTRAINT "submission_attachment_assignment_id_assignment_id_fk" FOREIGN KEY ("assignment_id") REFERENCES "public"."assignment"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "submission_attachment" ADD CONSTRAINT "submission_attachment_user_id_user_account_id_fk" FOREIGN KEY ("user_id") REFERENCES "public"."user_account"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "submission_attachment" ADD CONSTRAINT "submission_attachment_file_id_file_id_fk" FOREIGN KEY ("file_id") REFERENCES "public"."file"("id") ON DELETE cascade ON UPDATE no action;