//
//  SharingItemCell.swift
//  Pixel-parade
//
//  Created by Vladimir Vishnyagov on 16/10/2017.
//  Copyright © 2017 Live Typing. All rights reserved.
//

import UIKit

struct SharingControlItem {
    var type: SharingType
    var image: UIImage
    var title: String
    var url: String
    var appStoreLink: String
    
    init(type: SharingType) {
        self.type = type
        self.image = type.image
        self.title = type.rawValue
        self.url = type.urlScheme
        self.appStoreLink = type.appStoreLink
    }
}

final class SharingItemCell: UICollectionViewCell {
    
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var selectionView: UIView!
    
    override var isHighlighted: Bool {
        didSet (newValue) {
            self.selectionView.isHidden = newValue
        }
    }
    
    func fill(controlItem: SharingControlItem) {
        imageView.image = controlItem.image
        titleLabel.text = controlItem.title
        
        if controlItem.type == .Telegram ||
            controlItem.type == .QQMobile ||
            controlItem.type == .Messenger {
            imageView.layer.borderWidth = 1 / Screen.scale
            imageView.layer.borderColor = UIColor(white: 0, alpha: 0.1).cgColor
        }
    }
    
}
