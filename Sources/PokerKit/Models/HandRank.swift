//
//  HandRank.swift
//  
//
//  Created by Antti Ahvenlampi on 30.1.2022.
//

import Foundation

public enum HandCategory: UInt16 {
    case highCard = 1
    case onePair = 2
    case twoPair = 3
    case threeOfAKind = 4
    case straight = 5
    case flush = 6
    case fullHouse = 7
    case fourOfAKind = 8
    case straightFlush = 9
}

public struct HandRank {
    
    public let category: HandCategory
    public let rank: UInt16

    init?(value: Int) {
        guard value <= UInt16.max,
            let cat = HandCategory(rawValue: UInt16(value >> 12)) else {
            return nil
        }
        category = cat
        rank = UInt16(value & 0xfff)
    }
    
    private var value: UInt16 {
        return category.rawValue << 12 + rank
    }
    
}

extension HandRank: Comparable {
    public static func <(lhs: HandRank, rhs: HandRank) -> Bool {
        return lhs.value < rhs.value
    }
}
