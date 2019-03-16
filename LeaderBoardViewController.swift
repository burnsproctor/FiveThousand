//
//  LeaderBoardViewController.swift
//  FiveThousand
//
//  Created by Burns Proctor on 2/19/19.
//  Copyright © 2019 Burns Proctor. All rights reserved.
//

import Foundation
import SharkORM
import UIKit


class LeaderBoardViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var leaders = [Game_DB]()
    var playersInReplayGame = [Player_DB]()
    var selectedLeader = Game_DB()
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showReplayGamePopup" {
            if let vc = segue.destination as? ReplayGamePopupViewController {
                vc.winnerName = selectedLeader.winningPlayerName
                vc.replayPlayers = self.getReplayPlayers(gameID: (selectedLeader.id?.intValue)!)
            }
        }
    }
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.leaders = getLeaders()
        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
    }
    
    
    func getLeaders() -> [Game_DB] {
        let results : SRKResultSet = Game_DB.query().order(byDescending: "finalRoundScoreToBeat").fetch()
        return results as! [Game_DB]
    }
    
    
    func getReplayPlayers(gameID: Int) -> [Player_DB] {
        let results : SRKResultSet = Player_DB.query().where("gameID = ?", parameters: [gameID]).fetch()
        return results as! [Player_DB]
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return leaders.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellReuseIdentifier", for: indexPath)
        let leader = leaders[indexPath.row]
        if let cell = cell as? LeaderBoardCell {
            cell.leader = leader
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        selectedLeader = leaders[indexPath.row]
        self.performSegue(withIdentifier: "showReplayGamePopup", sender: self)
    }
}


class LeaderBoardCell: UITableViewCell {
    
    @IBOutlet var nameLabel: UILabel!
    var leader: Game_DB = Game_DB() {
        didSet {
            setupUi()
        }
    }
    
    // this is for optimization
    override func prepareForReuse() {
        leader = Game_DB()
    }
    
    func setupUi() {
        nameLabel.text = "\(leader.winningPlayerName) - \(leader.finalRoundScoreToBeat) - \(leader.completedAt)"
        nameLabel.sizeToFit()
    }
}

