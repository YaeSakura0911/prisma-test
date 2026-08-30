import {
    Pagination,
    PaginationContent,
    PaginationItem,
    PaginationLink,
    PaginationNext,
    PaginationPrevious,
} from "@/components/ui/pagination";
import { Field, FieldLabel } from "@/components/ui/field";
import {
    Select,
    SelectTrigger,
    SelectContent,
    SelectGroup,
    SelectItem,
    SelectValue,
} from "@/components/ui/select";
import { prisma } from "@/lib/prisma";
import {
    AnimeListItemIn,
    AnimeListItemOut,
    AnimeListItemSchema,
} from "@/types/anime-list-item";

export default async function Anime() {
    const size = 10;
    const page = 1;
    const allAnime: AnimeListItemIn[] = await prisma.anime.findMany({
        include: { episodes: true },
    });

    return (
        <div>
            {allAnime.map((anime) => {
                const parse = AnimeListItemSchema.safeParse(episode);

                if (!parse.success) {
                    return null;
                }

                const parsedData: EpisodeListItemOut = parse.data;

                return (
                    <div key={parsedData.id}>
                        <p>{parsedData.name}</p>
                        <p>{parsedData.airDate}</p>
                    </div>
                );
            })}

            <div>
                <Field>
                    <FieldLabel>Rows per page</FieldLabel>
                    <Select>
                        <SelectTrigger>
                            <SelectValue />
                        </SelectTrigger>
                        <SelectContent>
                            <SelectGroup>
                                <SelectItem value="10">10</SelectItem>
                                <SelectItem value="20">20</SelectItem>
                                <SelectItem value="30">30</SelectItem>
                                <SelectItem value="40">40</SelectItem>
                                <SelectItem value="50">50</SelectItem>
                            </SelectGroup>
                        </SelectContent>
                    </Select>
                </Field>
                <Pagination>
                    <PaginationContent>
                        <PaginationItem>
                            <PaginationPrevious href="#" />
                        </PaginationItem>
                        <PaginationItem>
                            <PaginationLink href="#">1</PaginationLink>
                        </PaginationItem>
                        <PaginationItem>
                            <PaginationNext href="#" />
                        </PaginationItem>
                    </PaginationContent>
                </Pagination>
            </div>
        </div>
    );
}
