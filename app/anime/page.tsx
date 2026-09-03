import {
    Pagination,
    PaginationContent,
    PaginationItem,
    PaginationLink,
    PaginationNext,
    PaginationPrevious,
} from "@/components/ui/pagination";
import {
    Field,
    FieldGroup,
    FieldLabel,
    FieldSet,
    FieldContent,
    FieldTitle,
    FieldDescription,
} from "@/components/ui/field";
import {
    Select,
    SelectTrigger,
    SelectContent,
    SelectGroup,
    SelectItem,
    SelectValue,
} from "@/components/ui/select";
import { Button } from "@/components/ui/button";
import { prisma } from "@/lib/prisma";
import {
    AnimeListItemIn,
    AnimeListItemOut,
    AnimeListItemSchema,
} from "@/types/anime-list-item";
import {
    Dialog,
    DialogTrigger,
    DialogContent,
    DialogHeader,
    DialogFooter,
    DialogClose,
    DialogTitle,
} from "@/components/ui/dialog";
import { Checkbox } from "@/components/ui/checkbox";

export default async function Anime() {
    const size = 12;
    const page = 1;
    const allBrands = await prisma.brand.findMany();
    const allTags = await prisma.tag.findMany();
    const allAnime: AnimeListItemIn[] = await prisma.anime.findMany({
        take: 10,
        skip: 10,
        include: { episodes: true },
    });

    return (
        <div>
            <h1>Brand</h1>
            <Dialog>
                <DialogTrigger
                    render={<Button variant="outline">Brand</Button>}
                />
                <DialogContent>
                    <DialogHeader>
                        <DialogTitle>Brand</DialogTitle>
                    </DialogHeader>

                    <FieldGroup>
                        <FieldLabel>
                            <Field orientation="horizontal">
                                <Checkbox />
                                <FieldContent>
                                    <FieldTitle>PoRO</FieldTitle>
                                    <FieldDescription>123</FieldDescription>
                                </FieldContent>
                            </Field>
                        </FieldLabel>
                    </FieldGroup>

                    <DialogFooter>
                        <Button>Apply</Button>
                    </DialogFooter>
                </DialogContent>
            </Dialog>
            {allBrands.map((brand) => (
                <p>{brand.name}</p>
            ))}
            <h1>Tag</h1>
            <Dialog>
                <DialogTrigger
                    render={<Button variant="outline">Tag</Button>}
                />
                <DialogContent>
                    <DialogHeader>
                        <DialogTitle>Tags</DialogTitle>
                    </DialogHeader>
                    <FieldGroup>
                        {allTags.map((tag) => (
                            <FieldLabel key={tag.id}>
                                <Field orientation="horizontal">
                                    <Checkbox />
                                    <FieldContent>
                                        <FieldTitle>{tag.name}</FieldTitle>
                                        <FieldDescription>123</FieldDescription>
                                    </FieldContent>
                                </Field>
                            </FieldLabel>
                        ))}
                    </FieldGroup>

                    <DialogFooter>
                        <DialogClose
                            render={<Button variant="outline">Cancel</Button>}
                        />
                        <Button type="submit">Apply</Button>
                    </DialogFooter>
                </DialogContent>
            </Dialog>

            {allAnime.map((anime) => {
                const parse = AnimeListItemSchema.safeParse(anime);

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
