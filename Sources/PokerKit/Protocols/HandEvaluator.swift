//
//  HandEvaluator.swift
//  
//
//  Created by Antti Ahvenlampi on 30.1.2022.
//

import Foundation

public protocol HandEvaluator {
    
    func evaluate(card: Card, handle: HandHandle) -> HandHandle
    func evaluate(handle: HandHandle) -> HandRank?
    
}
