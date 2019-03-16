//
//  Turn.swift
//  FiveThousand
//
//  Created by Burns Proctor on 10/7/18.
//  Copyright © 2018 Burns Proctor. All rights reserved.
//

import Foundation

class Turn {
    var player: Int
    var score: Int
    var busted: Bool
    var currentRollSet: RollSet
    
    init(player: Int) {
        self.player = player
        self.score = 0
        self.busted = false
        self.currentRollSet = RollSet()
    }
    
    
    func roll() -> GameError? {
        if let error = currentRollSet.roll() {
            return error
        }
        if currentRollSet.checkForBust() {
            busted = true
        }
        return nil
    }
    
    
    func toggleDie(diceIndex: Int) -> Bool {
        if currentRollSet.diceSet[diceIndex].locked == false {
            if currentRollSet.diceSet[diceIndex].keep == false {
                currentRollSet.diceSet[diceIndex].keep = true
                return true
            } else {
                currentRollSet.diceSet[diceIndex].keep = false
                return true
            }
        } else {
            return false
        }
    }
    
    
    func getRollSetScore() -> Int {
        let newPoints = currentRollSet.scoreSelectedDice(setScore: true)
        score = score + newPoints
        return score
    }
    
    
    func checkForNewTurn() -> Bool {
        var usedDice = 0
        for die in currentRollSet.diceSet {
            if die.keep == true || die.locked == true {
            usedDice = usedDice + 1
            }
        }
        if usedDice == 6 {
            return true
        }
        return false
    }
    
}
