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
    
    func fillWith(pack: Array<Dictionary<String,Any>>?, at indexPath: IndexPath) {
        guard indexPath.item > 0, let pack = pack else {
            imageView.contentMode = .center
            imageView.image =  UIImage(named: "shop-image")
            return
        }
//        guard let firstSticker = pack[0]
        imageView.contentMode = .scaleAspectFit
        imageView.sd_setImage(with: URL(string: "http://104.236.79.232/" + (pack[0]["filename"] as! String) ))
        //        }
    }
    
}
