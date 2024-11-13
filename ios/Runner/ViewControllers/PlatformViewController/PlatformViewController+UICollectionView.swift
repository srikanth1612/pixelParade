//
//  PlatformViewController+UICollectionView.swift
//  Pixel-parade
//
//  Created by Vladimir Vishnyagov on 04/10/2017.
//  Copyright © 2017 Live Typing. All rights reserved.
//

import UIKit

extension PlatformViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tabBarItems.count
    }
    
}

extension PlatformViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.tabBarItemCell.identifier, for: indexPath) as? TabBarItemCell else { return UICollectionViewCell() }
        cell.setSelected(selected: indexPath.row == selectedIndex)
        cell.fillWith(pack: tabBarItems[indexPath.item].pack, at: indexPath)
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        let selectedPack = tabBarItems[indexPath.item].pack
        if selectedIndex == 0 { AnalyticsService.log(.goHome(source: childControllerType)) }
        if selectedIndex != 0, let viewControllers = containerTabBarController?.viewControllers {
            for (index, controller) in viewControllers.enumerated() {
                if let stickerPackController = controller as? StickerPackViewController,
                    let controllerPack = stickerPackController.pack,
                    let selectedPack = selectedPack,
                    selectedPack.id == controllerPack.id {
                    selectedIndex = index
                    break
                }
            }
        }
        tabBarCollectionView.reloadData()
        if let pack = selectedPack, let packName = pack.name {
            AnalyticsService.log(.packOpened(name: packName, packSize: pack.quantity, source: childControllerType))
        }
        guard let delegate = selectionDelegate else { return }
        delegate.selectStickerPackWith(id: selectedPack?.id)
    }
    
}
