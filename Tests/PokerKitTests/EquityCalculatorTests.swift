//
//  EquityCalculatorTests.swift
//  PokerKit
//
//  Created by Antti Ahvenlampi on 26.10.2025.
//

import Testing
@testable import PokerKit

@Suite("Equity Calculator Tests")
struct EquityCalculatorTests {
    
    private let calculator = PokerKit.defaultEquityCalculator()

    @Test("Test equity for nuts in 2-player game")
    func calculateNutsEquity() throws {
        #expect(1.0 == calculator.calculateEquity(hand: [
            Card(rank: Rank.ace, suit: Suit.club),
            Card(rank: Rank.king, suit: Suit.club)
        ], board: [
            Card(rank: Rank.queen, suit: Suit.club),
            Card(rank: Rank.jack, suit: Suit.club),
            Card(rank: Rank.ten, suit: Suit.club),
        ], numOpponents: 1))
    }
    
    @Test("Test equity for AA in 2-player game")
    func calculateAAEquity() throws {
        #expect(abs(calculator.calculateEquity(hand: [
            Card(rank: Rank.ace, suit: Suit.club),
            Card(rank: Rank.ace, suit: Suit.heart)
        ], board: [
        ], numOpponents: 1) - 0.85) < 0.01)
    }
    
    @Test("Test equity for AKs in 2-player game")
    func calculateAKsEquity() throws {
        #expect(abs(calculator.calculateEquity(hand: [
            Card(rank: Rank.ace, suit: Suit.club),
            Card(rank: Rank.king, suit: Suit.club)
        ], board: [
        ], numOpponents: 1) - 0.67) < 0.01)
    }
    
    @Test("Test equity for 72o in 9-player game")
    func calculate72oEquity() throws {
        #expect(abs(calculator.calculateEquity(hand: [
            Card(rank: Rank.seven, suit: Suit.club),
            Card(rank: Rank.two, suit: Suit.heart)
        ], board: [
        ], numOpponents: 8) - 0.05) < 0.01)
    }

}
