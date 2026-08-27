"use server";

import {
    createAnimeFormOptions,
    CreateAnimeSchema,
    type LocalizedText,
} from "@/types/create-anime-schema";
import {
    ServerValidateError,
    createServerValidate,
} from "@tanstack/react-form-nextjs";
import { db } from "@/prisma/db";

const serverValidate = createServerValidate({
    ...createAnimeFormOptions,
    onServerValidate: CreateAnimeSchema,
});

export default async function createAnimeAction(
    prev: unknown,
    formData: FormData,
) {
    try {
        const validateData = await serverValidate(formData);

        const parsed = CreateAnimeSchema.safeParse(validateData);
        if (!parsed.success) {
            throw new Error("validateData 校验失败");
        }
        const data = parsed.data;

        await db.transaction(async (tx) => {
            // 先判断动画是否存在，如果存在则返回
            const existingAnime = await tx.orm.public.Anime.where((anime) =>
                anime.name.eq(data.animeName),
            ).first();
            if (existingAnime) return;

            // 如果不存在则创建
            const anime = await tx.orm.public.Anime.create({
                name: data.animeName,
                alias: {},
                overview: data.animeOverview,
            });

            const overview: LocalizedText = {
                zh: data.episodeOverview,
                en: "",
                ja: "",
            };

            await tx.orm.public.Episode.create({
                animeId: anime.id,
                name: data.episodeName,
                alias: {},
                seasonNumber: data.seasonNumber,
                episodeNumber: data.episodeNumber,
                airDate: data.airDate,
                overview,
                previewUrls: [],
            });
        });
    } catch (e) {
        if (e instanceof ServerValidateError) {
            return e.formState;
        }

        throw e;
    }
}
