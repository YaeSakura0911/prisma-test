# AGENTS.md

## Stack

- **Next.js 16** (App Router) + **React 19** + **TypeScript 5**
- **Prisma 8** ("Prisma Next", contract-first) with PostgreSQL on Neon: `@prisma/orm-postgres` runtime + `prisma` CLI (devDep) + `@prisma/cli-engine`
- **shadcn/ui** (`"style": "base-nova"`) on **`@base-ui/react`** + **Tailwind CSS v4**
- **TanStack Form v1** (`@tanstack/react-form-nextjs`) + React server actions + **Zod v4**
- **React Compiler** enabled (`next.config.ts`)
- **pnpm** (pinned in `packageManager` field — use pnpm, not npm/yarn)

## Commands

```bash
pnpm dev                 # dev server (localhost:3000)
pnpm build               # production build
npx tsc --noEmit         # typecheck (there is NO typecheck script)
```

- `pnpm lint` is **broken**: crashes with `TypeError: ... 'react/display-name': contextOrFilename.getFilename is not a function` (eslint-plugin-react@7.37.5 incompatible with ESLint 10.9.1). Don't treat lint failures as your fault; use `tsc --noEmit` to verify.
- **No test framework** is configured.

## Prisma

- **Always use the project-local CLI (`pnpm prisma ...`)**. NEVER `pnpm dlx prisma@latest` — dlx pulls the latest dist-tag (8.0.0-rc.12) which is version-mismatched with the project's `prisma.config.ts` (rc.10 era) and falls back to `localhost:5432` instead of reading the Neon URL (`DRIVER.CONNECTION_FAILED` ECONNREFUSED 127.0.0.1:5432).
- **Prisma 8 is contract-first, NOT Prisma 7** (`migrate dev` / `generate` don't exist). Command surface: `contract` (emit/infer), `db` (init/sign/verify/update), `migration` (plan), `orm` (init). Authoritative docs live in `node_modules/@prisma/orm-postgres/skills/prisma-8/` (SKILL.md + references/*.md).
- Single-file contract: `prisma/contract.prisma` (models `Brand`, `Anime`, `Episode`, `Tag`, `EpisodeTag` — PascalCase PSL names, DB tables are lowercased, no `@@map`). `prisma/contract.json` + `prisma/contract.d.ts` are emit outputs, gitignored.
- Runtime client in `prisma/db.ts`: `postgres<Contract>({ contractJson, url: process.env['DATABASE_URL'] })` from `@prisma/orm-postgres/runtime`. Import `db` from `@/prisma/db`; query via `db.orm.public.<Model>` (PascalCase PSL name, NOT storage name) or `db.sql.<table>` (lowercase); transactions via `db.transaction(async (tx) => ...)`.
- `prisma.config.ts` uses `definePrismaConfig` (from `@prisma/cli-engine`) wrapping `defineConfig` from `@prisma/orm-postgres/config`; `db: { connection: process.env['DATABASE_URL'] }`; migrations dir `prisma/migrations/`.
- `DATABASE_URL` in `.env` (gitignored; Neon PostgreSQL). Known benign warnings: pg SSL-mode deprecation notice, "Prisma agent skills are out of date … Run: prisma skills sync".
- Workflow: edit contract → `pnpm prisma contract emit` → `pnpm prisma db update --db "$URL" --no-interactive --confirm neondb` (URL from `.env` via `sed -n 's/^DATABASE_URL=//p' .env`; shell `&` in URL breaks naive `source .env`) → `pnpm prisma db verify --db "$URL"`.
- **Planner bug**: `db update` DROPs old tables in FK-violating order (drops a parent before the dependent junction table). If a drop fails with `cannot drop table ... because other objects depend on it`, manually drop the old tables with CASCADE first (e.g. via a throwaway script using `db.raw.sql\`DROP TABLE IF EXISTS ... CASCADE\`.affectedCount().build()` + `db.runtime().execute(plan)`), then re-run `db update`.
- `previewUrls` on `Episode` is `String[]` NOT NULL with an element-check — must be provided on create (use `[]`).

## UI / shadcn

- Components in `components/ui/` wrap **Base UI** primitives (e.g. `@base-ui/react/input`) — NOT Radix. Don't assume Radix; `.agents/skills/migrate-radix-to-base/` documents the Radix→Base UI mapping, and `.agents/skills/shadcn/` covers CLI usage (installed via `skills-lock.json`).
- Add components with `pnpm dlx shadcn@latest add <component>` (components.json: aliases `@/components`, `@/lib`, `@/hooks`).

## TanStack Form + server actions (the app/anime/new pattern)

- Shared `formOptions` live in `types/` (`types/create-anime-schema.ts`) and are used by both client and server code.
- Client (`app/anime/new/page.tsx`): `useForm({...formOptions, transform: useTransform((base) => mergeForm(base, state ?? {}), [state])})` + `<form ref={formRef} onSubmit={(e) => { e.preventDefault(); void form.handleSubmit(); }}>` (no `action` prop; dispatch via `useActionState` + `startTransition`), wired via `useActionState(action, initialFormState)`.
- Server (`app/anime/new/action.ts`): `createServerValidate({...formOptions, onServerValidate})`; on `ServerValidateError` return `e.formState`, otherwise the action returns `undefined` on success.
- **Trap**: `initialFormState.values` is `undefined` and it's a truthy object — `state ?? {}` does NOT guard against it, and `mergeForm` with `values: undefined` wipes form values (causes controlled→uncontrolled React/Base UI warnings). Only meaningful form state (server errors/values) should be merged.
- Inputs must have `name={field.name}` so FormData serializes for the server action.

## Conventions

- Prettier `tabWidth: 4` (`.prettierrc`); no format script — formatting is manual. shadcn-generated files use 2-space indent; don't reformat them.
- `@/*` path alias → repo root (`tsconfig.json`).
- `app/layout.tsx` is intentionally a client component (`"use client"`, wires TanStack Devtools); server components render inside `{children}`.
- `app/page.tsx` is an empty placeholder; the only real feature is `app/anime/new/`.
