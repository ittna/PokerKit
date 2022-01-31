import XCTest
@testable import PokerKit

final class HandEvaluatorTests: XCTestCase {

    private let evaluator = PokerKit.lookupTableHandEvaluator()

    func testLookupTablePerformance() throws {
        let hands = (1...10000).map { _ in Array(Card.deck.shuffled().prefix(7)) }
        measure(metrics: [XCTClockMetric()]) {
            for hand in hands {
                var handle: HandHandle = .empty
                for c in hand {
                    handle = evaluator.evaluate(card: c, handle: handle)
                }
            }
        }
    }

    func testHighCardHands() {
        let h = [Card(rank: Rank.two, suit: Suit.club),
                 Card(rank: Rank.four, suit: Suit.club),
                 Card(rank: Rank.six, suit: Suit.diamond),
                 Card(rank: Rank.eight, suit: Suit.diamond),
                 Card(rank: Rank.ten, suit: Suit.heart),
                 Card(rank: Rank.queen, suit: Suit.heart),
                 Card(rank: Rank.ace, suit: Suit.spade)]
        var handle = HandHandle.empty
        handle = evaluator.evaluate(card: h[0], handle: handle)
        handle = evaluator.evaluate(card: h[1], handle: handle)
        handle = evaluator.evaluate(card: h[2], handle: handle)
        handle = evaluator.evaluate(card: h[3], handle: handle)
        handle = evaluator.evaluate(card: h[4], handle: handle)
        guard let rank5 = evaluator.evaluate(handle: handle) else {
            XCTFail("5 card hand should have rank")
            return
        }
        XCTAssertEqual(rank5.category, HandCategory.highCard)
        handle = evaluator.evaluate(card: h[5], handle: handle)
        guard let rank6 = evaluator.evaluate(handle: handle) else {
            XCTFail("6 card hand should have rank")
            return
        }
        XCTAssertEqual(rank6.category, HandCategory.highCard)
        XCTAssertGreaterThan(rank6, rank5)
        handle = evaluator.evaluate(card: h[6], handle: handle)
        guard let rank7 = evaluator.evaluate(handle: handle) else {
            XCTFail("7 card hand should have rank")
            return
        }
        XCTAssertEqual(rank7.category, HandCategory.highCard)
        XCTAssertGreaterThan(rank7, rank6)
    }

    func testOnePairHands() {
        let h = [Card(rank: Rank.two, suit: Suit.club),
                 Card(rank: Rank.four, suit: Suit.club),
                 Card(rank: Rank.six, suit: Suit.diamond),
                 Card(rank: Rank.ten, suit: Suit.diamond),
                 Card(rank: Rank.ten, suit: Suit.heart),
                 Card(rank: Rank.queen, suit: Suit.heart),
                 Card(rank: Rank.ace, suit: Suit.spade)]
        var handle = HandHandle.empty
        handle = evaluator.evaluate(card: h[0], handle: handle)
        handle = evaluator.evaluate(card: h[1], handle: handle)
        handle = evaluator.evaluate(card: h[2], handle: handle)
        handle = evaluator.evaluate(card: h[3], handle: handle)
        handle = evaluator.evaluate(card: h[4], handle: handle)
        guard let rank5 = evaluator.evaluate(handle: handle) else {
            XCTFail("5 card hand should have rank")
            return
        }
        XCTAssertEqual(rank5.category, HandCategory.onePair)
        handle = evaluator.evaluate(card: h[5], handle: handle)
        guard let rank6 = evaluator.evaluate(handle: handle) else {
            XCTFail("6 card hand should have rank")
            return
        }
        XCTAssertEqual(rank6.category, HandCategory.onePair)
        XCTAssertGreaterThan(rank6, rank5)
        handle = evaluator.evaluate(card: h[6], handle: handle)
        guard let rank7 = evaluator.evaluate(handle: handle) else {
            XCTFail("7 card hand should have rank")
            return
        }
        XCTAssertEqual(rank7.category, HandCategory.onePair)
        XCTAssertGreaterThan(rank7, rank6)
    }

    func testTwoPairHands() {
        let h = [Card(rank: Rank.two, suit: Suit.club),
                 Card(rank: Rank.two, suit: Suit.diamond),
                 Card(rank: Rank.queen, suit: Suit.diamond),
                 Card(rank: Rank.ten, suit: Suit.diamond),
                 Card(rank: Rank.ten, suit: Suit.heart),
                 Card(rank: Rank.queen, suit: Suit.heart),
                 Card(rank: Rank.ace, suit: Suit.spade)]
        var handle = HandHandle.empty
        handle = evaluator.evaluate(card: h[0], handle: handle)
        handle = evaluator.evaluate(card: h[1], handle: handle)
        handle = evaluator.evaluate(card: h[2], handle: handle)
        handle = evaluator.evaluate(card: h[3], handle: handle)
        handle = evaluator.evaluate(card: h[4], handle: handle)
        guard let rank5 = evaluator.evaluate(handle: handle) else {
            XCTFail("5 card hand should have rank")
            return
        }
        XCTAssertEqual(rank5.category, HandCategory.twoPair)
        handle = evaluator.evaluate(card: h[5], handle: handle)
        guard let rank6 = evaluator.evaluate(handle: handle) else {
            XCTFail("6 card hand should have rank")
            return
        }
        XCTAssertEqual(rank6.category, HandCategory.twoPair)
        XCTAssertGreaterThan(rank6, rank5)
        handle = evaluator.evaluate(card: h[6], handle: handle)
        guard let rank7 = evaluator.evaluate(handle: handle) else {
            XCTFail("7 card hand should have rank")
            return
        }
        XCTAssertEqual(rank7.category, HandCategory.twoPair)
        XCTAssertGreaterThan(rank7, rank6)
    }

    func testThreeOfAKindHands() {
        let h = [Card(rank: Rank.two, suit: Suit.club),
                 Card(rank: Rank.two, suit: Suit.diamond),
                 Card(rank: Rank.two, suit: Suit.heart),
                 Card(rank: Rank.eight, suit: Suit.diamond),
                 Card(rank: Rank.ten, suit: Suit.heart),
                 Card(rank: Rank.queen, suit: Suit.heart),
                 Card(rank: Rank.ace, suit: Suit.spade)]
        var handle = HandHandle.empty
        handle = evaluator.evaluate(card: h[0], handle: handle)
        handle = evaluator.evaluate(card: h[1], handle: handle)
        handle = evaluator.evaluate(card: h[2], handle: handle)
        handle = evaluator.evaluate(card: h[3], handle: handle)
        handle = evaluator.evaluate(card: h[4], handle: handle)
        guard let rank5 = evaluator.evaluate(handle: handle) else {
            XCTFail("5 card hand should have rank")
            return
        }
        XCTAssertEqual(rank5.category, HandCategory.threeOfAKind)
        handle = evaluator.evaluate(card: h[5], handle: handle)
        guard let rank6 = evaluator.evaluate(handle: handle) else {
            XCTFail("6 card hand should have rank")
            return
        }
        XCTAssertEqual(rank6.category, HandCategory.threeOfAKind)
        XCTAssertGreaterThan(rank6, rank5)
        handle = evaluator.evaluate(card: h[6], handle: handle)
        guard let rank7 = evaluator.evaluate(handle: handle) else {
            XCTFail("7 card hand should have rank")
            return
        }
        XCTAssertEqual(rank7.category, HandCategory.threeOfAKind)
        XCTAssertGreaterThan(rank7, rank6)
    }

    func testStraightHands() {
        let h = [Card(rank: Rank.ace, suit: Suit.club),
                 Card(rank: Rank.two, suit: Suit.club),
                 Card(rank: Rank.three, suit: Suit.diamond),
                 Card(rank: Rank.four, suit: Suit.diamond),
                 Card(rank: Rank.five, suit: Suit.heart),
                 Card(rank: Rank.six, suit: Suit.heart),
                 Card(rank: Rank.seven, suit: Suit.spade)]
        var handle = HandHandle.empty
        handle = evaluator.evaluate(card: h[0], handle: handle)
        handle = evaluator.evaluate(card: h[1], handle: handle)
        handle = evaluator.evaluate(card: h[2], handle: handle)
        handle = evaluator.evaluate(card: h[3], handle: handle)
        handle = evaluator.evaluate(card: h[4], handle: handle)
        guard let rank5 = evaluator.evaluate(handle: handle) else {
            XCTFail("5 card hand should have rank")
            return
        }
        XCTAssertEqual(rank5.category, HandCategory.straight)
        handle = evaluator.evaluate(card: h[5], handle: handle)
        guard let rank6 = evaluator.evaluate(handle: handle) else {
            XCTFail("6 card hand should have rank")
            return
        }
        XCTAssertEqual(rank6.category, HandCategory.straight)
        XCTAssertGreaterThan(rank6, rank5)
        handle = evaluator.evaluate(card: h[6], handle: handle)
        guard let rank7 = evaluator.evaluate(handle: handle) else {
            XCTFail("7 card hand should have rank")
            return
        }
        XCTAssertEqual(rank7.category, HandCategory.straight)
        XCTAssertGreaterThan(rank7, rank6)
    }

    func testFlushHands() {
        let h = [Card(rank: Rank.two, suit: Suit.spade),
                 Card(rank: Rank.four, suit: Suit.spade),
                 Card(rank: Rank.six, suit: Suit.spade),
                 Card(rank: Rank.eight, suit: Suit.spade),
                 Card(rank: Rank.ten, suit: Suit.spade),
                 Card(rank: Rank.queen, suit: Suit.spade),
                 Card(rank: Rank.ace, suit: Suit.spade)]
        var handle = HandHandle.empty
        handle = evaluator.evaluate(card: h[0], handle: handle)
        handle = evaluator.evaluate(card: h[1], handle: handle)
        handle = evaluator.evaluate(card: h[2], handle: handle)
        handle = evaluator.evaluate(card: h[3], handle: handle)
        handle = evaluator.evaluate(card: h[4], handle: handle)
        guard let rank5 = evaluator.evaluate(handle: handle) else {
            XCTFail("5 card hand should have rank")
            return
        }
        XCTAssertEqual(rank5.category, HandCategory.flush)
        handle = evaluator.evaluate(card: h[5], handle: handle)
        guard let rank6 = evaluator.evaluate(handle: handle) else {
            XCTFail("6 card hand should have rank")
            return
        }
        XCTAssertEqual(rank6.category, HandCategory.flush)
        XCTAssertGreaterThan(rank6, rank5)
        handle = evaluator.evaluate(card: h[6], handle: handle)
        guard let rank7 = evaluator.evaluate(handle: handle) else {
            XCTFail("7 card hand should have rank")
            return
        }
        XCTAssertEqual(rank7.category, HandCategory.flush)
        XCTAssertGreaterThan(rank7, rank6)
    }

    func testFullHouseHands() {
        let h = [Card(rank: Rank.two, suit: Suit.club),
                 Card(rank: Rank.two, suit: Suit.diamond),
                 Card(rank: Rank.eight, suit: Suit.heart),
                 Card(rank: Rank.eight, suit: Suit.diamond),
                 Card(rank: Rank.ten, suit: Suit.heart),
                 Card(rank: Rank.two, suit: Suit.heart),
                 Card(rank: Rank.eight, suit: Suit.spade)]
        var handle = HandHandle.empty
        handle = evaluator.evaluate(card: h[0], handle: handle)
        handle = evaluator.evaluate(card: h[1], handle: handle)
        handle = evaluator.evaluate(card: h[2], handle: handle)
        handle = evaluator.evaluate(card: h[3], handle: handle)
        handle = evaluator.evaluate(card: h[4], handle: handle)
        guard let rank5 = evaluator.evaluate(handle: handle) else {
            XCTFail("5 card hand should have rank")
            return
        }
        XCTAssertEqual(rank5.category, HandCategory.twoPair)
        handle = evaluator.evaluate(card: h[5], handle: handle)
        guard let rank6 = evaluator.evaluate(handle: handle) else {
            XCTFail("6 card hand should have rank")
            return
        }
        XCTAssertEqual(rank6.category, HandCategory.fullHouse)
        XCTAssertGreaterThan(rank6, rank5)
        handle = evaluator.evaluate(card: h[6], handle: handle)
        guard let rank7 = evaluator.evaluate(handle: handle) else {
            XCTFail("7 card hand should have rank")
            return
        }
        XCTAssertEqual(rank7.category, HandCategory.fullHouse)
        XCTAssertGreaterThan(rank7, rank6)
    }

    func testFourOfAKindHands() {
        let h = [Card(rank: Rank.two, suit: Suit.club),
                 Card(rank: Rank.two, suit: Suit.diamond),
                 Card(rank: Rank.two, suit: Suit.heart),
                 Card(rank: Rank.two, suit: Suit.spade),
                 Card(rank: Rank.ten, suit: Suit.heart),
                 Card(rank: Rank.queen, suit: Suit.heart),
                 Card(rank: Rank.ace, suit: Suit.spade)]
        var handle = HandHandle.empty
        handle = evaluator.evaluate(card: h[0], handle: handle)
        handle = evaluator.evaluate(card: h[1], handle: handle)
        handle = evaluator.evaluate(card: h[2], handle: handle)
        handle = evaluator.evaluate(card: h[3], handle: handle)
        handle = evaluator.evaluate(card: h[4], handle: handle)
        guard let rank5 = evaluator.evaluate(handle: handle) else {
            XCTFail("5 card hand should have rank")
            return
        }
        XCTAssertEqual(rank5.category, HandCategory.fourOfAKind)
        handle = evaluator.evaluate(card: h[5], handle: handle)
        guard let rank6 = evaluator.evaluate(handle: handle) else {
            XCTFail("6 card hand should have rank")
            return
        }
        XCTAssertEqual(rank6.category, HandCategory.fourOfAKind)
        XCTAssertGreaterThan(rank6, rank5)
        handle = evaluator.evaluate(card: h[6], handle: handle)
        guard let rank7 = evaluator.evaluate(handle: handle) else {
            XCTFail("7 card hand should have rank")
            return
        }
        XCTAssertEqual(rank7.category, HandCategory.fourOfAKind)
        XCTAssertGreaterThan(rank7, rank6)
    }

    func testStraightFlushHands() {
        let h = [Card(rank: Rank.eight, suit: Suit.club),
                 Card(rank: Rank.nine, suit: Suit.club),
                 Card(rank: Rank.ten, suit: Suit.club),
                 Card(rank: Rank.jack, suit: Suit.club),
                 Card(rank: Rank.queen, suit: Suit.club),
                 Card(rank: Rank.king, suit: Suit.club),
                 Card(rank: Rank.ace, suit: Suit.club)]
        var handle = HandHandle.empty
        handle = evaluator.evaluate(card: h[0], handle: handle)
        handle = evaluator.evaluate(card: h[1], handle: handle)
        handle = evaluator.evaluate(card: h[2], handle: handle)
        handle = evaluator.evaluate(card: h[3], handle: handle)
        handle = evaluator.evaluate(card: h[4], handle: handle)
        guard let rank5 = evaluator.evaluate(handle: handle) else {
            XCTFail("5 card hand should have rank")
            return
        }
        XCTAssertEqual(rank5.category, HandCategory.straightFlush)
        handle = evaluator.evaluate(card: h[5], handle: handle)
        guard let rank6 = evaluator.evaluate(handle: handle) else {
            XCTFail("6 card hand should have rank")
            return
        }
        XCTAssertEqual(rank6.category, HandCategory.straightFlush)
        XCTAssertGreaterThan(rank6, rank5)
        handle = evaluator.evaluate(card: h[6], handle: handle)
        guard let rank7 = evaluator.evaluate(handle: handle) else {
            XCTFail("7 card hand should have rank")
            return
        }
        XCTAssertEqual(rank7.category, HandCategory.straightFlush)
        XCTAssertGreaterThan(rank7, rank6)
    }
}
