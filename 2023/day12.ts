const f = Bun.file("day12.example");

enum SpringCondition {
  Functional = "#",
  Broken = ".",
  Unknown = "?",
}

interface SpringReport {
  conditions: SpringCondition[];
  checksums: number[];
}

const parseCondition = (condition: string): SpringCondition => {
  if (condition === "#") return SpringCondition.Functional;
  if (condition === ".") return SpringCondition.Broken;
  return SpringCondition.Unknown;
};

const report: SpringReport[] = (await f.text())
  .split("\n")
  .filter((line) => line !== "")
  .map((line) => line.split(" "))
  .map(([conditions, checksums]) => {
    return {
      conditions: conditions.split("").map(parseCondition),
      checksums: checksums.split(",").map((x) => parseInt(x)),
    };
  });

const possibleArrangements: (report: SpringReport) => number = (report) => {
  return 0;
};


console.log(report);
