
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
  
  let imageQueue = NSOperationQueue()
  
  
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
    
    let request = NSMutableURLRequest(URL: url!)
    request.setValue("token \(self.accessToken!)", forHTTPHeaderField: "Authorization")
    
    let dataTask = self.URLSession.dataTaskWithURL(url!, completionHandler: { (data, response, error) -> Void in
      if error == nil {
        if let httpResponse = response as? NSHTTPURLResponse {
          println(httpResponse.statusCode)
          switch httpResponse.statusCode {
          case 200...299:
            println("Working")
            if let jsonDictionary = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as? [String : AnyObject] {
              let items = jsonDictionary["items"] as [[String : AnyObject]]
              var theRepositries = [Repository]()
              for repository in items {
                let currentRepository = Repository(jsonDictionary: repository)
                theRepositries.append(currentRepository)
            }
              NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                callBack(theRepositries,nil)
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
  
  func fetchUserRepos(userName : String, callBack : ([Repository]?, String?) -> (Void)) {
    let url = NSURL(string: "https://api.github.com/users/\(userName)/repos")
    let request = NSMutableURLRequest(URL: url!)
    request.setValue("token \(self.accessToken!)", forHTTPHeaderField: "Authorization")
    
    let dataTask = self.URLSession.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
      if error == nil {
        if let httpResponse = response as? NSHTTPURLResponse {
          println(httpResponse.statusCode)
          switch httpResponse.statusCode {
          case 200...299:
            println("Got User Repo")
            if let jsonDicionary = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as? [AnyObject] {
              
              var repo = [Repository]()
              for item in jsonDicionary {
                if let jsonArray = item as? [String : AnyObject] {
                  let repos = Repository(jsonDictionary : jsonArray)
                  repo.append(repos)
                }
                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                  callBack(repo,nil)
                })
              }
            }
          default:
            println("idiot")
          }
        }
      }
    })
    dataTask.resume()
  }
  
  func fetchUserForSearchTerm(searchTerm : String, callBack : ([User]?, String?) -> (Void)) {
    let url = NSURL(string: "https://api.github.com/search/users?q=\(searchTerm)")
    let request = NSMutableURLRequest(URL: url!)
    request.setValue("token \(self.accessToken!)", forHTTPHeaderField: "Authorization")
    
    let dataTask = self.URLSession.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
      if error == nil {
        if let httpResponse = response as? NSHTTPURLResponse {
          switch httpResponse.statusCode {
          case 200...299:
            if let jsonDictionary = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as? [String : AnyObject] {
              if let itemsArray = jsonDictionary["items"] as? [[String : AnyObject]] {
                
                var users = [User]()
                
                for item in itemsArray {
                  let user = User(jsonDictionary: item)
                  users.append(user)
                }
                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                  callBack(users, nil)
                })
              }
             
            }
            
          default:
            println("Default \(httpResponse.statusCode)")
          }
        }
      } else {
        println(error.localizedDescription)
      }
    })
    dataTask.resume()
  }
  
  func fetchAvatarImageForUrl(url : String, completionHandler : (UIImage) -> (Void)) {
    let url = NSURL(string: url)
    
    self.imageQueue.addOperationWithBlock { () -> Void in
      let imageData = NSData(contentsOfURL: url!)
      let image = UIImage(data: imageData!)
      
      NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
        completionHandler(image!)
      })
    }
  }  
}