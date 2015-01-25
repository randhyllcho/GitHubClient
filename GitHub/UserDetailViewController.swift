
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
  
  var visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .ExtraLight)) as UIVisualEffectView
  
    override func viewDidLoad() {
        super.viewDidLoad()
      self.tableVIew.dataSource = self
     
      
//      let gradient = CAGradientLayer()
//      gradient.frame = self.tableVIew.frame
//      
//      var colors = [UIColor.blueColor(),UIColor.greenColor(),UIColor.blackColor()]
//      
//      gradient.colors = colors
//      
//      imageView.layer.insertSublayer(gradient, atIndex: 1)
      
      GitHubServiceController.sharedGitHubController.fetchUserRepos(selectedUser.names, callBack: { (Repository, error) -> (Void) in
        if error == nil {
          self.repo = Repository!
          self.tableVIew.reloadData()
          
          
        }
      })
      self.userImageView.image = selectedUser.avatarImage
//      self.userImageView.layer.masksToBounds = true
//      self.userImageView.layer.cornerRadius = 75
      self.userNameLabel.text = selectedUser.names
        // Do any additional setup after loading the view.
    }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    let imageView = UIImageView()
    imageView.frame = self.tableVIew.frame
    self.view.insertSubview(imageView, belowSubview: self.tableVIew)
    imageView.image = UIImage(named: "flowerPhoto.jpg")
    imageView.contentMode = UIViewContentMode.ScaleAspectFill
    self.view.clipsToBounds = true
    self.visualEffectView.frame = self.tableVIew.frame
    self.view.insertSubview(self.visualEffectView, aboveSubview: imageView)
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    self.navigationController?.delegate = nil
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("USER_REPO_CELL", forIndexPath: indexPath) as UITableViewCell
    var selectedUser = self.repo[indexPath.row]
    cell.textLabel?.text = selectedUser.name
    cell.detailTextLabel?.text = selectedUser.url
//    visualEffectView.frame = cell.bounds
//    cell.addSubview(visualEffectView)
    return cell
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.repo.count
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "USER_WEB" {
      let destinationVC = segue.destinationViewController as WebViewController
      let selectedIndexPath = self.tableVIew.indexPathForSelectedRow()
      let repos = self.repo[selectedIndexPath!.row]
      destinationVC.url = repos.url
    }
  }
  
  
  
  
  }
