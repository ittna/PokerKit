//
//  LookupTableHandEvaluator.swift
//  
//
//  Created by Antti Ahvenlampi on 30.1.2022.
//

import Foundation

private let handRanksCount = 32487834

class LookupTableHandEvaluator {
    
    private var lookupTable = [Int32](repeating: 0, count: handRanksCount)
    
    init() {
        guard let url = Bundle.module.url(forResource: "Resources/HandRanks", withExtension: "dat"),
            let data = try? Data(contentsOf: url) else {
            fatalError("Missing resource: HandRanks.dat")
        }

        guard data.count / 4 == handRanksCount else {
            fatalError("Invalid resource: HandRanks.dat")
        }
        _ = lookupTable.withUnsafeMutableBufferPointer { pointer in
            data.copyBytes(to: pointer)
        }
    }
    
}

extension LookupTableHandEvaluator : HandEvaluator {
    
    func evaluate(card: Card, handle: HandHandle) -> HandHandle {
        var hand = handle.hand
        hand.append(card)
        return HandHandle(
            value: Int(lookupTable[handle.value + card.id]),
            hand: hand)
    }
    
    func evaluate(handle: HandHandle) -> HandRank? {
        switch handle.hand.count {
        case 5,6: return HandRank(value: Int(lookupTable[handle.value]))
        case 7: return HandRank(value: handle.value)
        default: return nil
        }
    }
    
}
