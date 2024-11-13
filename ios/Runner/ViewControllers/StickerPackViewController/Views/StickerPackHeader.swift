//
//  StickerPackHeader.swift
//  Pixel-parade
//
//  Created by Vladimir Vishnyagov on 04/10/2017.
//  Copyright © 2017 Live Typing. All rights reserved.
//

import UIKit

class StickerPackHeader: UICollectionReusableView {
    
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var descriptionTextView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configureViews()
        clearHeader()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        clearHeader()
    }
    
    private func configureViews() {
        descriptionTextView.textContainerInset = UIEdgeInsets()
        descriptionTextView.dataDetectorTypes = .all
        descriptionTextView.layoutManager.usesFontLeading = false
        descriptionTextView.textContainer.lineFragmentPadding = 0
        descriptionTextView.isEditable = false
        descriptionTextView.isScrollEnabled = false
    }
    
    private func clearHeader() {
        titleLabel.attributedText = nil
        descriptionTextView.attributedText =  nil
    }
    
    func fill(pack: Pack) {
        imageView.image = R.image.mainLogo()
        titleLabel.attributedText = NSAttributedString(string: pack.nameBinded, style: .text(.title(.ppAquaBlue)))
        descriptionTextView.attributedText = NSAttributedString(string: pack.descriptionTextBinded, style: .text(.description(.ppGray)))
    }
    
    class func heightForHeader(pack: Pack) -> CGFloat {
        let leftInset: CGFloat = 54
        let rightInset: CGFloat = 8
        let topSpace: CGFloat = 10
        let interLabelSpace: CGFloat = 1
        let bottomSpace: CGFloat = 7
        
        let maxWidth = Screen.width - leftInset - rightInset
        let titleLabelAttributedText = NSAttributedString(string: pack.nameBinded, style: .text(.title(.ppAquaBlue)))
        var height = topSpace + titleLabelAttributedText.getSize(widthLimit: maxWidth).height
        let descriptionAttributedText = NSAttributedString(string: pack.descriptionTextBinded, style: .text(.description(.ppGray)))
        height += interLabelSpace + descriptionAttributedText.getSize(widthLimit: maxWidth).height + bottomSpace
        return height
    }
    
}
