//
//  StickerViewController+UICollectionView.swift
//  Pixel-parade
//
//  Created by Vladimir Vishnyagov on 16/10/2017.
//  Copyright © 2017 Live Typing. All rights reserved.
//

import UIKit

extension StickerViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.sharingItemCell.identifier, for: indexPath)
        if let cell = cell as? SharingItemCell {
            cell.fill(controlItem: dataSource[indexPath.item])
        }
        return cell
    }
    
}

extension StickerViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let shareItem = dataSource[indexPath.item]
        share(item: shareItem)
    }
    
}
