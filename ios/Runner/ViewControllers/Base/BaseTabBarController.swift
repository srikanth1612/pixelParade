//
//  BaseTabBarController.swift
//  Pixel-parade
//
//  Created by Vladimir Vishnyagov on 04/10/2017.
//  Copyright © 2017 Live Typing. All rights reserved.
//

import UIKit

class BaseTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UITabBar.appearance().shadowImage = UIImage()
        UITabBar.appearance().backgroundImage = UIImage()
        
        self.tabBar.layer.shadowOffset = CGSize(width: 0, height: -1)
        self.tabBar.layer.shadowRadius = 4
        self.tabBar.layer.shadowColor = UIColor.black.cgColor
        self.tabBar.layer.shadowOpacity = 0.1
        self.tabBar.clipsToBounds = false
        self.tabBar.layer.zPosition = 1
        self.tabBar.barTintColor = UIColor.white
    }
    
    override var prefersStatusBarHidden: Bool {
        return selectedViewController?.prefersStatusBarHidden ?? super.prefersStatusBarHidden
    }
    
}
