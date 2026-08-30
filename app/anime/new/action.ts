"use server";

import {
    createAnimeFormOptions,
    CreateAnimeSchema,
} from "@/types/create-anime-schema";
import {
    ServerValidateError,
    createServerValidate,
} from "@tanstack/react-form-nextjs";
import { prisma } from "@/lib/prisma";

const serverValidate = createServerValidate({
    ...createAnimeFormOptions,
    onServerValidate: CreateAnimeSchema,
});

const locale = "ja";

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

        await prisma.$transaction(async (tx) => {
            // 先判断动画是否存在，如果存在则返回
            const existingAnime = await tx.anime.findUnique({
                where: {
                    name: data.animeName,
                },
            });
            if (existingAnime) {
                console.log("Anime Is Existing!");
                return;
            }

            // 创建动画
            const anime = await tx.anime.create({
                data: {
                    name: data.animeName,
                    alias: { locale: data.animeName },
                    overview: { locale: data.animeOverview },
                },
            });

            // 创建剧集
            await tx.episode.create({
                data: {
                    animeId: anime.id,
                    name: data.episodeName,
                    alias: { locale: data.episodeName },
                    seasonNumber: data.seasonNumber,
                    episodeNumber: data.episodeNumber,
                    airDate: data.airDate,
                    overview: { locale: data.episodeOverview },
                    previewUrls: [],
                },
            });
        });
    } catch (e) {
        if (e instanceof ServerValidateError) {
            return e.formState;
        }

        throw e;
    }
}
