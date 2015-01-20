
//
//  GitHubService.swift
//  GitHub
//
//  Created by RYAN CHRISTENSEN on 1/19/15.
//  Copyright (c) 2015 RYAN CHRISTENSEN. All rights reserved.
//

import Foundation


class GitHubServiceController {
  var URLSession : NSURLSession
  
  init() {
    let ephemeralConfig = NSURLSessionConfiguration.ephemeralSessionConfiguration()
    
    self.URLSession = NSURLSession(configuration: ephemeralConfig)
  }
  
  func fetchRepositoriesForSearchTerm(searchTerm : String, callBack : ([Repository]?, String?) -> (Void)) {
    let url = NSURL(string: "http://127.0.0.1:3000")
    
    let dataTask = self.URLSession.dataTaskWithURL(url!, completionHandler: { (data, response, error) -> Void in
      if error == nil {
        if let httpResponse = response as? NSHTTPURLResponse {
          println(httpResponse.statusCode)
          switch httpResponse.statusCode {
          case 200...299:
            println("Working")
            if let jsonDictionary = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as? [String : AnyObject] {
              NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                var items = jsonDictionary["items"] as [[String : AnyObject]]
                var theRepositries = [Repository]()
                for repository in items {
                  var currentRepository = Repository(jsonDictionary: repository)
                  theRepositries.append(currentRepository)
                }
                callBack(theRepositries, nil)
              })
            }
          case 400...599:
            println("No Good")
            
          default:
            println("Default")
          }
        }
      }
    })
    dataTask.resume()
  }
}