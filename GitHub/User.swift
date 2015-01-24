//
//  User.swift
//  GitHub
//
//  Created by RYAN CHRISTENSEN on 1/21/15.
//  Copyright (c) 2015 RYAN CHRISTENSEN. All rights reserved.
//

import UIKit

struct User {
  let names : String
  let avatarURL : String
  var avatarImage : UIImage?
  var url : String
  
  init (jsonDictionary : [String : AnyObject]) {
    self.names = jsonDictionary["login"] as String
    self.avatarURL = jsonDictionary["avatar_url"] as String
    self.url = jsonDictionary["html_url"] as String
  }
}