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
            Card(rank: .ace, suit: .club),
            Card(rank: .king, suit: .club)
        ], board: [
            Card(rank: .queen, suit: .club),
            Card(rank: .jack, suit: .club),
            Card(rank: .ten, suit: .club),
        ], numOpponents: 1))
    }
    
    @Test("Test equity for AA in 2-player game")
    func calculateAAEquity() throws {
        #expect(abs(calculator.calculateEquity(hand: [
            Card(rank: .ace, suit: .club),
            Card(rank: .ace, suit: .heart)
        ], board: [
        ], numOpponents: 1) - 0.85) < 0.01)
    }
    
    @Test("Test equity for AKs in 2-player game")
    func calculateAKsEquity() throws {
        #expect(abs(calculator.calculateEquity(hand: [
            Card(rank: .ace, suit: .club),
            Card(rank: .king, suit: .club)
        ], board: [
        ], numOpponents: 1) - 0.67) < 0.01)
    }
    
    @Test("Test equity for 72o in 9-player game")
    func calculate72oEquity() throws {
        #expect(abs(calculator.calculateEquity(hand: [
            Card(rank: .seven, suit: .club),
            Card(rank: .two, suit: .heart)
        ], board: [
        ], numOpponents: 8) - 0.05) < 0.01)
    }

    @Test("Test equity with known opponent - hero has nuts")
    func calculateEquityWithKnownOpponentNuts() throws {
        let equity = calculator.calculateEquity(hand: [
            Card(rank: .ace, suit: .club),
            Card(rank: .king, suit: .club)
        ], board: [
            Card(rank: .queen, suit: .club),
            Card(rank: .jack, suit: .club),
            Card(rank: .ten, suit: .club),
            Card(rank: .nine, suit: .club),
            Card(rank: .eight, suit: .club)
        ], opponentHands: [
            [Card(rank: .ace, suit: .heart), Card(rank: .ace, suit: .diamond)]
        ])
        #expect(equity == 1.0)
    }

    @Test("Test equity with known opponent - hero dominated")
    func calculateEquityWithKnownOpponentDominated() throws {
        let equity = calculator.calculateEquity(hand: [
            Card(rank: .two, suit: .club),
            Card(rank: .three, suit: .club)
        ], board: [
            Card(rank: .ace, suit: .spade),
            Card(rank: .ace, suit: .heart),
            Card(rank: .king, suit: .spade),
            Card(rank: .king, suit: .heart),
            Card(rank: .queen, suit: .spade)
        ], opponentHands: [
            [Card(rank: .ace, suit: .club), Card(rank: .ace, suit: .diamond)]
        ])
        #expect(equity == 0.0)
    }

    @Test("Test equity with known opponent - chop")
    func calculateEquityWithKnownOpponentChop() throws {
        let equity = calculator.calculateEquity(hand: [
            Card(rank: .two, suit: .club),
            Card(rank: .three, suit: .club)
        ], board: [
            Card(rank: .ace, suit: .spade),
            Card(rank: .king, suit: .spade),
            Card(rank: .queen, suit: .spade),
            Card(rank: .jack, suit: .spade),
            Card(rank: .ten, suit: .spade)
        ], opponentHands: [
            [Card(rank: .two, suit: .heart), Card(rank: .three, suit: .heart)]
        ])
        #expect(equity == 0.5)
    }

    @Test("Test equity with known opponent - incomplete board")
    func calculateEquityWithKnownOpponentIncompleteBoard() throws {
        let equity = calculator.calculateEquity(hand: [
            Card(rank: .ace, suit: .club),
            Card(rank: .ace, suit: .heart)
        ], board: [
        ], opponentHands: [
            [Card(rank: .king, suit: .club), Card(rank: .king, suit: .heart)]
        ])
        // AA vs KK is about 82% equity
        #expect(abs(equity - 0.82) < 0.01)
    }

    @Test("Test equity with multiple known opponents")
    func calculateEquityWithMultipleKnownOpponents() throws {
        let equity = calculator.calculateEquity(hand: [
            Card(rank: .ace, suit: .club),
            Card(rank: .ace, suit: .heart)
        ], board: [
        ], opponentHands: [
            [Card(rank: .king, suit: .club), Card(rank: .king, suit: .heart)],
            [Card(rank: .queen, suit: .club), Card(rank: .queen, suit: .heart)]
        ])
        // AA vs KK and QQ should have good equity
        #expect(equity > 0.6)
    }

}
