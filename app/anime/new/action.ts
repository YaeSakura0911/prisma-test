'use server';

import prisma from '@/lib/prisma';
import {
    ServerValidateError,
    createServerValidate,
} from '@tanstack/react-form-nextjs';
import {
    CreateAnimeIn,
    CreateAnimeOut,
    CreateAnimeSchema,
    createAnimeFormOptions,
} from '@/types/create-anime-schema';

const serverValidate = createServerValidate({
    ...createAnimeFormOptions,
    onServerValidate: CreateAnimeSchema,
});

export async function createAnimeAction(prev: unknown, formData: FormData) {
    try {
        const validateData: CreateAnimeIn = await serverValidate(formData);
        const parsedData: CreateAnimeOut =
            CreateAnimeSchema.parse(validateData);
        console.log(validateData);

        // 先判断动画是否存在
        const existingAnime = await prisma.anime.findUnique({
            where: { name: parsedData.animeName },
        });
        if (existingAnime) {
            console.log(existingAnime);
            // TODO: 如果动画存在则跳转到动画页
            return;
        }

        // 如果动画不存在则启用事务，先创建动画，再创建剧集
        const result = await prisma.$transaction(async (tx) => {
            const anime = await tx.anime.create({
                data: {
                    name: parsedData.animeName,
                    alias: {},
                    overview: parsedData.animeOverview,
                },
            });

            const episode = await tx.episode.create({
                data: {
                    name: parsedData.episodeName,
                    alias: {},
                    seasonNumber: parsedData.seasonNumber,
                    episodeNumber: parsedData.episodeNumber,
                    airDate: new Date(parsedData.airDate),
                    overview: parsedData.episodeOverview,
                    animeId: anime.id,
                },
            });

            return { anime, episode };
        });

        console.log(result);
    } catch (e) {
        if (e instanceof ServerValidateError) {
            return e.formState;
        }

        throw e;
    }
}
