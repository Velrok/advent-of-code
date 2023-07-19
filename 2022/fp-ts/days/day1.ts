import { pipe } from "fp-ts/lib/function";
import { batches, lines, readFileSync } from "../utils";
import { match } from "fp-ts/lib/IOEither";
import { log } from "fp-ts/lib/Console";
import { fromArray, map } from "fp-ts/lib/ReadonlyNonEmptyArray";

const callories = (arr: string[][]) =>
  pipe(
    map(
      (arr: string[]) =>
        map((e: string) => parseInt(e))(fromArray(arr))
    )
  );

const program = (fileName: string) =>
  pipe(
    readFileSync(fileName),
    match(
      (err) => log("Err: " + err),
      (data) => log("Data: " + pipe(data, lines, batches, callories))
    )
  )()();

console.log("day1.ts");
program("days/day1.test.input");
