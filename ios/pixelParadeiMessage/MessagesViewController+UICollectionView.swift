//
//  MessagesViewController+UICollectionView.swift
//  Pixel-parade
//
//  Created by Vladimir Vishnyagov on 24/10/2017.
//  Copyright © 2017 Live Typing. All rights reserved.
//

import UIKit

extension MessagesViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tabBarItems.count
    }
    
}

extension MessagesViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TabBarItemCell", for: indexPath)
        guard let itemCell = cell as? TabBarItemCell else { return cell }
        itemCell.setSelected(selected: indexPath.row == selectedIndex)
        itemCell.fillWith(pack: tabBarItems[indexPath.item].pack, at: indexPath)
        
        return cell
//        if indexPath.row == 0 {
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TabBarItemCell", for: indexPath)
//            guard let itemCell = cell as? TabBarItemCell else { return cell }
//            return itemCell
//        } else {
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TabBarItemCell", for: indexPath)
//            guard let itemCell = cell as? TabBarItemCell else { return cell }
//    //        itemCell.setSelected(selected: indexPath.row == selectedIndex)
//            itemCell.fillWith(pack: self.totalStickers[indexPath.row - 1], at: indexPath)
//            return itemCell
//        }
       
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        guard indexPath.row == 0 else {
            selectedIndex = indexPath.row
            containerTabBarController.selectedIndex = selectedIndex - 1
            fakeTabBar.reloadData()
//            return
//        }
//        guard let context = self.extensionContext else { return }
//        guard let url = URL(string: "pixelparade://") else { return }
//        context.open(url, completionHandler: nil)
    }
    
}
