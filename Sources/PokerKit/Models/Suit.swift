import Foundation

public enum Suit: Int, CaseIterable {
    case club = 0
    case diamond = 1
    case heart = 2
    case spade = 3
}

extension Suit: CustomStringConvertible {
    public var description: String {
        return ["♣", "♦", "♥", "♠"][rawValue]
    }
}
