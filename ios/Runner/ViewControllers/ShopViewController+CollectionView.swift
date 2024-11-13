//
//  ShopViewController+CollectionView.swift
//  Pixel-parade
//
//  Created by Mikhail Muzhev on 31/07/2019.
//  Copyright © 2019 Live Typing. All rights reserved.
//

import Foundation

extension ShopViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tags.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchTagCell.reuseIdentifier, for: indexPath)
        guard let tagCell = cell as? SearchTagCell else { return cell }
        let tag = tags[indexPath.row]
        tagCell.fill(with: tag)
        return tagCell
    }

}

extension ShopViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let tag = tags[safe: indexPath.item] else { return }
        searchDidPressed()
        searchBar.delegate?.searchBar?(searchBar, textDidChange: tag)
        AnalyticsService.log(.searchTag(input: tag))
        searchBar.text = tag
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        setShadows(hidden: true, forDisplayingCellAt: indexPath)
    }

    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        setShadows(hidden: false, forDisplayingCellAt: indexPath)
    }

    private func setShadows(hidden: Bool, forDisplayingCellAt indexPath: IndexPath) {
        if indexPath.row == tags.count - 1 {
            setHidden(view: rightTagsShadowView, isHidden: hidden)
        } else if indexPath.row == 0 {
            setHidden(view: leftTagsShadowView, isHidden: hidden)
        }
    }

    private func setHidden(view: UIView, isHidden: Bool) {
        UIView.animate(withDuration: 0.3) {
            view.alpha = isHidden ? 0: 1
        }
    }
}
