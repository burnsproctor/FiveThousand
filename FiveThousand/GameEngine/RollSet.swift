//
//  RollSet.swift
//  FiveThousand
//
//  Created by Burns Proctor on 10/7/18.
//  Copyright © 2018 Burns Proctor. All rights reserved.
//

import Foundation

class RollSet {
    var selectedDice: Bool
    var score: Int
    var startingScore: Int
    var numberOfRolls: Int
    var diceSet = [Dice]()
    var previousSelectedDiceCount = 0
    
    
    init() {
        self.selectedDice = false
        self.score = 0
        self.startingScore = 0
        self.numberOfRolls = 0
        self.diceSet = []
        self.previousSelectedDiceCount = 0
    }
    
    
    func roll() -> GameError? {
        if numberOfRolls == 0 {
            startingScore = score
            for _ in 0...5 {
                diceSet.append(Dice())
            }
            numberOfRolls = numberOfRolls + 1
            return nil
        } else {
            var currentSelectDiceCount = 0
            for die in diceSet {
                if die.keep == true {
                    currentSelectDiceCount = currentSelectDiceCount + 1
                }
            }
            if currentSelectDiceCount > previousSelectedDiceCount {
                let _ = scoreSelectedDice(setScore: true)
                diceSet = rollAgain(diceSet)
                numberOfRolls = numberOfRolls + 1
                previousSelectedDiceCount = currentSelectDiceCount
                return nil
            } else {
                return GameError.MustSelectScorableDie
            }
        }
    }

    
    func rollAgain(_ diceSet: [Dice]) -> [Dice] {
        for die in diceSet {
            if die.keep == false {
                die.rollNumber = Int.random(in: 1...6)
            } else {
                die.locked = true
            }
        }
        return diceSet
    }
    
    
    func checkForBust() -> Bool {
        var diceToCheck = [String: Int]()
        for die in diceSet {
            if die.locked == false {
                diceToCheck[String(die.rollNumber)] = (diceToCheck[String(die.rollNumber)] ?? 0) + 1
            }
        }
        for (key, value) in diceToCheck {
            if key == "1" && value > 0 {
                return false
            }
            if key == "2" && value > 3 {
                return false
            }
            if key == "3" && value > 3 {
                return false
            }
            if key == "4" && value > 3 {
                return false
            }
            if key == "5" && value > 0 {
                return false
            }
            if key == "6" && value > 3 {
                return false
            }
        }
        return true
    }
    
    
    func scoreSelectedDice(setScore: Bool) -> Int {
        var tempScore = score
        let diceToScore = combineDice()
        if diceToScore.count == 6 {
            tempScore += 2500
        } else {
            for (key, value) in diceToScore {
                if key == "1" {
                    if value < 3 {
                        tempScore += (100 * value)
                    } else if value >= 3 && value < 6 {
                        let d = value % 3
                        tempScore += 1000 + (100 * d)
                    } else if value == 6 {
                        tempScore += 5000
                    }
                }
                if key == "2" {
                    if value == 3 {
                        tempScore += 200
                    } else if value == 6 {
                        tempScore += 5000
                    }
                }
                if key == "3" {
                    if value == 3 {
                        tempScore += 300
                    } else if value == 6 {
                        tempScore += 5000
                    }
                }
                if key == "4" {
                    if value == 3 {
                        tempScore += 400
                    } else if value == 6 {
                        tempScore += 5000
                    }
                }
                if key == "5" {
                    if value < 3 {
                        tempScore += (50 * value)
                    } else if value >= 3 && value < 6 {
                        let d = value % 3
                        tempScore += 500 + (50 * d)
                    } else if value == 6 {
                        tempScore += 5000
                    }
                }
                if key == "6" {
                    if value == 3 {
                        tempScore += 600
                    } else if value == 6 {
                        tempScore += 5000
                    }
                }
            }
        }
        if setScore {
            score = tempScore
            return score
        } else {
            return tempScore
        }
    }

    
//    func scoreSixDice(diceToScore: [String: Int]) -> Int {
//        var numberOfKeys = 0
//        for i in 1...6 {
//            if diceToScore[String(i)] != nil {
//                numberOfKeys = numberOfKeys + 1
//            }
//        }
//        if numberOfKeys == 6 {
//            return 2500
//        }
//        return 5000
//    }
    
    
    func combineDice() -> [String: Int] {
        var combinedDice = [String: Int]()
        for die in diceSet {
            if die.locked == false && die.keep == true {
                combinedDice[String(die.rollNumber)] = (combinedDice[String(die.rollNumber)] ?? 0) + 1
            }
        }
        return combinedDice
    }
    
    
    func isValidScoring() -> GameError? {
        let diceToCheck = combineDice()
        
        // check if 1-6 works
        if diceToCheck.count == 6 {
            return nil
        }
        
        for (key, value) in diceToCheck {
            
            if key == "1" && value < 1 {
                return GameError.InvalidDiceSelection
            }
            if key == "2" {
                if value != 3 && value != 6 {
                    return GameError.InvalidDiceSelection
                }
            }
            if key == "3" {
                if value != 3 && value != 6 {
                    return GameError.InvalidDiceSelection
                }
            }
            if key == "4" {
                if value != 3 && value != 6 {
                    return GameError.InvalidDiceSelection
                }
            }
            if key == "5" && value < 1 {
                return GameError.InvalidDiceSelection
            }
            if key == "6" {
                if value != 3 && value != 6 {
                    return GameError.InvalidDiceSelection
                }
            }
        }
        return nil
    }
}

