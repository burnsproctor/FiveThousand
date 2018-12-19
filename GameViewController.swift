//
//  GameViewController.swift
//  FiveThousand
//
//  Created by Burns Proctor on 10/3/18.
//  Copyright © 2018 Burns Proctor. All rights reserved.
//

import Foundation
import UIKit

class GameViewController: UIViewController {
    var game: Game!
    var playerTurn: Turn!
    var dice = [Dice]()
    var playerIndex = 0
    var startingSelectedDiceCount = 0
    @IBOutlet var numberOfPlayasLabel: UILabel!
    @IBOutlet var playerNameLabel: UILabel!
    @IBOutlet var playerBankScore: UILabel!
    @IBOutlet var playerRollSetScore: UILabel!
    @IBOutlet var playerInLeadName: UILabel!
    @IBOutlet var scoreToBeat: UILabel!
    
    @IBOutlet var dice1: UIImageView!
    @IBOutlet var dice2: UIImageView!
    @IBOutlet var dice3: UIImageView!
    @IBOutlet var dice4: UIImageView!
    @IBOutlet var dice5: UIImageView!
    @IBOutlet var dice6: UIImageView!
    var diceImageViews = [UIImageView]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        numberOfPlayasLabel.text = String(game.numberOfPlayers)
        diceImageViews = [dice1,dice2,dice3,dice4,dice5,dice6]
        setDefaultDiceImages()
        playerInLeadName.text = "-"
        scoreToBeat.text = "-"
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        game.newPlayerTurn()
        getNewPlayerNameText(playerIndex: game.currentPlayerIndex)
    }
    
    
    func setDefaultDiceImages() {
        for diceImageView in diceImageViews {
            diceImageView.image = UIImage(named: "DefaultDice")
        }
    }
    
    
    @IBAction func bankPoints() {
        if let error = game.bankPoints() {
            alertHandler2(error: error)
            return
        }
        if game.currentTurn.checkForNewTurn() {
            alertHandler2(error: GameError.NewTurnAlert)
            game.newPlayerTurn()
        } else {
            game.endCurrentTurn()
        }
        setDefaultDiceImages()
        if game.player().turn == 1 && game.player().name == "Unknown Player" {
            getNewPlayerNameText(playerIndex: game.currentPlayerIndex)
        }
        updatePlayerScore()
        updatePlayerNameLabel()
    }
    
    
    @IBAction func rollTheDice() {
        // added here because alerts were overlapping each other
        if game.player().turn == 1 && game.player().name == "Unknown Player" {
            getNewPlayerNameText(playerIndex: game.currentPlayerIndex)
        }
        if let error = game.currentTurn.roll() {
            alertHandler2(error: error)
        }
        updateDice(dice: game.currentTurn.currentRollSet.diceSet)
        if let error = game.checkForBust() {
            game.endCurrentTurn()
            if game.checkForWin() {
                endGame()
                return
            }
            alertHandler2(error: error)
            setDefaultDiceImages()
            if game.player().turn == 1 && game.player().name == "Unknown Player" {
                getNewPlayerNameText(playerIndex: game.currentPlayerIndex)
            }
            updatePlayerScore()
            updatePlayerNameLabel()
        }
        updatePlayerScore()
    }
    
    
    @IBAction func selectDice(_ sender:UITapGestureRecognizer) {
        if game.currentTurn.currentRollSet.numberOfRolls > 0 {
            let imageView = sender.view as! UIImageView
                switch imageView {
                case dice1:
                    toggleDieImageHelper(imageView: dice1, diceIndex: 0)
                case dice2:
                    toggleDieImageHelper(imageView: dice2, diceIndex: 1)
                case dice3:
                    toggleDieImageHelper(imageView: dice3, diceIndex: 2)
                case dice4:
                    toggleDieImageHelper(imageView: dice4, diceIndex: 3)
                case dice5:
                    toggleDieImageHelper(imageView: dice5, diceIndex: 4)
                case dice6:
                    toggleDieImageHelper(imageView: dice6, diceIndex: 5)
                default:
                    fatalError("Invalid dice button")
                }
        }
    }
    
    
    func toggleDieImageHelper(imageView: UIImageView, diceIndex: Int) {
        if game.currentTurn.toggleDie(diceIndex: diceIndex) {
            let diceSelected = checkIfDiceSelected(diceIndex: diceIndex)
            imageView.image = UIImage(named: getDiceImage(diceNumber: (game.currentTurn.currentRollSet.diceSet[diceIndex].rollNumber), selected: diceSelected))
        } else {
            alertHandler2(error: GameError.InvalidImageToggle)
        }
    }
    
    
    func checkIfDiceSelected(diceIndex: Int) -> Bool {
        return game.currentTurn.currentRollSet.diceSet[diceIndex].keep
    }

    
    func updateDice(dice: [Dice]) {
        let diceImages: [UIImageView] = [dice1, dice2, dice3, dice4, dice5, dice6]
        var i = 0
        for diceImage in diceImages {
            let diceSelected = checkIfDiceSelected(diceIndex: i)
            diceImage.image = UIImage(named: getDiceImage(diceNumber: dice[i].rollNumber, selected: diceSelected))
            i = i + 1
        }
    }
    
    
    func updatePlayerNameLabel() {
        playerNameLabel.text = game.player().name
        if game.finalRound {
            playerInLeadName.text = game.players[game.finalRoundPlayerToBeatIndex].name
        }
    }
    
    
    func updatePlayerScore() {
        playerBankScore.text = String(game.player().score)
        playerRollSetScore.text = String(game.currentTurn.currentRollSet.score)
        if game.finalRound {
            scoreToBeat.text = String(game.finalRoundScoreToBeat)
        }
    }
    
    
    @IBAction func manualStartNewGame() {
        endGame()
    }
    
    
    func getNewPlayerNameText(playerIndex: Int) {
        let nameInput = UIAlertController(title: "Player \(playerIndex + 1)", message: "Enter Your Name", preferredStyle: .alert)
        nameInput.addTextField { (textField) in
            textField.placeholder = "Player \(playerIndex + 1)"
        }
        let confirmAction = UIAlertAction(title: "Enter", style: .default) { (_) in
            if let nameInput = nameInput.textFields?[0].text {
                self.playerNameLabel.text = self.game.setPlayerName(nameInput)
            }
        }
        nameInput.addAction(confirmAction)
        present(nameInput, animated: true, completion: nil)
    }
    
    
    func endGame() {
        var title = ""
        let message = "Do you want to play again with the same players?"
        if game.checkForWin() {
            title = "\(game.player().name) is the winner!"
        } else {
            title = "Want to start a new game?"
        }
        let endGameAlert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let restartGameWithSameNumberPlayers = UIAlertAction(title: "Yes", style: .default) { (_) in
            var previousPlayerNames = [String]()
            for oldPlayer in self.game.players {
                previousPlayerNames.append(oldPlayer.name)
            }
            self.game = Game(numberOfPlayers: self.game.numberOfPlayers)
            var i = 0
            for newPlayer in self.game.players {
                newPlayer.name = previousPlayerNames[i]
                i = i + 1
            }
            self.numberOfPlayasLabel.text = String(self.game.numberOfPlayers)
            self.setDefaultDiceImages()
            self.game.newPlayerTurn()
            self.updatePlayerScore()
            self.updatePlayerNameLabel()
            self.playerInLeadName.text = "-"
            self.scoreToBeat.text = "-"
        }
        let newGame = UIAlertAction(title: "No", style: UIAlertAction.Style.default, handler: {(action:UIAlertAction!)-> Void in
            self.performSegue(withIdentifier: "beginNewGame", sender: self)
        })
        endGameAlert.addAction(restartGameWithSameNumberPlayers)
        endGameAlert.addAction(newGame)
        present(endGameAlert, animated: true, completion: nil)
    }
    
    
    func alertHandler2(error: GameError) {
        let alert = UIAlertController(title: "", message: error.description, preferredStyle: .alert)
        let alertConfirm = UIAlertAction(title: "OK", style: .default) { (_) in}
        alert.addAction(alertConfirm)
        present(alert, animated: true, completion: nil)
    }
    
    
    func getDiceImage(diceNumber: Int, selected: Bool) -> String {
        var diceImageName = ""
        switch diceNumber {
        case 1:
            if selected == false {
                diceImageName = "Dice1"
            } else {
                diceImageName = "Dice1Toggled"
            }
        case 2:
            if selected == false {
                diceImageName = "Dice2"
            } else {
                diceImageName = "Dice2Toggled"
            }
        case 3:
            if selected == false {
                diceImageName = "Dice3"
            } else {
                diceImageName = "Dice3Toggled"
            }
        case 4:
            if selected == false {
                diceImageName = "Dice4"
            } else {
                diceImageName = "Dice4Toggled"
            }
        case 5:
            if selected == false {
                diceImageName = "Dice5"
            } else {
                diceImageName = "Dice5Toggled"
            }
        case 6:
            if selected == false {
                diceImageName = "Dice6"
            } else {
                diceImageName = "Dice6Toggled"
            }
        default:
            fatalError("Invalid dice number")
        }
        return diceImageName
    }
}
