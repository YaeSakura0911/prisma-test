import { z } from "zod";
import { formOptions } from "@tanstack/react-form-nextjs";

export const CreateAnimeSchema = z.object({
    animeName: z.string().min(1, "Anime Name is Null!"),
    animeOverview: z.string(),
    episodeName: z.string().min(1, "Episode Name is Null!"),
    seasonNumber: z.string().transform((val) => Number(val)),
    episodeNumber: z.string().transform((val) => Number(val)),
    airDate: z.iso.date().transform((val) => new Date(val)),
    episodeOverview: z.string(),
});

export type CreateAnimeIn = z.input<typeof CreateAnimeSchema>;
export type CreateAnimeOut = z.output<typeof CreateAnimeSchema>;

export const createAnimeFormOptions = formOptions({
    defaultValues: {
        animeName: "test",
        animeOverview: "test",
        episodeName: "test",
        seasonNumber: "1",
        episodeNumber: "1",
        airDate: "2026-08-25",
        episodeOverview: "test",
    },
    validators: {
        onSubmit: CreateAnimeSchema,
        onBlur: CreateAnimeSchema,
        onChange: CreateAnimeSchema,
    },
});
