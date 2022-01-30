//
//  HandHandle.swift
//  
//
//  Created by Antti Ahvenlampi on 30.1.2022.
//

import Foundation

public struct HandHandle {
    
    let value: Int
    let hand: [Card]
    
    static var empty: HandHandle {
        return HandHandle(value: 53, hand: [])
    }
    
}
