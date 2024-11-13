//
//  BaseTabBarController.swift
//  pixelparadeiMessage
//
//  Created by Chethan Jayaram on 12/11/24.
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
