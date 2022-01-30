import Foundation

public enum Rank: UInt8, CaseIterable {
    case two = 0
    case three = 1
    case four = 2
    case five = 3
    case six = 4
    case seven = 5
    case eight = 6
    case nine = 7
    case ten = 8
    case jack = 9
    case queen = 10
    case king = 11
    case ace = 12
}

extension Rank: CustomStringConvertible {
    public var description: String {
        if rawValue < 8 {
            return String(rawValue)
        } else {
            return ["T", "J", "Q", "K", "A"][Int(rawValue - 8)]
        }
    }
}
