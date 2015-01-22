
//
//  UserDetailViewController.swift
//  GitHub
//
//  Created by RYAN CHRISTENSEN on 1/21/15.
//  Copyright (c) 2015 RYAN CHRISTENSEN. All rights reserved.
//

import UIKit

class UserDetailViewController: UIViewController {

  var selectedUser : User!
  
  @IBOutlet weak var userImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
    
      self.userImageView.image = selectedUser.avatarImage
      
        // Do any additional setup after loading the view.
    }
  
  
  
  }
