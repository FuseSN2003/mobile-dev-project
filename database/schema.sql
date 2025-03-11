CREATE TABLE IF NOT EXISTS "public"."assignment" (
    "id" uuid DEFAULT gen_random_uuid() NOT NULL,
    "classroom_id" uuid NOT NULL,
    "title" text NOT NULL,
    "description" text NOT NULL,
    "due_date" timestamptz,
    "max_score" integer,
    "created_by" uuid NOT NULL,
    "created_at" timestamptz DEFAULT now() NOT NULL,
    CONSTRAINT "assignment_pkey" PRIMARY KEY ("id")
) WITH (oids = false);

CREATE TABLE IF NOT EXISTS "public"."assignment_attachment" (
    "assignment_id" uuid NOT NULL,
    "file_id" uuid NOT NULL,
    CONSTRAINT "assignment_attachment_file_id_assignment_id_pk" PRIMARY KEY ("file_id", "assignment_id")
) WITH (oids = false);

CREATE TABLE IF NOT EXISTS "public"."assignment_submission" (
    "assignment_id" uuid NOT NULL,
    "user_id" uuid NOT NULL,
    "score" integer,
    "is_submitted" boolean DEFAULT true NOT NULL,
    "submitted_at" timestamp DEFAULT now() NOT NULL,
    CONSTRAINT "assignment_submission_assignment_id_user_id_pk" PRIMARY KEY ("assignment_id", "user_id")
) WITH (oids = false);

CREATE TABLE IF NOT EXISTS "public"."classroom" (
    "id" uuid DEFAULT gen_random_uuid() NOT NULL,
    "code" character(6) NOT NULL,
    "name" text NOT NULL,
    "description" text NOT NULL,
    "created_by" uuid NOT NULL,
    CONSTRAINT "classroom_id_unique" PRIMARY KEY ("id")
) WITH (oids = false);

CREATE UNIQUE INDEX IF NOT EXISTS classroom_code_unique ON public.classroom USING btree (code);

CREATE TABLE IF NOT EXISTS "public"."file" (
    "id" uuid DEFAULT gen_random_uuid() NOT NULL,
    "file_name" text NOT NULL,
    "file_type" text NOT NULL,
    "url" text NOT NULL,
    "created_at" timestamptz DEFAULT now() NOT NULL,
    "uploaded_by" uuid NOT NULL
) WITH (oids = false);

CREATE UNIQUE INDEX IF NOT EXISTS file_id_unique ON public.file USING btree (id);

CREATE TABLE IF NOT EXISTS "public"."study" (
    "user_id" uuid NOT NULL,
    "classroom_id" uuid NOT NULL,
    CONSTRAINT "study_user_id_classroom_id_pk" PRIMARY KEY ("user_id", "classroom_id")
) WITH (oids = false);

CREATE TABLE IF NOT EXISTS "public"."submission_attachment" (
    "assignment_id" uuid NOT NULL,
    "user_id" uuid NOT NULL,
    "file_id" uuid NOT NULL,
    CONSTRAINT "submission_attachment_user_id_assignment_id_file_id_pk" PRIMARY KEY ("user_id", "assignment_id", "file_id")
) WITH (oids = false);

CREATE TABLE IF NOT EXISTS "public"."teach" (
    "user_id" uuid NOT NULL,
    "classroom_id" uuid NOT NULL,
    CONSTRAINT "teach_user_id_classroom_id_pk" PRIMARY KEY ("user_id", "classroom_id")
) WITH (oids = false);

CREATE TABLE IF NOT EXISTS "public"."user_account" (
    "id" uuid DEFAULT gen_random_uuid() NOT NULL,
    "username" text NOT NULL,
    "email" text NOT NULL,
    "password" text NOT NULL,
    CONSTRAINT "user_account_id_unique" PRIMARY KEY ("id")
) WITH (oids = false);

CREATE UNIQUE INDEX IF NOT EXISTS user_account_username_unique ON public.user_account USING btree (username);
CREATE UNIQUE INDEX IF NOT EXISTS user_account_email_unique ON public.user_account USING btree (email);

DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM information_schema.table_constraints WHERE constraint_name = 'assignment_classroom_id_classroom_id_fk') THEN
        ALTER TABLE "public"."assignment" ADD CONSTRAINT "assignment_classroom_id_classroom_id_fk" FOREIGN KEY (classroom_id) REFERENCES classroom(id) ON DELETE CASCADE;
    END IF;
    IF NOT EXISTS (SELECT 1 FROM information_schema.table_constraints WHERE constraint_name = 'assignment_created_by_user_account_id_fk') THEN
        ALTER TABLE "public"."assignment" ADD CONSTRAINT "assignment_created_by_user_account_id_fk" FOREIGN KEY (created_by) REFERENCES user_account(id) ON DELETE CASCADE;
    END IF;
    IF NOT EXISTS (SELECT 1 FROM information_schema.table_constraints WHERE constraint_name = 'assignment_attachment_assignment_id_assignment_id_fk') THEN
        ALTER TABLE "public"."assignment_attachment" ADD CONSTRAINT "assignment_attachment_assignment_id_assignment_id_fk" FOREIGN KEY (assignment_id) REFERENCES assignment(id) ON DELETE CASCADE;
    END IF;
    IF NOT EXISTS (SELECT 1 FROM information_schema.table_constraints WHERE constraint_name = 'assignment_attachment_file_id_file_id_fk') THEN
        ALTER TABLE "public"."assignment_attachment" ADD CONSTRAINT "assignment_attachment_file_id_file_id_fk" FOREIGN KEY (file_id) REFERENCES file(id) ON DELETE CASCADE;
    END IF;
    IF NOT EXISTS (SELECT 1 FROM information_schema.table_constraints WHERE constraint_name = 'assignment_submission_assignment_id_assignment_id_fk') THEN
        ALTER TABLE "public"."assignment_submission" ADD CONSTRAINT "assignment_submission_assignment_id_assignment_id_fk" FOREIGN KEY (assignment_id) REFERENCES assignment(id);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM information_schema.table_constraints WHERE constraint_name = 'assignment_submission_user_id_user_account_id_fk') THEN
        ALTER TABLE "public"."assignment_submission" ADD CONSTRAINT "assignment_submission_user_id_user_account_id_fk" FOREIGN KEY (user_id) REFERENCES user_account(id);
    END IF;
END $$;
