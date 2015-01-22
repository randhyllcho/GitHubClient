//
//  User.swift
//  GitHub
//
//  Created by RYAN CHRISTENSEN on 1/21/15.
//  Copyright (c) 2015 RYAN CHRISTENSEN. All rights reserved.
//

import UIKit

struct User {
  let name : String
  let avatarURL : String
  var avatarImage : UIImage?
  
  init (jsonDictionary : [String : AnyObject]) {
    self.name = jsonDictionary["login"] as String
    self.avatarURL = jsonDictionary["avatar_url"] as String
  }
}