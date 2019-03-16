//
//  Roll.swift
//  FiveThousand
//
//  Created by Burns Proctor on 10/7/18.
//  Copyright © 2018 Burns Proctor. All rights reserved.
//

import Foundation

class Dice {
    var rollNumber: Int
    var keep: Bool
    var locked: Bool
    
    init() {
        self.rollNumber = Int.random(in: 1...6)
        self.keep = false
        self.locked = false
    }
}
