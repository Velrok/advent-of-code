import fs from "fs";
import { tryCatch } from "fp-ts/IOEither";

export const readFileSync = (file_path: string) =>
  tryCatch(
    () => fs.readFileSync(file_path, { encoding: "utf8" }),
    (err) => Error(String(err))
  );

export const lines = (s: string): string[] => s.split("\n");

export const batches = (arr: string[]): string[][] => {
  let acc: string[][] = [[]];
  arr.forEach((el) => {
    if (el === "") {
      acc.push([]);
    } else {
      (acc.at(-1) as string[]).push(el);
    }
  });
  return acc;
};
