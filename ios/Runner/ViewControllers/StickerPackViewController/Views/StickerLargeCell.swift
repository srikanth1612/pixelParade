//
//  StickerLargeCell.swift
//  Pixel-parade
//
//  Created by Vladimir Vishnyagov on 04/10/2017.
//  Copyright © 2017 Live Typing. All rights reserved.
//

import UIKit
import FLAnimatedImage
import SDWebImage
import Messages

class StikerLargeCell: UICollectionViewCell {
    
    @IBOutlet private var placeholder: UIImageView!
    @IBOutlet private var msStickerView: MSStickerView!
    
    var operations: [SDWebImageOperation] = []
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        operations.forEach { (operation) in
            operation.cancel()
        }
        
        placeholder.isHidden = false
        msStickerView.stopAnimating()
        msStickerView.sticker = nil
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func fill(sticker: StickerFull) {
        diskStickerURL(filename: sticker.filenameBinded) { [weak self] url in
            guard let strongSelf = self else { return }
            do {
                let sticker = try MSSticker(contentsOfFileURL: url, localizedDescription: "")
                runThisInMainThread {
                    strongSelf.msStickerView.stopAnimating()
                    strongSelf.msStickerView.sticker = nil
                    
                    strongSelf.placeholder.isHidden = true
                    strongSelf.msStickerView.sticker = sticker
                    strongSelf.msStickerView.startAnimating()
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func diskStickerURL(filename: URL, completion: @escaping (_ imageURL: URL) -> Void) {
        SDImageCache.shared().diskImageExists(withKey: filename.absoluteString) { [weak self] exist in
            if exist {
                if let filePath = SDImageCache.shared().defaultCachePath(forKey: filename.absoluteString) {
                    completion(URL(fileURLWithPath: filePath))
                }
            } else if let strongSelf = self {
                strongSelf.operations.append(SDWebImageManager.shared().loadImage(with: filename, options: [], progress: nil) { [weak self] (image, _, error, cacheType, _, _) in
                    if cacheType == .disk, let filePath = SDImageCache.shared().defaultCachePath(forKey: filename.absoluteString) {
                        completion(URL(fileURLWithPath: filePath))
                    } else if let strongSelf = self, error == nil, image != nil {
                        strongSelf.diskStickerURL(filename: filename, completion: completion)
                    }
                }!)
            }
        }
    }
    
}
