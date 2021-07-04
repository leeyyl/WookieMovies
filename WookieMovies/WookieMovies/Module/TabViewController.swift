//
//  TabViewController.swift
//  WookieMovies
//
//  Created by lee on 2021/1/25.
//

import UIKit

class TabViewController: UITabBarController {
    
    override class func description() -> String {
        "TabViewController"
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tabBar.tintColor = UIColor.label
        self.tabBar.barStyle = .default
        
        self.selectedIndex = 0
    }
}
