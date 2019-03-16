//
//  ReplayGamePopupViewController.swift
//  FiveThousand
//
//  Created by Burns Proctor on 3/14/19.
//  Copyright © 2019 Burns Proctor. All rights reserved.
//

import Foundation
import UIKit

class ReplayGamePopupViewController: UIViewController {
    
    var winnerName: String = ""
    var replayPlayers = [Player_DB]()
    @IBOutlet var winnerNameLabel: UILabel!
    @IBOutlet var replayPlayerNames: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.winnerNameLabel.text = self.winnerName
        var playerNames = [String]()
        for player in replayPlayers {
            playerNames.append(player.playerName)
        }
        self.replayPlayerNames.text = playerNames.joined(separator: ", ")
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showReplayGame" {
            if let vc = segue.destination as? GameViewController {
                vc.game = Game(replayPlayers: replayPlayers)
            }
        }
    }
    
    @IBAction func replayGame(_ sender: UIButton) {
        self.performSegue(withIdentifier: "showReplayGame", sender: self)
    }
    
    @IBAction func dismissPopup(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    
}
