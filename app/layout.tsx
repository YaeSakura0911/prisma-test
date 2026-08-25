"use client";

import "./globals.css";
import { Geist } from "next/font/google";
import { cn } from "@/lib/utils";
import { TanStackDevtools } from "@tanstack/react-devtools";
import { formDevtoolsPlugin } from "@tanstack/react-form-devtools";

const geist = Geist({ subsets: ["latin"], variable: "--font-sans" });

export default function RootLayout({ children }: LayoutProps<"/">) {
    return (
        <html
            lang="en"
            className={cn("h-full antialiased", "font-sans", geist.variable)}
        >
            <body className="min-h-full flex flex-col">
                {children}
                <TanStackDevtools plugins={[formDevtoolsPlugin()]} />
            </body>
        </html>
    );
}
