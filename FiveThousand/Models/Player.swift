//
//  Player.swift
//  FiveThousand
//
//  Created by Burns Proctor on 10/2/18.
//  Copyright © 2018 Burns Proctor. All rights reserved.
//

import Foundation

class Player {
    
    var name: String
    var score: Int
    var turn: Int
    var hasLost: Bool
    
    init(name: String) {
        self.name = name
        self.score = 0
        self.turn = 0
        self.hasLost = false
    }
    
    convenience init() {
        self.init(name: "Unknown Player")
    }
    
    
}
