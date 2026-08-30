-- AddForeignKey
ALTER TABLE "episode" ADD CONSTRAINT "episode_anime_id_fkey" FOREIGN KEY ("anime_id") REFERENCES "anime"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
