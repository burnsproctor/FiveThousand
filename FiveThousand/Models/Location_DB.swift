//
//  Location_DB.swift
//  FiveThousand
//
//  Created by Burns Proctor on 4/22/19.
//  Copyright © 2019 Burns Proctor. All rights reserved.
//

import Foundation
import SharkORM

class Location_DB: SRKObject {
    @objc dynamic var latitude: Double = 0.0
    @objc dynamic var longitude: Double = 0.0
    @objc dynamic var gameID: Int = 0
}
