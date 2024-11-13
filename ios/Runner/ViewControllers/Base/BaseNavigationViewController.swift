//
//  BaseNavigationViewController.swift
//  Pixel-parade
//
//  Created by Pavel Pronin on 18/07/2017.
//  Copyright © 2017 Live Typing. All rights reserved.
//

import UIKit

class BaseNavigationViewController: UINavigationController {
    
    override var prefersStatusBarHidden: Bool {
        return topViewController?.prefersStatusBarHidden ?? super.prefersStatusBarHidden
    }
    
    override func loadView() {
        super.loadView()
        
        navigationBar.shadowImage = UIImage()
        delegate = self
    }
    
}

extension BaseNavigationViewController: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        let navigationBarIsHidden: Bool
        let navigationBarColor: UIColor
        switch viewController {
        case is StickerPhotoViewController:
            navigationBarIsHidden = false
            navigationBarColor = .ppLightCyan
        case is ShopViewController:
            navigationBarIsHidden = false
            navigationBarColor = .white
            navigationController.title = nil
        default:
            navigationBarIsHidden = true
            navigationBarColor = .white
        }
        navigationController.setNavigationBarHidden(navigationBarIsHidden, animated: animated)
        navigationController.navigationBar.barTintColor = navigationBarColor
        
    }
    
}
