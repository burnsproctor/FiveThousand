//
//  Player_DB.swift
//  FiveThousand
//
//  Created by Burns Proctor on 3/3/19.
//  Copyright © 2019 Burns Proctor. All rights reserved.
//

import Foundation
import SharkORM

class Player_DB: SRKObject {
    @objc dynamic var playerName: String = ""
    @objc dynamic var gameID: Int = 0
}
