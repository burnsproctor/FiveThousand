//
//  Game.swift
//  FiveThousand
//
//  Created by Burns Proctor on 10/2/18.
//  Copyright © 2018 Burns Proctor. All rights reserved.
//

import Foundation

class Game {
    var numberOfPlayers: Int
    var currentRound = 0
    var currentPlayerIndex = 0
    var turns = [Turn]()
    var currentTurn: Turn {
        get{
            return turns.last!
        }
    }
    var currentPlayerScore = 0
    var finalRound = false
    var finalRoundScoreToBeat = 0
    var finalRoundPlayerToBeatIndex = 0
    var finalRoundPointThreshold = 500
    var playersHaveLost = [Int]()
    var winningPlayerIndex = 0
    var currentRollSet: RollSet {
        get{
            return currentTurn.currentRollSet
        }
    }
    var players = [Player]()
    
    init(numberOfPlayers: Int) {
        self.numberOfPlayers = numberOfPlayers
        for _ in 0..<numberOfPlayers {
            players.append(Player())
        }
        self.turns.append(Turn(player: 0))
        self.playersHaveLost = []
    }
    
    
    func player() -> Player {
        guard currentPlayerIndex > 0 || currentPlayerIndex < players.count else {
            fatalError("Invalid player access")
        }
        return players[currentPlayerIndex]
    }
    
    
    func newPlayerTurn() {
        self.turns.append(Turn(player: currentPlayerIndex))
        player().turn = player().turn + 1
    }
    
    
    func bankPoints() -> GameError? {
        // check if select dice are valid for scoring
        if let error = currentTurn.currentRollSet.isValidScoring() {
            return error
        }
        if finalRound == false {
            standardScoringProcess()
            return nil
        } else {
            if let error = finalRoundScoringProcess() {
                return error
            }
            return nil
        }
    }
    
    
    func standardScoringProcess() {
        // save updated score and end current turn
        let _ = currentTurn.getRollSetScore()
        player().score = player().score + currentTurn.score
        // begin final round for first player to surpass finalRoundPointThreshold
        if player().score >= finalRoundPointThreshold {
            setFinalRoundDetails()
        }
    }
    
    
    func finalRoundScoringProcess() -> GameError? {
        // check to see if valid score and what the new points would be
        let potentialNewPoints = currentTurn.currentRollSet.scoreSelectedDice(setScore: false)
        // compare potential score to current high score and determine path
        if (player().score + potentialNewPoints) > finalRoundScoreToBeat {
            let _ = currentTurn.getRollSetScore()
            player().score = player().score + currentTurn.score
            finalRoundScoreToBeat = player().score
            finalRoundPlayerToBeatIndex = currentPlayerIndex
            return nil
        }
        if (player().score + potentialNewPoints) < finalRoundScoreToBeat {
            if currentTurn.checkForNewTurn() {
                let _ = currentTurn.getRollSetScore()
                player().score = player().score + currentTurn.score
                return nil
            }
        }
        return GameError.InvalidFinalRoundBanking
    }
    
    
    func setFinalRoundDetails() {
        finalRound = true
        finalRoundScoreToBeat = player().score
        finalRoundPlayerToBeatIndex = currentPlayerIndex
    }
    
    
    func endCurrentTurn() {
        currentPlayerIndex = getNextPlayerIndex(playerIndex: currentPlayerIndex)
        if playersHaveLost.contains(currentPlayerIndex) {
            endCurrentTurn()
        }
        newPlayerTurn()
    }
    
    
    func getNextPlayerIndex(playerIndex: Int) -> Int {
        var nextPlayerIndex = 0
        if playerIndex < (self.numberOfPlayers - 1) {
            nextPlayerIndex = playerIndex + 1
        }
        return nextPlayerIndex
    }
    
    
    func checkForBust() -> GameError? {
        if currentTurn.busted && !finalRound {
            return GameError.PlayerBusted
        } else if currentTurn.busted && finalRound {
            if player().score < finalRoundScoreToBeat {
                player().hasLost = true
                playersHaveLost.append(currentPlayerIndex)
                return GameError.PlayerBusted
            } else {
                return GameError.PlayerBusted
            }
        }
        return nil
    }
    
    
    func setPlayerName(_ name: String) -> String {
        if name.count == 0 {
            player().name = String("Player \(currentPlayerIndex + 1)")
        } else {
            player().name = name
        }
        return player().name
    }
    
    
    func checkForWin() -> Bool {
        if playersHaveLost.count == (numberOfPlayers - 1) {
            for i in 0..<numberOfPlayers {
                if !playersHaveLost.contains(i) {
                    winningPlayerIndex = i
                    return true
                }
            }
        }
        return false
    }
}


enum GameError: CustomStringConvertible {
    case InvalidDiceSelection
    case InvalidFinalRoundBanking
    case PlayerBusted
    case InvalidImageToggle
    case MustSelectScorableDie
    case NewTurnAlert

    var description: String {
        get {
            switch self {
            case .InvalidDiceSelection:
                return "You cannot bank the selected dice."
            case .InvalidFinalRoundBanking:
                return "Final round rules: you cannot bank points until you are in the lead."
            case .PlayerBusted:
                return "You busted, loser!"
            case .InvalidImageToggle:
                return "You cannot change a dice that was previously locked."
            case .MustSelectScorableDie:
                return "Must select at least one scorable dice to roll again."
            case .NewTurnAlert:
                return "Congrats! You get another turn."
            }
        }
    }
}
