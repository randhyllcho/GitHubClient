//
//  WebViewController.swift
//  GitHub
//
//  Created by RYAN CHRISTENSEN on 1/22/15.
//  Copyright (c) 2015 RYAN CHRISTENSEN. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
  
  let webView = WKWebView()
  var url : String!

    override func viewDidLoad() {
        super.viewDidLoad()
      self.title = "WebView"
      
      self.webView.frame = self.view.frame
      self.view.addSubview(self.webView)
      
      let request = NSURLRequest(URL: NSURL(string: self.url)!)
      self.webView.loadRequest(request)
        // Do any additional setup after loading the view.
    }

}
