import Foundation

public struct Card: Equatable, Hashable {
    public let rank: Rank
    public let suit: Suit

    public var id: Int {
        let r = Int(rank.rawValue)
        let s = Int(suit.rawValue)
        return 1 + s + 4 * r
    }

    public init(rank: Rank, suit: Suit) {
        self.rank = rank
        self.suit = suit
    }

    public static var deck: [Card] {
        return Suit.allCases
            .flatMap { s in Rank.allCases
                .map { r in Card(rank: r, suit: s) }
            }
    }
}

extension Card: CustomStringConvertible {
    public var description: String {
        return "\(rank)\(suit)"
    }
}
