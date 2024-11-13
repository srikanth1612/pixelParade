//
//  ShopCell.swift
//  Pixel-parade
//
//  Created by Vladimir Vishnyagov on 09/10/2017.
//  Copyright © 2017 Live Typing. All rights reserved.
//

import UIKit
import DownloadButton
import SwiftyStoreKit

class ShopCell: UITableViewCell {
    
    @IBOutlet private var packNameLabel: UILabel!
    @IBOutlet private var packCountLabel: UILabel!
    @IBOutlet private var descriptionTextView: UITextView!
    @IBOutlet private var collectionView: UICollectionView!
    @IBOutlet private var getButton: PKDownloadButton!
    @IBOutlet private var shadowView: UIView!
    
    var pack: Pack!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configureViews()
        clearCell()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        clearCell()
    }
    
    func clearCell() {
        packNameLabel.attributedText = nil
        packCountLabel.attributedText = nil
        descriptionTextView.attributedText =  nil
    }
    
    func fill(pack: Pack) {
        self.pack = pack
        collectionView.dataSource = self
        packNameLabel.attributedText = NSAttributedString(string: pack.nameBinded, style: .text(.title(.ppBlack)))
        packCountLabel.attributedText = NSAttributedString(string: pack.stickersCountBinded, style: .text(.subTitle(.ppBlack)))
        
        var descriptionAttributedText = NSAttributedString(string: pack.descriptionTextBinded, style: .text(.description(.ppGray)))
        descriptionAttributedText = descriptionAttributedText.addMaximumLineHeight(14)
        descriptionTextView.attributedText = descriptionAttributedText
        collectionView.reloadData()
        
        configureGetButton(price: pack.price)
        
        collectionView.contentOffset = CGPoint()
        // TODO: - Remember scrolling content offset
    }
    
    func configureViews() {
        configureShadow()
        configureTextView()
        configureCollectionView()
    }
    
    func configureGetButton(price: Double) {
// TODO: - Make right currency
//        let priceNumber = price as NSNumber
//        
//        let formatter = NumberFormatter()
//        formatter.numberStyle = .currency
//        formatter.string(from: priceNumber)
        
        let getButtonTitle = price == 0 ? R.string.localizable.shop_cellGet_buttonTitle() : "$\(price)"
        getButton.startDownloadButton.setAttributedTitle(NSAttributedString(string: getButtonTitle,
                                                                            style: .text(.button(.ppDeepSkyBlue))), for: .normal)
        getButton.startDownloadButton.setAttributedTitle(NSAttributedString(string: getButtonTitle,
                                                                            style: .text(.button(.ppWhite))), for: .selected)
        getButton.startDownloadButton.setAttributedTitle(NSAttributedString(string: getButtonTitle,
                                                                            style: .text(.button(.ppWhite))), for: .highlighted)
        getButton.startDownloadButton.setBackgroundImage(UIImage.buttonBackground(with: UIColor.ppDeepSkyBlue), for: .normal)
        getButton.startDownloadButton.setBackgroundImage(UIImage.highlitedButtonBackground(with: UIColor.ppDeepSkyBlue), for: .selected)
        getButton.startDownloadButton.setBackgroundImage(UIImage.highlitedButtonBackground(with: UIColor.ppDeepSkyBlue), for: .highlighted)
        getButton.delegate = self
    }
    
    func configureShadow() {
        let color = UIColor.ppWhite
        
        let gradient = CAGradientLayer()
        gradient.colors = [color.withAlphaComponent(0.0).cgColor, color.cgColor]
        gradient.locations = [0.0, 1.0]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.0)
        gradient.frame = CGRect(x: 0.0,
                                y: 0.0,
                                width: 15,
                                height: shadowView.frame.size.height)
        shadowView.layer.insertSublayer(gradient, at: 0)
        
        let whiteLayer = CALayer()
        whiteLayer.backgroundColor = color.cgColor
        whiteLayer.frame = CGRect(x: 15.0,
                                  y: 0.0,
                                  width: shadowView.frame.size.width - 15,
                                  height: shadowView.frame.size.height)
        shadowView.layer.insertSublayer(whiteLayer, at: 0)
    }
    
    func configureTextView() {
        descriptionTextView.textContainerInset = UIEdgeInsets()
        descriptionTextView.dataDetectorTypes = .all
        descriptionTextView.textContainer.maximumNumberOfLines = 1
        descriptionTextView.layoutManager.usesFontLeading = false
        descriptionTextView.textContainer.lineFragmentPadding = 0
        descriptionTextView.isEditable = false
        descriptionTextView.isScrollEnabled = false
        descriptionTextView.delegate = self
    }
    
    func configureCollectionView() {
        let itemWidth = 100
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 2, bottom: 0, right: 0)
        flowLayout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        flowLayout.minimumLineSpacing = 0.0
        flowLayout.minimumInteritemSpacing = 0.0
        flowLayout.footerReferenceSize = CGSize(width: itemWidth, height: itemWidth - 6)
        collectionView.collectionViewLayout = flowLayout
        collectionView.register(UINib(resource: R.nib.stickerLittleCell),
                                forCellWithReuseIdentifier: R.reuseIdentifier.stickerLittleCell.identifier)
        collectionView.register(UINib(resource: R.nib.getMoreFooter), forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: R.reuseIdentifier.getMoreFooter.identifier)
    }
    
}

extension ShopCell: PKDownloadButtonDelegate {
    
    func downloadButtonTapped(_ downloadButton: PKDownloadButton!, currentState state: PKDownloadButtonState) {
        guard let pack = pack else { return }
        logPayingEvent(for: pack)
        if pack.price == 0, UserStorage.fetchEmail() == nil {
            UserManager.getUserEmail(completion: {
                IAPHelper.buyStickerPack(pack: pack)
            })
            return
        }
        IAPHelper.buyStickerPack(pack: pack)
    }

    private func logPayingEvent(for pack: Pack) {
        guard let packName = pack.name else { return }
        if pack.price == 0 {
            AnalyticsService.log(.getPack(name: packName, packSize: pack.quantity))
        } else if pack.price > 0 {
            AnalyticsService.log(.buyPack(name: packName, packSize: pack.quantity, packCost: pack.price))
        }
    }

}

extension ShopCell: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        guard let pack = pack, let packName = pack.name else { return true }
        AnalyticsService.log(.linkClicked(name: packName, packSize: pack.quantity, link: URL.absoluteString))
        return true
    }
    
}
