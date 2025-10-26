//
//  EquityEvaluator.swift
//  PokerKit
//
//  Created by Antti Ahvenlampi on 26.10.2025.
//

import Foundation

public protocol EquityCalculator {
    func calculateEquity(hand: [Card], board: [Card], numOpponents: Int) -> Double
    func calculateEquity(hand: [Card], board: [Card], opponentHands: [[Card]]) -> Double
}
