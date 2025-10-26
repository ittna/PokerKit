import Testing
@testable import PokerKit

@Suite("Hand Evaluator Tests")
struct HandEvaluatorTests {

    private let evaluator = PokerKit.lookupTableHandEvaluator()

    @Test("High Card Hands")
    func highCardHands() throws {
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
        let rank5 = try #require(evaluator.evaluate(handle: handle), "5 card hand should have rank")
        #expect(rank5.category == HandCategory.highCard)
        
        handle = evaluator.evaluate(card: h[5], handle: handle)
        let rank6 = try #require(evaluator.evaluate(handle: handle), "6 card hand should have rank")
        #expect(rank6.category == HandCategory.highCard)
        #expect(rank6 > rank5)
        
        handle = evaluator.evaluate(card: h[6], handle: handle)
        let rank7 = try #require(evaluator.evaluate(handle: handle), "7 card hand should have rank")
        #expect(rank7.category == HandCategory.highCard)
        #expect(rank7 > rank6)
    }

    @Test("One Pair Hands")
    func onePairHands() throws {
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
        let rank5 = try #require(evaluator.evaluate(handle: handle), "5 card hand should have rank")
        #expect(rank5.category == HandCategory.onePair)
        
        handle = evaluator.evaluate(card: h[5], handle: handle)
        let rank6 = try #require(evaluator.evaluate(handle: handle), "6 card hand should have rank")
        #expect(rank6.category == HandCategory.onePair)
        #expect(rank6 > rank5)
        
        handle = evaluator.evaluate(card: h[6], handle: handle)
        let rank7 = try #require(evaluator.evaluate(handle: handle), "7 card hand should have rank")
        #expect(rank7.category == HandCategory.onePair)
        #expect(rank7 > rank6)
    }

    @Test("Two Pair Hands")
    func twoPairHands() throws {
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
        let rank5 = try #require(evaluator.evaluate(handle: handle), "5 card hand should have rank")
        #expect(rank5.category == HandCategory.twoPair)
        
        handle = evaluator.evaluate(card: h[5], handle: handle)
        let rank6 = try #require(evaluator.evaluate(handle: handle), "6 card hand should have rank")
        #expect(rank6.category == HandCategory.twoPair)
        #expect(rank6 > rank5)
        
        handle = evaluator.evaluate(card: h[6], handle: handle)
        let rank7 = try #require(evaluator.evaluate(handle: handle), "7 card hand should have rank")
        #expect(rank7.category == HandCategory.twoPair)
        #expect(rank7 > rank6)
    }

    @Test("Three of a Kind Hands")
    func threeOfAKindHands() throws {
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
        let rank5 = try #require(evaluator.evaluate(handle: handle), "5 card hand should have rank")
        #expect(rank5.category == HandCategory.threeOfAKind)
        
        handle = evaluator.evaluate(card: h[5], handle: handle)
        let rank6 = try #require(evaluator.evaluate(handle: handle), "6 card hand should have rank")
        #expect(rank6.category == HandCategory.threeOfAKind)
        #expect(rank6 > rank5)
        
        handle = evaluator.evaluate(card: h[6], handle: handle)
        let rank7 = try #require(evaluator.evaluate(handle: handle), "7 card hand should have rank")
        #expect(rank7.category == HandCategory.threeOfAKind)
        #expect(rank7 > rank6)
    }

    @Test("Straight Hands")
    func straightHands() throws {
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
        let rank5 = try #require(evaluator.evaluate(handle: handle), "5 card hand should have rank")
        #expect(rank5.category == HandCategory.straight)
        
        handle = evaluator.evaluate(card: h[5], handle: handle)
        let rank6 = try #require(evaluator.evaluate(handle: handle), "6 card hand should have rank")
        #expect(rank6.category == HandCategory.straight)
        #expect(rank6 > rank5)
        
        handle = evaluator.evaluate(card: h[6], handle: handle)
        let rank7 = try #require(evaluator.evaluate(handle: handle), "7 card hand should have rank")
        #expect(rank7.category == HandCategory.straight)
        #expect(rank7 > rank6)
    }

    @Test("Flush Hands")
    func flushHands() throws {
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
        let rank5 = try #require(evaluator.evaluate(handle: handle), "5 card hand should have rank")
        #expect(rank5.category == HandCategory.flush)
        
        handle = evaluator.evaluate(card: h[5], handle: handle)
        let rank6 = try #require(evaluator.evaluate(handle: handle), "6 card hand should have rank")
        #expect(rank6.category == HandCategory.flush)
        #expect(rank6 > rank5)
        
        handle = evaluator.evaluate(card: h[6], handle: handle)
        let rank7 = try #require(evaluator.evaluate(handle: handle), "7 card hand should have rank")
        #expect(rank7.category == HandCategory.flush)
        #expect(rank7 > rank6)
    }

    @Test("Full House Hands")
    func fullHouseHands() throws {
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
        let rank5 = try #require(evaluator.evaluate(handle: handle), "5 card hand should have rank")
        #expect(rank5.category == HandCategory.twoPair)
        
        handle = evaluator.evaluate(card: h[5], handle: handle)
        let rank6 = try #require(evaluator.evaluate(handle: handle), "6 card hand should have rank")
        #expect(rank6.category == HandCategory.fullHouse)
        #expect(rank6 > rank5)
        
        handle = evaluator.evaluate(card: h[6], handle: handle)
        let rank7 = try #require(evaluator.evaluate(handle: handle), "7 card hand should have rank")
        #expect(rank7.category == HandCategory.fullHouse)
        #expect(rank7 > rank6)
    }

    @Test("Four of a Kind Hands")
    func fourOfAKindHands() throws {
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
        let rank5 = try #require(evaluator.evaluate(handle: handle), "5 card hand should have rank")
        #expect(rank5.category == HandCategory.fourOfAKind)
        
        handle = evaluator.evaluate(card: h[5], handle: handle)
        let rank6 = try #require(evaluator.evaluate(handle: handle), "6 card hand should have rank")
        #expect(rank6.category == HandCategory.fourOfAKind)
        #expect(rank6 > rank5)
        
        handle = evaluator.evaluate(card: h[6], handle: handle)
        let rank7 = try #require(evaluator.evaluate(handle: handle), "7 card hand should have rank")
        #expect(rank7.category == HandCategory.fourOfAKind)
        #expect(rank7 > rank6)
    }

    @Test("Straight Flush Hands")
    func straightFlushHands() throws {
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
        let rank5 = try #require(evaluator.evaluate(handle: handle), "5 card hand should have rank")
        #expect(rank5.category == HandCategory.straightFlush)
        
        handle = evaluator.evaluate(card: h[5], handle: handle)
        let rank6 = try #require(evaluator.evaluate(handle: handle), "6 card hand should have rank")
        #expect(rank6.category == HandCategory.straightFlush)
        #expect(rank6 > rank5)
        
        handle = evaluator.evaluate(card: h[6], handle: handle)
        let rank7 = try #require(evaluator.evaluate(handle: handle), "7 card hand should have rank")
        #expect(rank7.category == HandCategory.straightFlush)
        #expect(rank7 > rank6)
    }
}
