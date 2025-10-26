# PokerKit

A Swift package for poker hand evaluation and equity calculation. PokerKit uses a lookup table-based algorithm with a large binary data file to efficiently evaluate poker hands and calculate hand equity against multiple opponents.

## Features

- **Fast Hand Evaluation**: Lookup table-based evaluation using a pre-computed 130MB binary data file
- **Incremental Card Processing**: Evaluate hands card-by-card for optimal performance
- **Hand Equity Calculation**: Calculate win probability against multiple opponents
- **Support for 5, 6, and 7 Card Hands**: Works with standard poker hand sizes
- **Protocol-Oriented Design**: Flexible architecture using Swift protocols
- **Swift Concurrency**: Built with StrictConcurrency for modern Swift apps

## Requirements

- Swift 6.2+
- macOS 10.15+ / iOS 13+ / watchOS 6+ / tvOS 13+

## Installation

### Swift Package Manager

Add PokerKit to your `Package.swift` dependencies:

```swift
dependencies: [
    .package(url: "https://github.com/ittna/PokerKit.git", from: "1.0.0")
]
```

Then add it to your target dependencies:

```swift
targets: [
    .target(
        name: "YourTarget",
        dependencies: ["PokerKit"]
    )
]
```

## Usage

### Hand Evaluation

Evaluate poker hands using the lookup table evaluator:

```swift
import PokerKit

// Create a hand evaluator
let evaluator = PokerKit.lookupTableHandEvaluator()

// Create some cards
let cards = [
    Card(rank: .ace, suit: .spades),
    Card(rank: .ace, suit: .hearts),
    Card(rank: .king, suit: .diamonds),
    Card(rank: .king, suit: .clubs),
    Card(rank: .queen, suit: .spades)
]

// Evaluate incrementally (recommended for performance)
var handle = HandHandle.empty
for card in cards {
    handle = evaluator.evaluate(card: card, handle: handle)
}

// Get the final hand rank
if let handRank = evaluator.evaluate(handle: handle) {
    print("Category: \(handRank.category)")  // e.g., "twoPair"
    print("Rank: \(handRank.rank)")          // Numeric rank for comparison
}
```

### Equity Calculation

Calculate the win probability of a hand against opponents:

```swift
import PokerKit

// Create an equity calculator
let calculator = PokerKit.defaultEquityCalculator()

// Your hole cards
let hand = [
    Card(rank: .ace, suit: .clubs),
    Card(rank: .king, suit: .clubs)
]

// Community cards (can be empty for preflop)
let board = [
    Card(rank: .queen, suit: .clubs),
    Card(rank: .jack, suit: .diamonds),
    Card(rank: .ten, suit: .hearts)
]

// Calculate equity against 1 opponent
let equity = calculator.calculateEquity(
    hand: hand,
    board: board,
    numOpponents: 1
)

print("Equity: \(equity * 100)%")  // e.g., "100%" for a royal flush
```

#### Equity Against Known Opponent Hands

When opponent hands are known (e.g., in all-in situations), you can calculate exact equity:

```swift
// All-in situation: you have AA, opponent has KK
let hand = [
    Card(rank: .ace, suit: .clubs),
    Card(rank: .ace, suit: .hearts)
]

let opponentHands = [
    [Card(rank: .king, suit: .clubs), Card(rank: .king, suit: .hearts)]
]

let board = []  // Preflop all-in

let equity = calculator.calculateEquity(
    hand: hand,
    board: board,
    opponentHands: opponentHands
)

print("Equity: \(equity * 100)%")  // ~82% for AA vs KK
```

This method also works with:
- Multiple known opponents
- Incomplete boards (automatically enumerates all runouts)
- Complete boards (instant calculation)

#### Equity Calculation Examples

```swift
// Pocket aces preflop heads-up
let aaPreflopEquity = calculator.calculateEquity(
    hand: [Card(rank: .ace, suit: .clubs), Card(rank: .ace, suit: .hearts)],
    board: [],
    numOpponents: 1
)
// Result: ~85% equity

// AKs preflop heads-up
let aksPreflopEquity = calculator.calculateEquity(
    hand: [Card(rank: .ace, suit: .clubs), Card(rank: .king, suit: .clubs)],
    board: [],
    numOpponents: 1
)
// Result: ~67% equity

// 72o in a 9-player game
let worstHandEquity = calculator.calculateEquity(
    hand: [Card(rank: .seven, suit: .clubs), Card(rank: .two, suit: .hearts)],
    board: [],
    numOpponents: 8
)
// Result: ~5% equity
```

### Hand Categories

The `HandCategory` enum includes all standard poker hand rankings:

- `highCard`
- `pair`
- `twoPair`
- `threeOfAKind`
- `straight`
- `flush`
- `fullHouse`
- `fourOfAKind`
- `straightFlush`

### Comparing Hands

`HandRank` conforms to `Comparable`, making it easy to compare hands:

```swift
let rank1 = evaluator.evaluate(handle: handle1)!
let rank2 = evaluator.evaluate(handle: handle2)!

if rank1 > rank2 {
    print("Hand 1 wins!")
} else if rank1 < rank2 {
    print("Hand 2 wins!")
} else {
    print("Split pot!")
}
```

## How It Works

### Hand Evaluation

1. Start with `HandHandle.empty` (initial value: 53)
2. For each card, call `evaluator.evaluate(card:handle:)` which looks up the next state in the lookup table
3. After 5-7 cards, call `evaluator.evaluate(handle:)` to get the final `HandRank`
4. The `HandRank` encodes both the hand category and rank strength in a single comparable value

### Equity Calculation

The equity calculator supports two modes:

1. **Unknown Opponents** (`calculateEquity(hand:board:numOpponents:)`):
   - Calculates equity against a specified number of random opponent hands
   - Exhaustively evaluates all possible combinations for smaller scenarios
   - Switches to Monte Carlo simulation (1M iterations) when combinations exceed 1 million

2. **Known Opponents** (`calculateEquity(hand:board:opponentHands:)`):
   - Calculates exact equity when opponent hands are known
   - Useful for all-in situations or hand range analysis
   - Handles incomplete boards by enumerating all possible runouts
   - Instant calculation for complete boards

Implementation details:
- Uses the swift-algorithms package for efficient combination generation
- Monte Carlo threshold: 1,000,000 combinations
- Properly handles chops (split pots) by dividing equity among winners

## Architecture

PokerKit uses a protocol-oriented design:

- `HandEvaluator` protocol: Interface for hand evaluation strategies
- `LookupTableHandEvaluator`: Concrete implementation using a pre-computed lookup table
- `EquityCalculator` protocol: Interface for equity calculation with two calculation modes
- `DefaultEquityCalculator`: Implementation supporting both exhaustive enumeration and Monte Carlo simulation

## Resources

The lookup table (`HandRanks.dat`, ~130MB) is tracked with Git LFS and bundled with the package. This file contains pre-computed hand rankings for efficient evaluation.

## Testing

Run tests using Swift Package Manager:

```bash
swift test
```

The test suite includes:
- Hand evaluation tests for all hand categories
- Equity calculation tests for various scenarios
- Edge case validation

## License

MIT License - see [LICENSE](LICENSE) file for details.

Copyright (c) 2022 Antti Ahvenlampi

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.
