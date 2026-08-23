import { z } from 'zod';

export const CreateAnimeSchema = z.object({
    animeName: z.string(),
    brandId: z.string(),
    episodeName: z.string(),
    seasonNumber: z.string().transform((val) => Number(val)),
    episodeNumber: z.string().transform((val) => Number(val)),
    airDate: z.string(),
    overview: z.string(),
});

export type CreateAnimeIn = z.input<typeof CreateAnimeSchema>;
export type CreateAnimeOut = z.output<typeof CreateAnimeSchema>;
