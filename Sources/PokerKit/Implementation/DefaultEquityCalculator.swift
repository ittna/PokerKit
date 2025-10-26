//
//  File.swift
//  PokerKit
//
//  Created by Antti Ahvenlampi on 26.10.2025.
//

import Foundation
import Algorithms

private let maxCombinationsCount: Int = 1_000_000

struct DefaultEquityCalculator {
    private let evaluator: HandEvaluator
    
    init(evaluator: HandEvaluator) {
        self.evaluator = evaluator
    }
    
}

extension DefaultEquityCalculator: EquityCalculator {

    func calculateEquity(hand: [Card], board: [Card], opponentHands: [[Card]]) -> Double {
        precondition(hand.count == 2, "Holdem hand must have 2 cards")
        precondition(board.count <= 5, "Holdem board can have 0-5 cards")
        precondition(!opponentHands.isEmpty, "No sense to calculate equity for a single player")
        precondition(opponentHands.allSatisfy { $0.count == 2 }, "Each opponent hand must have 2 cards")

        let allCards = hand + board + opponentHands.flatMap { $0 }
        precondition(Set(allCards).count == allCards.count, "Cannot have duplicate cards")

        let deck = buildDeck(excluding: allCards)
        let boardHandle = createBoardHandle(from: board)
        let missingBoardCount = 5 - board.count

        if missingBoardCount == 0 {
            // Board is complete, just calculate equity directly
            return calculateEquity(
                hand: hand,
                boardHandle: boardHandle,
                opponentHands: opponentHands.map { ArraySlice($0) })
        }

        // Need to enumerate possible board completions
        return calculateAverageEquityOverBoardCompletions(
            hand: hand,
            boardHandle: boardHandle,
            deck: deck,
            missingBoardCount: missingBoardCount,
            opponentHands: opponentHands.map { ArraySlice($0) })
    }

    func calculateEquity(hand: [Card], board: [Card], numOpponents: Int) -> Double {
        precondition(hand.count == 2, "Holdem hand must have 2 cards")
        precondition(board.count <= 5, "Holdem board can have 0-5 cards")
        precondition(numOpponents > 0, "No sense to calculate equity for a single player")
        precondition(Set(hand + board).count == (hand.count + board.count), "Cannot have duplicate cards")

        let deck = buildDeck(excluding: hand + board)
        let boardHandle = createBoardHandle(from: board)
        let missingBoardCount = 5 - board.count
        let opponentCardsCount = 2 * numOpponents

        let combinations = deck.combinations(ofCount: missingBoardCount + opponentCardsCount)
        let combinationsCount = combinations.count

        if combinationsCount > maxCombinationsCount {
            // Monte Carlo estimation if too many combinations to go through
            return calculateEquityMonteCarlo(
                hand: hand,
                boardHandle: boardHandle,
                deck: deck,
                missingBoardCount: missingBoardCount,
                opponentCardsCount: opponentCardsCount,
                iterations: maxCombinationsCount)
        } else {
            return combinations
                .reduce(0.0) { totalEquity, combination in
                    let equity = calculateEquityForCombination(
                        hand: hand,
                        boardHandle: boardHandle,
                        combination: combination,
                        missingBoardCount: missingBoardCount,
                        opponentCardsCount: opponentCardsCount)
                    return totalEquity + equity
                } / Double(combinationsCount)
        }
    }

    // MARK: - Helper Methods

    private func buildDeck(excluding cards: [Card]) -> [Card] {
        var deck = Rank.allCases.flatMap { r in Suit.allCases.map { s in Card(rank: r, suit: s) } }
        deck.removeAll { cards.contains($0) }
        return deck
    }

    private func createBoardHandle(from board: [Card]) -> HandHandle {
        return board.reduce(HandHandle.empty) { evaluator.evaluate(card: $1, handle: $0) }
    }

    private func calculateAverageEquityOverBoardCompletions(
        hand: [Card],
        boardHandle: HandHandle,
        deck: [Card],
        missingBoardCount: Int,
        opponentHands: [ArraySlice<Card>]
    ) -> Double {
        let combinations = deck.combinations(ofCount: missingBoardCount)
        let combinationsCount = combinations.count

        if combinationsCount > maxCombinationsCount {
            // Monte Carlo estimation if too many combinations
            var sum: Double = 0.0
            for _ in 0..<maxCombinationsCount {
                let combination = Array(deck.shuffled().prefix(missingBoardCount))
                let completeBoard = combination.reduce(boardHandle) { evaluator.evaluate(card: $1, handle: $0) }
                sum += calculateEquity(
                    hand: hand,
                    boardHandle: completeBoard,
                    opponentHands: opponentHands)
            }
            return sum / Double(maxCombinationsCount)
        } else {
            return combinations
                .reduce(0.0) { totalEquity, combination in
                    let completeBoard = combination.reduce(boardHandle) { evaluator.evaluate(card: $1, handle: $0) }
                    let equity = calculateEquity(
                        hand: hand,
                        boardHandle: completeBoard,
                        opponentHands: opponentHands)
                    return totalEquity + equity
                } / Double(combinationsCount)
        }
    }

    private func calculateEquityMonteCarlo(
        hand: [Card],
        boardHandle: HandHandle,
        deck: [Card],
        missingBoardCount: Int,
        opponentCardsCount: Int,
        iterations: Int
    ) -> Double {
        var sum: Double = 0.0
        for _ in 0..<iterations {
            let combination = Array(deck.shuffled().prefix(missingBoardCount + opponentCardsCount))
            sum += calculateEquityForCombination(
                hand: hand,
                boardHandle: boardHandle,
                combination: combination,
                missingBoardCount: missingBoardCount,
                opponentCardsCount: opponentCardsCount)
        }
        return sum / Double(iterations)
    }

    private func calculateEquityForCombination(hand: [Card], boardHandle: HandHandle, combination: [Card], missingBoardCount: Int, opponentCardsCount: Int) -> Double {
        let otherPlayerHands = combination
            .dropLast(missingBoardCount)
            .chunks(ofCount: 2)
        let missingBoard = combination
            .dropFirst(opponentCardsCount)
        let handle = missingBoard
            .reduce(boardHandle) { evaluator.evaluate(card: $1, handle: $0) }
        return calculateEquity(
            hand: hand,
            boardHandle: handle,
            opponentHands: otherPlayerHands)
    }
    
    private func calculateEquity<S: Sequence>(hand: [Card], boardHandle: HandHandle, opponentHands: S) -> Double where S.Element == ArraySlice<Card> {
        guard let heroRank = evaluate(hand: hand, boardHandle: boardHandle) else {
            return 0.0
        }
        
        let enemyRanks = opponentHands
            .compactMap { evaluate(hand: Array($0), boardHandle: boardHandle) }
        
        if let maxEnemyRank = enemyRanks.max(), heroRank < maxEnemyRank {
            return 0.0
        }
        
        return 1.0 / Double(enemyRanks.count(where: { $0 == heroRank }) + 1)
    }
    
    private func evaluate(hand: [Card], boardHandle: HandHandle) -> HandRank? {
        return evaluator.evaluate(handle: hand
            .reduce(boardHandle, { evaluator.evaluate(card: $1, handle: $0) }))
    }
    
}
