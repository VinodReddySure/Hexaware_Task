//
//  HelpViewController.swift
//  Hexaware
//
//  Created by Vinod Reddy Sure on 07/01/21.
//  Copyright © 2021 Vinod Reddy Sure. All rights reserved.
//

import UIKit
import WebKit

class HelpViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "App Usage Helper"

        self.webView.loadHTMLString("Home Screen:\nShowing a list of locations that the user has bookmarked previously", baseURL: nil)
        let headerString = "<header><meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no'></header>"
        
        webView.loadHTMLString(headerString + "<p>\(Constants.string.point1)<p><p>\(Constants.string.point2)<p><p>\(Constants.string.point3)<p><p>\(Constants.string.point4)<p><p>\(Constants.string.point5)<p>", baseURL: nil)
        
    }

}
