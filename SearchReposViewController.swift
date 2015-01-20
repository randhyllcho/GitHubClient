//
//  SearchReposViewController.swift
//  GitHub
//
//  Created by RYAN CHRISTENSEN on 1/19/15.
//  Copyright (c) 2015 RYAN CHRISTENSEN. All rights reserved.
//

import UIKit

class SearchReposViewController: UIViewController, UITableViewDataSource, UISearchBarDelegate {

  @IBOutlet weak var tableView: UITableView!

  
  @IBOutlet weak var searchBar: UISearchBar!
  
  let GitHubService = GitHubServiceController()
  
  var userSearch : String?
  
  var repositories = [Repository]()
  
  
    override func viewDidLoad() {
        super.viewDidLoad()
      self.tableView.dataSource = self
      self.searchBar.delegate = self
      
              // Do any additional setup after loading the view.
    }

  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("SEARCH_CELL", forIndexPath: indexPath) as UITableViewCell
    cell.textLabel?.text = repositories[indexPath.row].name
    cell.detailTextLabel?.text = repositories[indexPath.row].author
    //cell.imageView?.image = repositories[indexPath.row].image
    
    return cell
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.repositories.count
  }
  
  func searchBarSearchButtonClicked(searchBar: UISearchBar) {
    println(userSearch)
    self.GitHubService.fetchRepositoriesForSearchTerm(searchBar.text, callBack: { (theRepositories, errorDescription) -> (Void) in
      if errorDescription == nil {
        println(theRepositories)
        self.repositories = theRepositories!
        self.tableView.reloadData()
      }
    })

    searchBar.resignFirstResponder()
  }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
