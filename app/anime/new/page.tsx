'use client';

import { useActionState } from 'react';
import {
    useForm,
    initialFormState,
    useTransform,
    mergeForm,
    useSelector,
} from '@tanstack/react-form-nextjs';
import { createAnimeAction } from './action';
import { createAnimeFormOptions } from '@/types/create-anime-schema';

export default function NewAnime() {
    const [state, action, isPending] = useActionState(
        createAnimeAction,
        initialFormState,
    );
    const form = useForm({
        ...createAnimeFormOptions,
        transform: useTransform(
            (baseForm) => mergeForm(baseForm, state!),
            [state],
        ),
    });
    const formErrors = useSelector(form.store, (formState) => formState.errors);

    return (
        <div>
            <form
                action={action as never}
                onSubmit={() => form.handleSubmit()}
                className='flex flex-col'>
                {/* ========== Anime Info ========== */}
                {/* Anime Name */}
                <form.Field name='animeName'>
                    {(field) => {
                        return (
                            <>
                                <label htmlFor={field.name}>Anime Name</label>
                                <input
                                    id={field.name}
                                    name={field.name}
                                    value={field.state.value}
                                    onChange={(e) =>
                                        field.handleChange(e.target.value)
                                    }
                                />
                            </>
                        );
                    }}
                </form.Field>
                {/* Anime Overview */}
                <form.Field name='animeOverview'>
                    {(field) => {
                        return (
                            <>
                                <label htmlFor={field.name}>Overview</label>
                                <textarea
                                    id={field.name}
                                    name={field.name}
                                    value={field.state.value}
                                    onChange={(e) =>
                                        field.handleChange(e.target.value)
                                    }
                                />
                            </>
                        );
                    }}
                </form.Field>

                <hr />

                {/* ========== Episode Info ========== */}
                {/* Episode Name */}
                <form.Field name='episodeName'>
                    {(field) => {
                        return (
                            <>
                                <label htmlFor={field.name}>Episode Name</label>
                                <input
                                    id={field.name}
                                    name={field.name}
                                    value={field.state.value}
                                    onChange={(e) =>
                                        field.handleChange(e.target.value)
                                    }
                                />
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
                                <input
                                    id={field.name}
                                    type='number'
                                    name={field.name}
                                    value={field.state.value}
                                    min='1'
                                    onChange={(e) =>
                                        field.handleChange(e.target.value)
                                    }
                                />
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
                                <input
                                    id={field.name}
                                    type='number'
                                    name={field.name}
                                    value={field.state.value}
                                    min='1'
                                    onChange={(e) =>
                                        field.handleChange(e.target.value)
                                    }
                                />
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
                                <input
                                    id={field.name}
                                    type='date'
                                    name={field.name}
                                    value={field.state.value}
                                    onChange={(e) =>
                                        field.handleChange(e.target.value)
                                    }
                                />
                            </>
                        );
                    }}
                </form.Field>
                {/* Episode Overview */}
                <form.Field name='episodeOverview'>
                    {(field) => {
                        return (
                            <>
                                <label htmlFor={field.name}>Overview</label>
                                <textarea
                                    id={field.name}
                                    name={field.name}
                                    value={field.state.value}
                                    onChange={(e) =>
                                        field.handleChange(e.target.value)
                                    }
                                />
                            </>
                        );
                    }}
                </form.Field>

                <form.Subscribe
                    selector={(formState) => [
                        formState.canSubmit,
                        formState.isSubmitting,
                    ]}>
                    {([canSubmit, isSubmitting]) => (
                        <button type='submit' disabled={isPending}>
                            {isPending ? 'loading...' : 'Create'}
                        </button>
                    )}
                </form.Subscribe>
            </form>
        </div>
    );
}
