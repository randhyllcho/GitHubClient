
//
//  GitHubService.swift
//  GitHub
//
//  Created by RYAN CHRISTENSEN on 1/19/15.
//  Copyright (c) 2015 RYAN CHRISTENSEN. All rights reserved.
//

import UIKit


class GitHubServiceController {
  
  class var sharedGitHubController : GitHubServiceController {
    struct Static {
      static let instance : GitHubServiceController = GitHubServiceController()
    }
    return Static.instance
  }
  
  var URLSession : NSURLSession
  let clientID = "241967d861185cb2fa0c"
  let clientSecret = "59d785c266f8e8e26a4767cecc607e49fd697fd0"
  let accessTokenUserDefaultKey = "accessToken"
  var accessToken : String?
  
  
  
  init() {
    let ephemeralConfig = NSURLSessionConfiguration.ephemeralSessionConfiguration()
    self.URLSession = NSURLSession(configuration: ephemeralConfig)
    if let accessToken = NSUserDefaults.standardUserDefaults().objectForKey(self.accessTokenUserDefaultKey) as? String {
      self.accessToken = accessToken
    }
    
  }
  
  func requestAccessToken() {
    let url = "https://github.com/login/oauth/authorize?client_id=\(self.clientID)&scope=user,repo"
    UIApplication.sharedApplication().openURL(NSURL(string: url)!)
  }
  
  func handleCallbackURL(url: NSURL) {
    let code = url.query
    
    let oauthURL = "https://github.com/login/oauth/access_token?\(code!)&client_id=\(self.clientID)&client_secret=\(self.clientSecret)"
    let postRequest = NSMutableURLRequest(URL: NSURL(string: oauthURL)!)
    postRequest.HTTPMethod = "POST"
    
    let dataTask = self.URLSession.dataTaskWithRequest(postRequest, completionHandler: { (data, response, error) -> Void in
      if error == nil {
        if let httpResponse = response as? NSHTTPURLResponse {
          switch httpResponse.statusCode {
          case 200...299:
            let tokenResponse = NSString(data: data, encoding: NSASCIIStringEncoding)
            let accessTokenComponent = tokenResponse?.componentsSeparatedByString("&").first as String
            let accessToken = accessTokenComponent.componentsSeparatedByString("=").last
            
            NSUserDefaults.standardUserDefaults().setObject(accessToken!, forKey: self.accessTokenUserDefaultKey)
            NSUserDefaults.standardUserDefaults().synchronize()
            
          default:
            println("default not really")
          }
        }
      }
    })
    dataTask.resume()
  }
  
  func fetchRepositoriesForSearchTerm(searchTerm : String, callBack : ([Repository]?, String?) -> (Void)) {
    let url = NSURL(string: "https://api.github.com/search/repositories?q=\(searchTerm)")
    let dataTask = self.URLSession.dataTaskWithURL(url!, completionHandler: { (data, response, error) -> Void in
      if error == nil {
        if let httpResponse = response as? NSHTTPURLResponse {
          println(httpResponse.statusCode)
          switch httpResponse.statusCode {
          case 200...299:
            println("Working")
            if let jsonDictionary = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as? [String : AnyObject] {
              NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                let items = jsonDictionary["items"] as [[String : AnyObject]]
                var theRepositries = [Repository]()
                for repository in items {
                  let currentRepository = Repository(jsonDictionary: repository)
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