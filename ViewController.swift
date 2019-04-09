//
//  ViewController.swift
//  FiveThousand
//
//  Created by Burns Proctor on 10/2/18.
//  Copyright © 2018 Burns Proctor. All rights reserved.
//

import UIKit
import SharkORM


class ViewController: UIViewController {
    var numberOfPlayas = 2
    var gameID = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showNewGame" {
            if let vc = segue.destination as? GameViewController {
                vc.game = Game(numberOfPlayers: numberOfPlayas)
            } 
        }
    }
    
    @IBAction func playersValueChanged(_ sender: UISegmentedControl) {
        numberOfPlayas = sender.selectedSegmentIndex + 2
    }
}





