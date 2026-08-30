import { z } from "zod";

export const EpisodeListItemSchema = z.object({
    id: z.number(),
    name: z.string(),
    airDate: z
        .date()
        .transform((val) =>
            val.toLocaleDateString("zh", {
                year: "numeric",
                month: "2-digit",
                day: "2-digit",
            }),
        ),
});

export type EpisodeListItemIn = z.input<typeof EpisodeListItemSchema>;
export type EpisodeListItemOut = z.output<typeof EpisodeListItemSchema>;
