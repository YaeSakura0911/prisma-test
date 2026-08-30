/*
  Warnings:

  - You are about to drop the column `brandId` on the `anime` table. All the data in the column will be lost.
  - You are about to drop the column `createdAt` on the `anime` table. All the data in the column will be lost.
  - You are about to drop the column `createdAt` on the `brand` table. All the data in the column will be lost.
  - You are about to drop the column `logoUrl` on the `brand` table. All the data in the column will be lost.
  - You are about to drop the column `officialUrl` on the `brand` table. All the data in the column will be lost.
  - You are about to drop the column `airDate` on the `episode` table. All the data in the column will be lost.
  - You are about to drop the column `animeId` on the `episode` table. All the data in the column will be lost.
  - You are about to drop the column `coverUrl` on the `episode` table. All the data in the column will be lost.
  - You are about to drop the column `createdAt` on the `episode` table. All the data in the column will be lost.
  - You are about to drop the column `episodeNumber` on the `episode` table. All the data in the column will be lost.
  - You are about to drop the column `officialUrl` on the `episode` table. All the data in the column will be lost.
  - You are about to drop the column `posterUrl` on the `episode` table. All the data in the column will be lost.
  - You are about to drop the column `previewUrls` on the `episode` table. All the data in the column will be lost.
  - You are about to drop the column `seasonNumber` on the `episode` table. All the data in the column will be lost.
  - You are about to drop the column `episodeId` on the `episodeTag` table. All the data in the column will be lost.
  - You are about to drop the column `tagId` on the `episodeTag` table. All the data in the column will be lost.
  - A unique constraint covering the columns `[name]` on the table `episode` will be added. If there are existing duplicate values, this will fail.
  - Added the required column `air_date` to the `episode` table without a default value. This is not possible if the table is not empty.
  - Added the required column `anime_id` to the `episode` table without a default value. This is not possible if the table is not empty.
  - Added the required column `episode_number` to the `episode` table without a default value. This is not possible if the table is not empty.
  - Added the required column `season_number` to the `episode` table without a default value. This is not possible if the table is not empty.
  - Added the required column `episode_id` to the `episodeTag` table without a default value. This is not possible if the table is not empty.
  - Added the required column `tag_id` to the `episodeTag` table without a default value. This is not possible if the table is not empty.

*/
-- DropForeignKey
ALTER TABLE "anime" DROP CONSTRAINT "anime_brandId_fkey";

-- DropForeignKey
ALTER TABLE "episodeTag" DROP CONSTRAINT "episodeTag_episodeId_fkey";

-- DropForeignKey
ALTER TABLE "episodeTag" DROP CONSTRAINT "episodeTag_tagId_fkey";

-- DropIndex
DROP INDEX "anime_brandId_idx_02e95397";

-- DropIndex
DROP INDEX "episodeTag_episodeId_idx_c75534a6";

-- DropIndex
DROP INDEX "episodeTag_tagId_idx_86854244";

-- AlterTable
ALTER TABLE "anime" DROP COLUMN "brandId",
DROP COLUMN "createdAt",
ADD COLUMN     "brand_id" INTEGER,
ADD COLUMN     "createed_at" TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP;

-- AlterTable
ALTER TABLE "brand" DROP COLUMN "createdAt",
DROP COLUMN "logoUrl",
DROP COLUMN "officialUrl",
ADD COLUMN     "created_at" TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
ADD COLUMN     "logo_url" TEXT,
ADD COLUMN     "official_url" TEXT;

-- AlterTable
ALTER TABLE "episode" DROP COLUMN "airDate",
DROP COLUMN "animeId",
DROP COLUMN "coverUrl",
DROP COLUMN "createdAt",
DROP COLUMN "episodeNumber",
DROP COLUMN "officialUrl",
DROP COLUMN "posterUrl",
DROP COLUMN "previewUrls",
DROP COLUMN "seasonNumber",
ADD COLUMN     "air_date" DATE NOT NULL,
ADD COLUMN     "anime_id" INTEGER NOT NULL,
ADD COLUMN     "cover_url" TEXT,
ADD COLUMN     "created_at" TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
ADD COLUMN     "episode_number" SMALLINT NOT NULL,
ADD COLUMN     "official_url" TEXT,
ADD COLUMN     "poster_url" TEXT,
ADD COLUMN     "preview_urls" TEXT[],
ADD COLUMN     "season_number" SMALLINT NOT NULL;

-- AlterTable
ALTER TABLE "episodeTag" DROP COLUMN "episodeId",
DROP COLUMN "tagId",
ADD COLUMN     "episode_id" INTEGER NOT NULL,
ADD COLUMN     "tag_id" INTEGER NOT NULL,
ADD CONSTRAINT "episodeTag_pkey" PRIMARY KEY ("episode_id", "tag_id");

-- CreateIndex
CREATE UNIQUE INDEX "episode_name_key" ON "episode"("name");

-- AddForeignKey
ALTER TABLE "anime" ADD CONSTRAINT "anime_brand_id_fkey" FOREIGN KEY ("brand_id") REFERENCES "brand"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "episodeTag" ADD CONSTRAINT "episodeTag_episode_id_fkey" FOREIGN KEY ("episode_id") REFERENCES "episode"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "episodeTag" ADD CONSTRAINT "episodeTag_tag_id_fkey" FOREIGN KEY ("tag_id") REFERENCES "tag"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
