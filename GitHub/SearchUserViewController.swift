//
//  SearchUserViewController.swift
//  GitHub
//
//  Created by RYAN CHRISTENSEN on 1/21/15.
//  Copyright (c) 2015 RYAN CHRISTENSEN. All rights reserved.
//

import UIKit

class SearchUserViewController: UIViewController, UICollectionViewDataSource, UISearchBarDelegate, UINavigationControllerDelegate {

  @IBOutlet weak var collectionView: UICollectionView!
  @IBOutlet weak var searchBar: UISearchBar!
  
  var users = [User]()
  
    override func viewDidLoad() {
        super.viewDidLoad()
      self.collectionView.dataSource = self
      self.searchBar.delegate = self
      self.navigationController?.delegate = self
      self.collectionView.backgroundColor = UIColor.whiteColor()
        // Do any additional setup after loading the view.
    }
  
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return self.users.count
  }
  
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier("USER_CELL", forIndexPath: indexPath) as UserCell
    cell.imageView.image = nil
    var user = self.users[indexPath.row]
    if user.avatarImage == nil {
      GitHubServiceController.sharedGitHubController.fetchAvatarImageForUrl(user.avatarURL, completionHandler: { (image) -> (Void) in
        cell.imageView.image = image
        user.avatarImage = image
        self.users[indexPath.row] = user
      })
    } else {
      cell.imageView.image = user.avatarImage
    }
    return cell
  }

  func searchBarSearchButtonClicked(searchBar: UISearchBar) {
    searchBar.resignFirstResponder()
    
    GitHubServiceController.sharedGitHubController.fetchUserForSearchTerm(searchBar.text, callBack: { (users, error) -> (Void) in
      if error == nil {
        self.users = users!
        self.collectionView.reloadData()
      }
    })
  }
  
  func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    if toVC is UserDetailViewController {
    return ToUserDetailAnimationController()
    }
    return nil
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "SHOW_USER_DETAIL" {
      let destinationVC = segue.destinationViewController as UserDetailViewController
      let selectedIndexPath = self.collectionView.indexPathsForSelectedItems().first  as NSIndexPath
      destinationVC.selectedUser = self.users[selectedIndexPath.row]
      
    }
  }

}
