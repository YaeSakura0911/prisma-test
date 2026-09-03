import "dotenv/config";
import { drizzle } from "drizzle-orm/node-postgres";
import { eq, and, sql } from "drizzle-orm";
import { anime, animeTranslation } from "./db/schema";

const db = drizzle(process.env.DATABASE_URL!);

const newAnime: any = await db
    .insert(anime)
    .values({
        originalName: "",
    })
    .returning({ id: anime.id });

console.log(newAnime);

await db.insert(animeTranslation).values([
    {
        animeId: newAnime.id,
        localeCode: "ja",
        translatedName: "",
        translatedOverview: "",
    },
    {
        animeId: newAnime?.id,
        localeCode: "zh",
        translatedName: "",
        translatedOverview: "",
    },
]);

const results = await db
    .select({
        animeId: anime.id,
        originalName: anime.originalName,
        translatedName: animeTranslation.translatedName,
        translatedOverview: animeTranslation.translatedOverview,
    })
    .from(anime)
    .innerJoin(animeTranslation, eq(anime.id, animeTranslation.animeId))
    .where(and(sql`${animeTranslation.translatedName} &@ ${``}`));
console.log(results);
