-- CreateSchema
CREATE SCHEMA IF NOT EXISTS "public";

-- CreateTable
CREATE TABLE "anime" (
    "alias" JSONB NOT NULL,
    "brandId" INTEGER,
    "createdAt" TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "id" SERIAL NOT NULL,
    "name" TEXT NOT NULL,
    "overview" JSONB NOT NULL,

    CONSTRAINT "anime_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "brand" (
    "alias" JSONB NOT NULL,
    "createdAt" TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "id" SERIAL NOT NULL,
    "logoUrl" TEXT,
    "name" TEXT NOT NULL,
    "officialUrl" TEXT,

    CONSTRAINT "brand_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "episode" (
    "airDate" DATE NOT NULL,
    "alias" JSONB NOT NULL,
    "animeId" INTEGER NOT NULL,
    "coverUrl" TEXT,
    "createdAt" TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "duration" SMALLINT,
    "episodeNumber" SMALLINT NOT NULL,
    "id" SERIAL NOT NULL,
    "name" TEXT NOT NULL,
    "officialUrl" TEXT,
    "overview" JSONB NOT NULL,
    "posterUrl" TEXT,
    "previewUrls" TEXT[],
    "productCode" TEXT,
    "seasonNumber" SMALLINT NOT NULL,

    CONSTRAINT "episode_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "episodeTag" (
    "episodeId" INTEGER NOT NULL,
    "tagId" INTEGER NOT NULL
);

-- CreateTable
CREATE TABLE "tag" (
    "alias" JSONB NOT NULL,
    "createdAt" TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "id" SERIAL NOT NULL,
    "name" TEXT NOT NULL,

    CONSTRAINT "tag_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "anime_name_key" ON "anime"("name");

-- CreateIndex
CREATE INDEX "anime_brandId_idx_02e95397" ON "anime"("brandId");

-- CreateIndex
CREATE UNIQUE INDEX "brand_name_key" ON "brand"("name");

-- CreateIndex
CREATE INDEX "episodeTag_episodeId_idx_c75534a6" ON "episodeTag"("episodeId");

-- CreateIndex
CREATE INDEX "episodeTag_tagId_idx_86854244" ON "episodeTag"("tagId");

-- AddForeignKey
ALTER TABLE "anime" ADD CONSTRAINT "anime_brandId_fkey" FOREIGN KEY ("brandId") REFERENCES "brand"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "episodeTag" ADD CONSTRAINT "episodeTag_episodeId_fkey" FOREIGN KEY ("episodeId") REFERENCES "episode"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "episodeTag" ADD CONSTRAINT "episodeTag_tagId_fkey" FOREIGN KEY ("tagId") REFERENCES "tag"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

