import Testing
import day03

@Test
func overlapOfTheSameClaimReturnsNothing() {
    let c1 = Claim(id: 1, x: 1, y: 1, w: 2, h: 2)
    #expect(overlap(c1, c1) == [])
}

@Test
func overlapOfTheSameDifferentClaimsButSameAreaReturnsAllPoints() {
    let c1 = Claim(id: 1, x: 1, y: 1, w: 2, h: 2)
    let c2 = Claim(id: 2, x: 1, y: 1, w: 2, h: 2)

    #expect(
        overlap(c1, c2) == [
            Point(x: 1, y: 1),
            Point(x: 1, y: 2),
            Point(x: 2, y: 1),
            Point(x: 2, y: 2),
        ])
}
