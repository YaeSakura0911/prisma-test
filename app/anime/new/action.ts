'use server';

import prisma from '@/lib/prisma';
import { CreateAnimeSchema } from '@/types/create-anime-schema';

import {
    ServerValidateError,
    createServerValidate,
} from '@tanstack/react-form-nextjs';

const serverValidate = createServerValidate({
    onServerValidate: () => {},
});

export async function createAnime(prev: unknown, formData: FormData) {
    try {
        const validateData = await serverValidate(formData);
        const parsed = CreateAnimeSchema.safeParse(validateData);

        // 先判断动画是否存在

        // 如果动画存在则跳转到动画页

        // 如果动画不存在则启用事务，先创建动画，再创建剧集
        await prisma.$transaction(async (tx) => {
            await tx.anime.create();

            await tx.episode.create();
        });
    } catch (error) {
        if (error instanceof ServerValidateError) {
            return error.formState;
        }
    }
}
