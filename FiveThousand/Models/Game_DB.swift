//
//  Game_DB.swift
//  FiveThousand
//
//  Created by Burns Proctor on 2/11/19.
//  Copyright © 2019 Burns Proctor. All rights reserved.
//

import Foundation
import SharkORM

class Game_DB: SRKObject {
    @objc dynamic var numberOfPlayers: Int = 0
    @objc dynamic var winningPlayerIndex: Int = 0
    @objc dynamic var finalRoundScoreToBeat: Int = 0
    @objc dynamic var winningPlayerName: String = ""
    @objc dynamic var completedAt: String = ""
}
