import Foundation

public struct Point: Hashable, Equatable {
    public let x: Int
    public let y: Int

    public init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }
}

public struct Claim {
    public let id: Int
    public let x: Int
    public let y: Int
    public let w: Int
    public let h: Int

    public init(id: Int, x: Int, y: Int, w: Int, h: Int) {
        self.id = id
        self.x = x
        self.y = y
        self.w = w
        self.h = h
    }

    public func contains(p: Point) -> Bool {
        return (x..<x + w).contains(p.x) && (y..<y + h).contains(p.y)
    }

    public func x2() -> Int { return (x + w) - 1 }
    public func y2() -> Int { return (y + h) - 1 }
}

public func overlap(_ claim1: Claim, _ claim2: Claim) -> [Point] {
    #if DEBUG
        print("claims:")
        dump(claim1)
        dump(claim2)
    #endif

    let leftEdge = max(claim1.x, claim2.x)
    let rightEdge = min(claim1.x2(), claim2.x2())

    let topEdge = max(claim1.y, claim2.y)
    let bottomEdge = min(claim1.y2(), claim2.y2())

    #if DEBUG
        print("Checking overlap:")
        print("  Edges: left=\(leftEdge), right=\(rightEdge), top=\(topEdge), bottom=\(bottomEdge)")
    #endif

    guard claim1.id != claim2.id else {
        #if DEBUG
            print("Same claim \(claim1.id)")
        #endif
        return []
    }

    guard leftEdge <= rightEdge, topEdge <= bottomEdge else {
        #if DEBUG
            print("Same claim \(claim1.id)")
        #endif
        return []
    }

    return (leftEdge...rightEdge).flatMap({ x in
        (topEdge...bottomEdge).map({ y in
            Point(x: x, y: y)
        })
    })
}

public func parseClaim(line: String.SubSequence) -> Claim {
    let match = line.firstMatch(of: /#(\d+) @ (\d+),(\d+): (\d+)x(\d+)/)!
    let (_, id, x, y, w, h) = match.output

    return Claim(
        id: Int(id)!,
        x: Int(x)!,
        y: Int(y)!,
        w: Int(w)!,
        h: Int(h)!,
    )
}

func part01() {
    print("part01")

    let content = try! String(contentsOfFile: "input/day03")
    let lines = content.split(separator: "\n")

    let claims = lines.map { parseClaim(line: $0) }

    var overlapingPoints: Set<Point> = []

    for c1 in claims {
        for c2 in claims {
            overlapingPoints.formUnion(overlap(c1, c2))
        }
    }
    dump(overlapingPoints)
}

print("Start")
part01()
print("Done")
