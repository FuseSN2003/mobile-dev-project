CREATE TABLE "classroom" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"code" char(6) NOT NULL,
	"name" text NOT NULL,
	"description" text NOT NULL,
	CONSTRAINT "classroom_id_unique" UNIQUE("id"),
	CONSTRAINT "classroom_code_unique" UNIQUE("code")
);
--> statement-breakpoint
CREATE TABLE "study" (
	"user_id" uuid NOT NULL,
	"classroom_id" uuid NOT NULL,
	CONSTRAINT "study_user_id_classroom_id_pk" PRIMARY KEY("user_id","classroom_id")
);
--> statement-breakpoint
CREATE TABLE "teach" (
	"user_id" uuid NOT NULL,
	"classroom_id" uuid NOT NULL,
	CONSTRAINT "teach_user_id_classroom_id_pk" PRIMARY KEY("user_id","classroom_id")
);
--> statement-breakpoint
CREATE TABLE "user_account" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"username" text NOT NULL,
	"email" text NOT NULL,
	"password" text NOT NULL,
	CONSTRAINT "user_account_id_unique" UNIQUE("id"),
	CONSTRAINT "user_account_username_unique" UNIQUE("username"),
	CONSTRAINT "user_account_email_unique" UNIQUE("email")
);
--> statement-breakpoint
ALTER TABLE "study" ADD CONSTRAINT "study_user_id_user_account_id_fk" FOREIGN KEY ("user_id") REFERENCES "public"."user_account"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "study" ADD CONSTRAINT "study_classroom_id_classroom_id_fk" FOREIGN KEY ("classroom_id") REFERENCES "public"."classroom"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "teach" ADD CONSTRAINT "teach_user_id_user_account_id_fk" FOREIGN KEY ("user_id") REFERENCES "public"."user_account"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "teach" ADD CONSTRAINT "teach_classroom_id_classroom_id_fk" FOREIGN KEY ("classroom_id") REFERENCES "public"."classroom"("id") ON DELETE cascade ON UPDATE no action;