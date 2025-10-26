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
    
    func calculateEquity(hand: [Card], board: [Card], numOpponents: Int) -> Double {
        precondition(hand.count == 2, "Holdem hand must have 2 cards")
        precondition(board.count <= 5, "Holdem board can have 0-5 cards")
        precondition(numOpponents > 0, "No sense to calculate equity for a single player")
        precondition(Set(hand + board).count == (hand.count + board.count), "Cannot have duplicate cards")
        
        var deck = Rank.allCases.flatMap { r in Suit.allCases.map { s in Card(rank: r, suit: s) } }
        deck.removeAll { hand.contains($0) || board.contains($0) }
        
        let boardHandle = board.reduce(HandHandle.empty) { evaluator.evaluate(card: $1, handle: $0) }
        let missingBoardCount = 5 - board.count
        let opponentCardsCount = 2 * numOpponents
        let combinations = deck
            .combinations(ofCount: missingBoardCount + opponentCardsCount)
        let combinationsCount = combinations.count
        if combinationsCount > maxCombinationsCount {
            // Monte Carlo estimation if too many combinations to go through
            var sum: Double = 0.0
            for _ in 0..<maxCombinationsCount {
                let combination = Array(deck.shuffled()
                    .prefix(missingBoardCount + opponentCardsCount))
                sum += calculateEquity(
                    hand: hand,
                    boardHandle: boardHandle,
                    combination: combination,
                    missingBoardCount: missingBoardCount,
                    opponentCardsCount: opponentCardsCount)
            }
            return sum / Double(maxCombinationsCount)
        } else {
            return combinations
                .reduce(0.0) { totalEquity, combination in
                    let equity = calculateEquity(
                        hand: hand,
                        boardHandle: boardHandle,
                        combination: combination,
                        missingBoardCount: missingBoardCount,
                        opponentCardsCount: opponentCardsCount)
                    return totalEquity + equity
                } / Double(combinationsCount)
        }
    }
    
    private func calculateEquity(hand: [Card], boardHandle: HandHandle, combination: [Card], missingBoardCount: Int, opponentCardsCount: Int) -> Double {
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
