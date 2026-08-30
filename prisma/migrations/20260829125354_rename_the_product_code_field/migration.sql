/*
  Warnings:

  - You are about to drop the column `createed_at` on the `anime` table. All the data in the column will be lost.
  - You are about to drop the column `productCode` on the `episode` table. All the data in the column will be lost.

*/
-- AlterTable
ALTER TABLE "anime" DROP COLUMN "createed_at",
ADD COLUMN     "created_at" TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP;

-- AlterTable
ALTER TABLE "episode" DROP COLUMN "productCode",
ADD COLUMN     "product_code" TEXT;
