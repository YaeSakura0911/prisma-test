import { defineRelations } from "drizzle-orm";
import * as schema from "@/db/schema";

export const relations = defineRelations(schema, (r) => ({
	anime: {
		brand: r.one.brand({
			from: r.anime.brandId,
			to: r.brand.id
		}),
		animeCharacters: r.many.animeCharacter(),
		animeStaffs: r.many.animeStaff(),
		locales: r.many.locale({
			from: r.anime.id.through(r.animeTranslation.animeId),
			to: r.locale.code.through(r.animeTranslation.localeCode)
		}),
		episodes: r.many.episode(),
	},
	brand: {
		anime: r.many.anime(),
	},
	animeCharacter: {
		anime: r.one.anime({
			from: r.animeCharacter.animeId,
			to: r.anime.id
		}),
		character: r.one.character({
			from: r.animeCharacter.characterId,
			to: r.character.id
		}),
		person: r.one.person({
			from: r.animeCharacter.personId,
			to: r.person.id
		}),
	},
	character: {
		animeCharacters: r.many.animeCharacter(),
	},
	person: {
		animeCharacters: r.many.animeCharacter(),
		animeStaffs: r.many.animeStaff(),
	},
	animeStaff: {
		anime: r.one.anime({
			from: r.animeStaff.animeId,
			to: r.anime.id
		}),
		person: r.one.person({
			from: r.animeStaff.personId,
			to: r.person.id
		}),
		position: r.one.position({
			from: r.animeStaff.positionId,
			to: r.position.id
		}),
	},
	position: {
		animeStaffs: r.many.animeStaff(),
	},
	locale: {
		anime: r.many.anime(),
		episodes: r.many.episode(),
	},
	episode: {
		anime: r.one.anime({
			from: r.episode.animeId,
			to: r.anime.id
		}),
		tags: r.many.tag({
			from: r.episode.id.through(r.episodeTag.episodeId),
			to: r.tag.id.through(r.episodeTag.tagId)
		}),
		locales: r.many.locale({
			from: r.episode.id.through(r.episodeTranslation.episodeId),
			to: r.locale.code.through(r.episodeTranslation.localeCode)
		}),
	},
	tag: {
		episodes: r.many.episode(),
	},
}))