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

}
