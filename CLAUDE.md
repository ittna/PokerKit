# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

PokerKit is a Swift package for poker hand evaluation. It uses a lookup table-based algorithm with a large binary data file (HandRanks.dat, ~130MB) to efficiently evaluate poker hands.

## Common Commands

### Building
```bash
swift build -v
```

### Testing
```bash
# Run all tests
swift test -v

# Run all tests with xUnit output (for CI)
swift test -v --xunit-output test-results/test.xml --parallel

# Run a specific test
swift test --filter "HandEvaluatorTests"
```

### Linting
```bash
# SwiftLint runs automatically on PRs via GitHub Actions
# To run locally (if SwiftLint is installed):
swiftlint
```

## Architecture

### Core Design Pattern

The package uses a **Protocol-Oriented Design** with the `HandEvaluator` protocol as the main abstraction. Hand evaluation is implemented through a lookup table strategy that processes cards incrementally.

### Key Components

1. **HandEvaluator Protocol** (`Protocols/HandEvaluator.swift`)
   - Defines the interface for all hand evaluation strategies
   - Two methods: `evaluate(card:handle:)` for incremental evaluation and `evaluate(handle:)` for final ranking

2. **LookupTableHandEvaluator** (`Implementation/LookupTableHandEvaluator.swift`)
   - Concrete implementation using a pre-computed lookup table
   - Loads a 130MB binary data file (`HandRanks.dat`) from Resources
   - Supports 5, 6, and 7 card hands
   - Uses `HandHandle` for incremental card-by-card evaluation

3. **Models**
   - `Card`: Represents a playing card with `rank` and `suit`, has an `id` computed property used for lookup table indexing
   - `HandHandle`: Tracks evaluation state as cards are added incrementally (contains `value` for lookup and `hand` array)
   - `HandRank`: Final evaluation result with `category` (high card, pair, etc.) and `rank` for comparison
   - `Rank` and `Suit`: Standard playing card enumerations

4. **Factory Pattern** (`PokerKit.swift`)
   - `PokerKit.lookupTableHandEvaluator()` provides the standard evaluator instance

### How Hand Evaluation Works

1. Start with `HandHandle.empty` (value: 53)
2. For each card, call `evaluator.evaluate(card:handle:)` which:
   - Looks up the next state using `lookupTable[handle.value + card.id]`
   - Returns a new `HandHandle` with updated value and hand array
3. After 5-7 cards, call `evaluator.evaluate(handle:)` to get the final `HandRank`
4. HandRank encodes both category (hand type) and rank (strength within category) in a single value for comparison

### Resources and Git LFS

The `HandRanks.dat` file is tracked with Git LFS due to its size. CI/CD workflows include `git lfs checkout` to ensure the file is available during builds and tests.

## Swift Package Configuration

- Minimum Swift version: 6.2
- Supports macOS 10.15+, iOS 13+, watchOS 6+, tvOS 13+
- Uses StrictConcurrency experimental feature
- Resources are copied (not processed) to support Bundle.module access
- SwiftLint disabled rule: `identifier_name`

## Testing Framework

Uses Swift Testing (not XCTest). Key patterns:
- `@Suite` for test grouping
- `@Test` for individual tests
- `#expect` for assertions
- `#require` for non-optional unwrapping in tests
