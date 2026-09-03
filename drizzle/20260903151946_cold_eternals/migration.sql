-- Current sql file was generated after introspecting the database
-- If you want to run this migration please uncomment this code before executing migrations
/*
CREATE TABLE "anime" (
	"id" serial PRIMARY KEY,
	"brand_id" integer,
	"original_name" text NOT NULL CONSTRAINT "anime_original_name_key" UNIQUE,
	"created_at" timestamp DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "anime_character" (
	"anime_id" integer,
	"character_id" integer,
	"person_id" integer,
	CONSTRAINT "anime_character_pkey" PRIMARY KEY("anime_id","character_id","person_id")
);
--> statement-breakpoint
CREATE TABLE "anime_staff" (
	"anime_id" integer,
	"person_id" integer,
	"position_id" integer,
	CONSTRAINT "anime_staff_pkey" PRIMARY KEY("anime_id","person_id","position_id")
);
--> statement-breakpoint
CREATE TABLE "anime_translation" (
	"anime_id" integer,
	"locale_code" text,
	"translated_name" text,
	"translated_overview" text,
	CONSTRAINT "anime_translation_pkey" PRIMARY KEY("anime_id","locale_code")
);
--> statement-breakpoint
CREATE TABLE "brand" (
	"id" serial PRIMARY KEY,
	"original_name" text NOT NULL CONSTRAINT "brand_original_name_key" UNIQUE,
	"official_url" text,
	"logo_url" text,
	"created_at" timestamp DEFAULT now()
);
--> statement-breakpoint
CREATE TABLE "character" (
	"id" serial PRIMARY KEY,
	"name" text NOT NULL,
	"created_at" timestamp DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "episode" (
	"id" serial PRIMARY KEY,
	"anime_id" integer,
	"original_name" text NOT NULL,
	"product_code" text CONSTRAINT "episode_product_code_key" UNIQUE,
	"air_date" date NOT NULL,
	"season_number" integer NOT NULL,
	"episode_number" integer NOT NULL,
	"official_url" text NOT NULL,
	"cover_url" text,
	"poster_url" text,
	"preview_urls" text[],
	"duration" integer,
	"created_at" timestamp DEFAULT now() NOT NULL,
	CONSTRAINT "episode_anime_id_season_number_episode_number_key" UNIQUE("anime_id","season_number","episode_number")
);
--> statement-breakpoint
CREATE TABLE "episode_tag" (
	"episode_id" integer,
	"tag_id" integer,
	CONSTRAINT "episode_tag_pkey" PRIMARY KEY("episode_id","tag_id")
);
--> statement-breakpoint
CREATE TABLE "episode_translation" (
	"episode_id" integer,
	"locale_code" text,
	"translated_name" text,
	"translated_overview" text,
	CONSTRAINT "episode_translation_pkey" PRIMARY KEY("episode_id","locale_code")
);
--> statement-breakpoint
CREATE TABLE "locale" (
	"code" text PRIMARY KEY
);
--> statement-breakpoint
CREATE TABLE "person" (
	"id" serial PRIMARY KEY,
	"name" text NOT NULL,
	"created_at" timestamp DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "position" (
	"id" serial PRIMARY KEY,
	"name" text NOT NULL CONSTRAINT "position_name_key" UNIQUE,
	"created_at" timestamp DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "tag" (
	"id" serial PRIMARY KEY,
	"name" text NOT NULL CONSTRAINT "tag_name_key" UNIQUE,
	"created_at" timestamp DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE INDEX "idx_anime_translation_all" ON "anime_translation" USING pgroonga ("translated_name","translated_overview");--> statement-breakpoint
CREATE INDEX "idx_anime_translation_locale" ON "anime_translation" ("locale_code");--> statement-breakpoint
CREATE INDEX "idx_anime_translation_translated_name" ON "anime_translation" USING pgroonga ("translated_name") WITH (tokenizer=TokenMecab);--> statement-breakpoint
CREATE INDEX "idx_anime_translation_translated_overview" ON "anime_translation" USING pgroonga ("translated_overview");--> statement-breakpoint
CREATE INDEX "idx_episode_translation_alias" ON "episode_translation" USING pgroonga ("translated_name") WITH (tokenizer=TokenMecab);--> statement-breakpoint
CREATE INDEX "idx_episode_translation_all" ON "episode_translation" USING pgroonga ("translated_name","translated_overview");--> statement-breakpoint
CREATE INDEX "idx_episode_translation_locale" ON "episode_translation" ("locale_code");--> statement-breakpoint
CREATE INDEX "idx_episode_translation_overview" ON "episode_translation" USING pgroonga ("translated_overview");--> statement-breakpoint
ALTER TABLE "anime" ADD CONSTRAINT "anime_brand_id_fkey" FOREIGN KEY ("brand_id") REFERENCES "brand"("id");--> statement-breakpoint
ALTER TABLE "anime_translation" ADD CONSTRAINT "anime_translation_anime_id_fkey" FOREIGN KEY ("anime_id") REFERENCES "anime"("id");--> statement-breakpoint
ALTER TABLE "anime_translation" ADD CONSTRAINT "anime_translation_locale_code_fkey" FOREIGN KEY ("locale_code") REFERENCES "locale"("code") ON UPDATE CASCADE;--> statement-breakpoint
ALTER TABLE "episode" ADD CONSTRAINT "episode_anime_id_fkey" FOREIGN KEY ("anime_id") REFERENCES "anime"("id");--> statement-breakpoint
ALTER TABLE "episode_translation" ADD CONSTRAINT "episode_translation_episode_id_fkey" FOREIGN KEY ("episode_id") REFERENCES "episode"("id");--> statement-breakpoint
ALTER TABLE "episode_translation" ADD CONSTRAINT "episode_translation_locale_code_fkey" FOREIGN KEY ("locale_code") REFERENCES "locale"("code");--> statement-breakpoint
ALTER TABLE "episode_tag" ADD CONSTRAINT "episode_tag_episode_id_fkey" FOREIGN KEY ("episode_id") REFERENCES "episode"("id");--> statement-breakpoint
ALTER TABLE "episode_tag" ADD CONSTRAINT "episode_tag_tag_id_fkey" FOREIGN KEY ("tag_id") REFERENCES "tag"("id");--> statement-breakpoint
ALTER TABLE "anime_character" ADD CONSTRAINT "anime_character_anime_id_fkey" FOREIGN KEY ("anime_id") REFERENCES "anime"("id");--> statement-breakpoint
ALTER TABLE "anime_character" ADD CONSTRAINT "anime_character_character_id_fkey" FOREIGN KEY ("character_id") REFERENCES "character"("id");--> statement-breakpoint
ALTER TABLE "anime_character" ADD CONSTRAINT "anime_character_person_id_fkey" FOREIGN KEY ("person_id") REFERENCES "person"("id");--> statement-breakpoint
ALTER TABLE "anime_staff" ADD CONSTRAINT "anime_staff_anime_id_fkey" FOREIGN KEY ("anime_id") REFERENCES "anime"("id");--> statement-breakpoint
ALTER TABLE "anime_staff" ADD CONSTRAINT "anime_staff_person_id_fkey" FOREIGN KEY ("person_id") REFERENCES "person"("id");--> statement-breakpoint
ALTER TABLE "anime_staff" ADD CONSTRAINT "anime_staff_position_id_fkey" FOREIGN KEY ("position_id") REFERENCES "position"("id");
*/