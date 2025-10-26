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

- **Exhaustive Analysis**: For smaller scenarios, calculates exact equity by evaluating all possible card combinations
- **Monte Carlo Simulation**: For larger scenarios (>1M combinations), uses Monte Carlo sampling with 1 million iterations for fast approximation
- Uses the swift-algorithms package for efficient combination generation

## Architecture

PokerKit uses a protocol-oriented design:

- `HandEvaluator` protocol: Interface for hand evaluation strategies
- `LookupTableHandEvaluator`: Concrete implementation using a pre-computed lookup table
- `EquityCalculator` protocol: Interface for equity calculation
- `DefaultEquityCalculator`: Implementation supporting both combinatorial and Monte Carlo methods

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
