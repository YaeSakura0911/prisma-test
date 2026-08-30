import z from "zod";

const locale = "zh";

export const AnimeListItemSchema = z.object({
    id: z.number(),
    name: z.string(),
    airDate: z.date().transform((val) =>
        val.toLocaleDateString(locale, {
            year: "numeric",
            month: "2-digit",
            day: "2-digit",
        }),
    ),
    posterUrl: z.string(),
});

export type AnimeListItemIn = z.input<typeof AnimeListItemSchema>;
export type AnimeListItemOut = z.output<typeof AnimeListItemSchema>;
