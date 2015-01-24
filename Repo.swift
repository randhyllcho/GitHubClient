//
//  Repo.swift
//  GitHub
//
//  Created by RYAN CHRISTENSEN on 1/19/15.
//  Copyright (c) 2015 RYAN CHRISTENSEN. All rights reserved.
//

import Foundation

struct Repository {
  let name : String
  let author : String
  let url : String
  
  init(jsonDictionary : [String : AnyObject]) {
    self.name = jsonDictionary["name"] as String
    self.url = jsonDictionary["html_url"] as String
    let ownerDictionary = jsonDictionary["owner"] as [String : AnyObject]
    self.author = ownerDictionary["login"] as String
  }
  
}
