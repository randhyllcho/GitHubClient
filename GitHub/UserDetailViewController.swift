
//
//  UserDetailViewController.swift
//  GitHub
//
//  Created by RYAN CHRISTENSEN on 1/21/15.
//  Copyright (c) 2015 RYAN CHRISTENSEN. All rights reserved.
//

import UIKit

class UserDetailViewController: UIViewController, UITableViewDataSource {

  var selectedUser : User!
  var repo = [Repository]()
  
  @IBOutlet weak var userNameLabel: UILabel!
  
  @IBOutlet weak var tableVIew: UITableView!
  
  @IBOutlet weak var userImageView: UIImageView!
  
  
  
    override func viewDidLoad() {
        super.viewDidLoad()
      self.userImageView.image = selectedUser.avatarImage
//      self.userImageView.layer.masksToBounds = true
//      self.userImageView.layer.cornerRadius = 75
      self.userNameLabel.text = selectedUser.name
        // Do any additional setup after loading the view.
    }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("USER_REPO_CELL", forIndexPath: indexPath) as UITableViewCell
    cell.textLabel?.text = repo[indexPath.row].name
    //cell.detailTextLabel?.text = selectedRepo.id
    return cell
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.repo.count
  }
  
  
  
  
  
  }
