"use server";

import {
    createAnimeFormOptions,
    CreateAnimeSchema,
} from "@/types/create-anime-schema";
import {
  ServerValidateError,
  createServerValidate,
} from '@tanstack/react-form-nextjs'

const serverValidate = createServerValidate({
    ...createAnimeFormOptions,
    onServerValidate: CreateAnimeSchema,
});

export default async function createAnimeAction(
    prev: unknown,
    formData: FormData,
) {
    console.log(formData)
    try {
        const validateData = await serverValidate(formData);
        console.log(validateData);

        // SQL
    } catch (e) {
        if (e instanceof ServerValidateError) {
            return e.formState;
        }

        throw e;
    }
}
