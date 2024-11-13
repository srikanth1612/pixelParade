//
//  StickerPhotoViewController+UICollectionView.swift
//  Pixel-parade
//
//  Created by Roman Solodyankin on 19/06/2019.
//  Copyright © 2019 Live Typing. All rights reserved.
//

import UIKit
import SDWebImage
import FLAnimatedImage

// MARK: - UICollectionViewDelegate

let kExpectedStickerWidth: CGFloat = 178.0

extension StickerPhotoViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let stickerImageView = FLAnimatedImageView(frame: CGRect(x: 0, y: 0, width: kExpectedStickerWidth, height: kExpectedStickerWidth))
        logStickerToPhoto(at: indexPath)
        let sticker = frc.object(at: indexPath)
        stickerImageView.sd_setImage(with: sticker.filenameBinded, placeholderImage: R.image.sticker_placeholder(), options: [], completed: { [weak self] (image, _, _, _) in
            runThisInMainThread {
                guard let strongSelf = self else { return }
                guard let image = image else { return }
                
                stickerImageView.frame.size = image.resize(image, toWidth: kExpectedStickerWidth)
                strongSelf.containerView.addSubview(stickerImageView)
                strongSelf.stickers.append(stickerImageView)
                strongSelf.addedStickers[stickerImageView] = sticker
                stickerImageView.center = strongSelf.containerView.center
            }
        })
        
        configureGestureRecognizer(for: stickerImageView)
    }

    private func logStickerToPhoto(at indexPath: IndexPath) {
        guard let imageExtension = frc.object(at: indexPath).filenameBinded.absoluteString.components(separatedBy: ".").last else { return }
        guard let stickerType = AnalyticEventType.StickerType(rawValue: imageExtension) else { return }
        guard let platformController = PlatformViewController.get() else { return }
        guard let pack = platformController.tabBarItems[platformController.selectedIndex].pack else { return }
        guard let packName = pack.name else { return }
        AnalyticsService.log(.stickerToPhoto(packName: packName, packSize: pack.quantity, stickerNumber: indexPath.row, stickerType: stickerType))
    }
    
}

// MARK: - UICollectionViewDataSource

extension StickerPhotoViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        guard let sections = frc.sections else { return 0 }
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let sections = frc.sections, !sections.isEmpty else { return 0 }
        return sections[section].numberOfObjects
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.stikerLargeCell.identifier, for: indexPath) as? StikerLargeCell else { return UICollectionViewCell() }
        cell.fill(sticker: frc.object(at: indexPath))
        return cell
    }

}
