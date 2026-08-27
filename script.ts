import "dotenv/config";
import { db } from "./prisma/db";

async function main() {
    const runtime = await db.connect({url:process.env.DATABASE_URL!})

    const anime = await db.orm.Anime.select("id")
}