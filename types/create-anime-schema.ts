import { z } from 'zod';
import { formOptions } from '@tanstack/react-form-nextjs';

export const CreateAnimeSchema = z.object({
    animeName: z.string(),
    animeOverview: z.string(),
    episodeName: z.string(),
    seasonNumber: z.string().transform((val) => parseInt(val, 10)),
    episodeNumber: z.string().transform((val) => parseInt(val, 10)),
    airDate: z.string(),
    episodeOverview: z.string(),
});

export type CreateAnimeIn = z.input<typeof CreateAnimeSchema>;
export type CreateAnimeOut = z.output<typeof CreateAnimeSchema>;

export const createAnimeFormOptions = formOptions({
    defaultValues: {
        animeName: '',
        animeOverview: '',
        episodeName: '',
        seasonNumber: '1',
        episodeNumber: '1',
        airDate: '',
        episodeOverview: '',
    },
    validators: {
        onChange: CreateAnimeSchema,
        onBlur: CreateAnimeSchema,
        onSubmit: CreateAnimeSchema,
    },
});
