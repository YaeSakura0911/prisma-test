'use client';

import { useEffect, useActionState } from 'react';
import { useForm } from '@tanstack/react-form';
import { formOptions } from '@tanstack/react-form-nextjs';
import { createAnime } from './action';
import { CreateAnimeSchema } from '@/types/create-anime-schema';

const formOpts = formOptions({
    defaultValues: {
        animeName: '',
        episodeName: '',
        seasonNumber: '1',
        episodeNumber: '1',
        airDate: '',
        overview: '',
    },
    validators: {
        onChange: CreateAnimeSchema,
        onBlur: CreateAnimeSchema,
        onSubmit: CreateAnimeSchema,
    },
});

export default function NewAnime() {
    const form = useForm({ ...formOpts });

    const [state, formAction, pending] = useActionState(
        createAnime,
        initialState,
    );

    useEffect(() => {
        // 成功跳转到动画页，失败则弹出 toast 提示框
    }, [state]);

    return (
        <div>
            <form action={formAction} onSubmit={() => form.handleSubmit()}>
                {/* Anime Name */}
                <form.Field name='animeName'>
                    {(field) => {
                        return (
                            <>
                                <label htmlFor={field.name}>Anime Name</label>
                                <input id={field.name} />
                            </>
                        );
                    }}
                </form.Field>
                {/* Episode Name */}
                <form.Field name='episodeName'>
                    {(field) => {
                        return (
                            <>
                                <label htmlFor={field.name}>Episode Name</label>
                                <input id={field.name} />
                            </>
                        );
                    }}
                </form.Field>
                {/* Season Number */}
                <form.Field name='seasonNumber'>
                    {(field) => {
                        return (
                            <>
                                <label htmlFor={field.name}>
                                    Season Number
                                </label>
                                <input id={field.name} type='number' min='1' />
                            </>
                        );
                    }}
                </form.Field>
                {/* Episode Number */}
                <form.Field name='episodeNumber'>
                    {(field) => {
                        return (
                            <>
                                <label htmlFor={field.name}>
                                    Episode Number
                                </label>
                                <input id={field.name} type='number' min='1' />
                            </>
                        );
                    }}
                </form.Field>
                {/* Air Date */}
                <form.Field name='airDate'>
                    {(field) => {
                        return (
                            <>
                                <label htmlFor={field.name}>Air Date</label>
                                <input id={field.name} type='date' />
                            </>
                        );
                    }}
                </form.Field>
                {/* Overview */}
                <form.Field name='overview'>
                    {(field) => {
                        return (
                            <>
                                <label htmlFor={field.name}>Overview</label>
                                <textarea id={field.name} />
                            </>
                        );
                    }}
                </form.Field>

                <button type='submit' disabled={pending}>
                    Create
                </button>
            </form>
        </div>
    );
}
