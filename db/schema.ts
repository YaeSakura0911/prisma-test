import { pgTable, integer, serial, text, timestamp, date, index, foreignKey, primaryKey, unique } from "drizzle-orm/pg-core"
import { sql } from "drizzle-orm"

export const anime = pgTable("anime", {
	id: serial().primaryKey(),
	brandId: integer("brand_id").references(() => brand.id),
	originalName: text("original_name").notNull(),
	createdAt: timestamp("created_at").default(sql`now()`).notNull(),
}, (table) => [
	unique("anime_original_name_key").on(table.originalName),]);

export const animeCharacter = pgTable("anime_character", {
	animeId: integer("anime_id").notNull().references(() => anime.id),
	characterId: integer("character_id").notNull().references(() => character.id),
	personId: integer("person_id").notNull().references(() => person.id),
}, (table) => [
	primaryKey({ columns: [table.animeId, table.characterId, table.personId], name: "anime_character_pkey"}),
]);

export const animeStaff = pgTable("anime_staff", {
	animeId: integer("anime_id").notNull().references(() => anime.id),
	personId: integer("person_id").notNull().references(() => person.id),
	positionId: integer("position_id").notNull().references(() => position.id),
}, (table) => [
	primaryKey({ columns: [table.animeId, table.personId, table.positionId], name: "anime_staff_pkey"}),
]);

export const animeTranslation = pgTable("anime_translation", {
	animeId: integer("anime_id").notNull().references(() => anime.id),
	localeCode: text("locale_code").notNull().references(() => locale.code, { onUpdate: "cascade" } ),
	translatedName: text("translated_name"),
	translatedOverview: text("translated_overview"),
}, (table) => [
	primaryKey({ columns: [table.animeId, table.localeCode], name: "anime_translation_pkey"}),
	index("idx_anime_translation_all").using("pgroonga", table.translatedName.asc().nullsLast(), table.translatedOverview.asc().nullsLast()),
	index("idx_anime_translation_locale").using("btree", table.localeCode.asc().nullsLast()),
	index("idx_anime_translation_translated_name").using("pgroonga", table.translatedName.asc().nullsLast()).with({ "tokenizer": "TokenMecab" }),
	index("idx_anime_translation_translated_overview").using("pgroonga", table.translatedOverview.asc().nullsLast()),
]);

export const brand = pgTable("brand", {
	id: serial().primaryKey(),
	originalName: text("original_name").notNull(),
	officialUrl: text("official_url"),
	logoUrl: text("logo_url"),
	createdAt: timestamp("created_at").default(sql`now()`),
}, (table) => [
	unique("brand_original_name_key").on(table.originalName),]);

export const character = pgTable("character", {
	id: serial().primaryKey(),
	name: text().notNull(),
	createdAt: timestamp("created_at").default(sql`now()`).notNull(),
});

export const episode = pgTable("episode", {
	id: serial().primaryKey(),
	animeId: integer("anime_id").references(() => anime.id),
	originalName: text("original_name").notNull(),
	productCode: text("product_code"),
	airDate: date("air_date").notNull(),
	seasonNumber: integer("season_number").notNull(),
	episodeNumber: integer("episode_number").notNull(),
	officialUrl: text("official_url").notNull(),
	coverUrl: text("cover_url"),
	posterUrl: text("poster_url"),
	previewUrls: text("preview_urls").array(),
	duration: integer(),
	createdAt: timestamp("created_at").default(sql`now()`).notNull(),
}, (table) => [
	unique("episode_anime_id_season_number_episode_number_key").on(table.animeId, table.seasonNumber, table.episodeNumber),	unique("episode_product_code_key").on(table.productCode),]);

export const episodeTag = pgTable("episode_tag", {
	episodeId: integer("episode_id").notNull().references(() => episode.id),
	tagId: integer("tag_id").notNull().references(() => tag.id),
}, (table) => [
	primaryKey({ columns: [table.episodeId, table.tagId], name: "episode_tag_pkey"}),
]);

export const episodeTranslation = pgTable("episode_translation", {
	episodeId: integer("episode_id").notNull().references(() => episode.id),
	localeCode: text("locale_code").notNull().references(() => locale.code),
	translatedName: text("translated_name"),
	translatedOverview: text("translated_overview"),
}, (table) => [
	primaryKey({ columns: [table.episodeId, table.localeCode], name: "episode_translation_pkey"}),
	index("idx_episode_translation_alias").using("pgroonga", table.translatedName.asc().nullsLast()).with({ "tokenizer": "TokenMecab" }),
	index("idx_episode_translation_all").using("pgroonga", table.translatedName.asc().nullsLast(), table.translatedOverview.asc().nullsLast()),
	index("idx_episode_translation_locale").using("btree", table.localeCode.asc().nullsLast()),
	index("idx_episode_translation_overview").using("pgroonga", table.translatedOverview.asc().nullsLast()),
]);

export const locale = pgTable("locale", {
	code: text().primaryKey(),
});

export const person = pgTable("person", {
	id: serial().primaryKey(),
	name: text().notNull(),
	createdAt: timestamp("created_at").default(sql`now()`).notNull(),
});

export const position = pgTable("position", {
	id: serial().primaryKey(),
	name: text().notNull(),
	createdAt: timestamp("created_at").default(sql`now()`).notNull(),
}, (table) => [
	unique("position_name_key").on(table.name),]);

export const tag = pgTable("tag", {
	id: serial().primaryKey(),
	name: text().notNull(),
	createdAt: timestamp("created_at").default(sql`now()`).notNull(),
}, (table) => [
	unique("tag_name_key").on(table.name),]);
