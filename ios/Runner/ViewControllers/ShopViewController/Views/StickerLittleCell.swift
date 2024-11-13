//
//  StickerLittleCell.swift
//  Pixel-parade
//
//  Created by Vladimir Vishnyagov on 09/10/2017.
//  Copyright © 2017 Live Typing. All rights reserved.
//

import UIKit
import SDWebImage
import FLAnimatedImage

class StickerLittleCell: UICollectionViewCell {
    
    @IBOutlet private var imageView: FLAnimatedImageView!
    
    func fill(sticker: StickerPreview) {
        imageView.sd_setImage(with: sticker.filenameBinded, placeholderImage: R.image.sticker_placeholder(), options: [], completed: nil)
    }
    
}
