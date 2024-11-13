//
//  TabBarItemCell.swift
//  Pixel-parade
//
//  Created by Vladimir Vishnyagov on 04/10/2017.
//  Copyright © 2017 Live Typing. All rights reserved.
//

import UIKit
import SDWebImage

class TabBarItemCell: UICollectionViewCell {
    
    @IBOutlet private var selectionTopLayerView: UIView!
    @IBOutlet private var selectionBottomLayerView: UIView!
    @IBOutlet private var imageView: UIImageView!
    
    func setSelected(selected: Bool) {
        selectionTopLayerView.isHidden = !selected
        selectionBottomLayerView.isHidden = !selected
    }
    
    func fillWith(pack: Pack?, at indexPath: IndexPath) {
        guard indexPath.item > 0, let pack = pack else { 
            imageView.contentMode = .center
            imageView.image = R.image.shopImage()
            return
        }
        guard let firstSticker = pack.stickersArrayBinded.first else { return }
        imageView.contentMode = .scaleAspectFit
        imageView.sd_setImage(with: firstSticker.filenameBinded, placeholderImage: R.image.sticker_placeholder(), options: [], completed: nil)
    }
    
}
