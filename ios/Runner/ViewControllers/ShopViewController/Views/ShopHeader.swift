//
//  ShopHeader.swift
//  Pixel-parade
//
//  Created by Vladimir Vishnyagov on 09/10/2017.
//  Copyright © 2017 Live Typing. All rights reserved.
//

import UIKit

class ShopHeader: UIView {
    
    @IBOutlet private var cameraButton: UIButton!
    weak var delegate: ShopHeaderCameraDelegate?
    static let identifer = "Pixel_Parade.ShopHeader"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        cameraButton.setImage(R.image.baselinePhotoCamera24Px(), for: .normal)
        cameraButton.contentEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    }
    
    @IBAction private func cameraButtonTapped(_ sender: UIButton) {
        guard let delegate = delegate else { return }
        delegate.openCamera()
    }

    @IBAction private func searchDidPressed(_ sender: UIButton) {
        guard let delegate = delegate else { return }
        delegate.searchDidPressed()
    }

}
