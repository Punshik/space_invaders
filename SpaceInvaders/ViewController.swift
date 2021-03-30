//
//  ViewController.swift
//  SpaceInvaders
//
//  Created by Разработчик on 19/03/2021.
//  Copyright © 2021 Разработчик. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  
  var currentRecord = Int()

  @IBOutlet weak var record: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if(UserSettings.gameRecord != nil) {
      self.record.text = String(UserSettings.gameRecord)
    } else {
      self.record.text = "0"
    }
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(true)
    self.record.text = String(UserSettings.gameRecord)
  }
  
  @IBAction func unwindSegueToMainScreen(segue: UIStoryboardSegue) {
  }

}
