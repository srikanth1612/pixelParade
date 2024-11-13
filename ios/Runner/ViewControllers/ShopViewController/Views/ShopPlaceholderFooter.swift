//
//  ShopPlaceholderFooter.swift
//  Pixel-parade
//
//  Created by Vladimir Vishnyagov on 18/10/2017.
//  Copyright © 2017 Live Typing. All rights reserved.
//

import UIKit

class ShopPlaceholderFooter: UIView {
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var textLabel: UILabel!

    func set(state: ShopScreenState) {
        let image: UIImage
        let text: String
        switch state {
        case .default:
            image = #imageLiteral(resourceName: "congratuation_placeholder_image-1")
            text = R.string.localizable.shopAllStickersHaveBeenBought()
        case .searching:
            image = #imageLiteral(resourceName: "stickers_not_found")
            text = R.string.localizable.shopStickersNotFound()
        }
        textLabel.attributedText = NSAttributedString(string: text,
                                                      style: .text(.description(.ppBlack)))
        imageView.image = image
    }

    class func viewFromNib() -> ShopPlaceholderFooter? {
        guard let headerView = UINib(resource: R.nib.shopPlaceholderFooter).instantiate(withOwner: nil, options: nil).first as? ShopPlaceholderFooter else { return nil }
        return headerView
    }
 
}
