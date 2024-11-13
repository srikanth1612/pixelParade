//
//  StickerPackViewController+UICollectionView.swift
//  Pixel-parade
//
//  Created by Vladimir Vishnyagov on 04/10/2017.
//  Copyright © 2017 Live Typing. All rights reserved.
//

import UIKit
import SDWebImage

extension StickerPackViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        guard let sections = fetchedResultController.sections else { return 0 }
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let sections = fetchedResultController.sections, !sections.isEmpty else { return 0 }
        return sections[0].numberOfObjects
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.stikerLargeCell.identifier, for: indexPath)
        if let cell = cell as? StikerLargeCell {
            cell.fill(sticker: fetchedResultController.object(at: indexPath))
        }
        return cell
    }
    
    #if MAIN_APP
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: R.reuseIdentifier.stickerPackHeader.identifier, for: indexPath)
        if let stickerPackHeader = view as? StickerPackHeader {
            stickerPackHeader.fill(pack: pack)
        }
        return view
    }
    #endif
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        print(cell.bounds)
    }
    
}

extension StickerPackViewController: UICollectionViewDelegateFlowLayout {
    
    #if MAIN_APP
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: StickerPackHeader.heightForHeader(pack: pack))
    }
    #endif
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        #if MAIN_APP
            if let platform = PlatformViewController.get() {
                platform.performSegue(withIdentifier: R.segue.platformViewController.showSticker.identifier, sender: fetchedResultController.object(at: indexPath))
            }
        #else
            let sticker = fetchedResultController.object(at: indexPath)
            if let delegate = delegate {
                guard let fileCachedPath = SDImageCache.shared().defaultCachePath(forKey: sticker.filenameBinded.absoluteString) else { return }
                delegate.didSelectSticker(filename: fileCachedPath)
            }
        #endif
    }
    
}
