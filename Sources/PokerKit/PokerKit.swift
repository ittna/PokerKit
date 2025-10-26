//
//  PokerKit.swift
//  
//
//  Created by Antti Ahvenlampi on 30.1.2022.
//

import Foundation

public enum PokerKit {

    public static func lookupTableHandEvaluator() -> HandEvaluator {
        return LookupTableHandEvaluator()
    }
    
    public static func defaultEquityCalculator(evaluator: HandEvaluator = lookupTableHandEvaluator()) -> EquityCalculator {
        return DefaultEquityCalculator(evaluator: evaluator)
    }

}
