/* 
    Unfortunately in current drizzle-kit version we can't automatically get name for primary key.
    We are working on making it available!

    Meanwhile you can:
        1. Check pk name in your database, by running
            SELECT constraint_name FROM information_schema.table_constraints
            WHERE table_schema = 'public'
                AND table_name = 'assignment'
                AND constraint_type = 'PRIMARY KEY';
        2. Uncomment code below and paste pk name manually
        
    Hope to release this update as soon as possible
*/

-- ALTER TABLE "assignment" DROP CONSTRAINT "<constraint_name>";--> statement-breakpoint
ALTER TABLE "assignment" ADD CONSTRAINT "assignment_id_classroom_id_pk" PRIMARY KEY("id","classroom_id");