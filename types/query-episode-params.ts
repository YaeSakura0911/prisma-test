import { formOptions } from "@tanstack/react-form";
import {z} from "zod";

export const QueryEpisodeParamsSchema = z.object({
    page: z.string().transform((val) => Number(val)),
    size: z.string().transform((val) => Number(val)),
    brandId: z.string().transform((val) => Number(val)).optional(),
    tagIds: z.string().array().optional()
})

export type QueryEpisodeParamsIn = z.input<typeof QueryEpisodeParamsSchema>
export type QueryEpisodeParamsOut = z.output<typeof QueryEpisodeParamsSchema>

export const queryEpisodeFormOptions = formOptions({
    defaultValues: {
        page: "1",
        size: "10",
        brand: "",
        tags: []
    }
})