//
//  UserSettings.swift
//  SpaceInvaders
//
//  Created by Разработчик on 30/03/2021.
//  Copyright © 2021 Разработчик. All rights reserved.
//

import Foundation

final class UserSettings {
  
  private enum SettingsKeys: String {
    case record
  }
  
  static var gameRecord: String! {
    get {
      return UserDefaults.standard.string(forKey: SettingsKeys.record.rawValue)
    }
    set{
      
      let defaults = UserDefaults.standard
      let key = SettingsKeys.record.rawValue
      
      if let newRecord = newValue {
        defaults.set(newRecord, forKey: key)
      } else {
        defaults.removeObject(forKey: key)
      }
    }
  }
  
}
