//
//  StickerViewController.swift
//  Pixel-parade
//
//  Created by Vladimir Vishnyagov on 16/10/2017.
//  Copyright © 2017 Live Typing. All rights reserved.
//

import UIKit
import SDWebImage
import FLAnimatedImage
import MBProgressHUD

class StickerViewController: UIViewController {
    
    var sticker: StickerFull?
    var dataSource: [SharingControlItem] = []
    
    @IBOutlet private var containerView: UIView!
    @IBOutlet private var shadowView: UIView!
    @IBOutlet private var imageView: FLAnimatedImageView!
    @IBOutlet private var sharingItemsCollectionView: UICollectionView!
    
    @IBOutlet private weak var containerViewTopConstraint: NSLayoutConstraint!
    @IBOutlet private weak var imageViewCenterYConstraint: NSLayoutConstraint!
    @IBOutlet private weak var shadowViewTopConstraint: NSLayoutConstraint!
    @IBOutlet private weak var sharingContainerViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var sharingContainerViewTop: NSLayoutConstraint!
    
    // MARK: - ViewController life-cycle
    
    override func loadView() {
        super.loadView()

        containerViewTopConstraint.constant = self.view.bounds.height
        view.layoutIfNeeded()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fillDataSource()
        configureCollectionView()
        
        if let sticker = sticker {
            imageView.sd_setImage(with: sticker.filenameBinded,
                                  placeholderImage: R.image.sticker_placeholder(),
                                  options: [],
                                  completed: nil)
        }
        
        if #available(iOS 11.0, *) {
            containerViewTopConstraint.constant = -UIApplication.shared.keyWindow!.rootViewController!.view.safeAreaInsets.bottom
        } else {
            containerViewTopConstraint.constant = 0
        }
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseOut, animations: {
            self.shadowView.alpha = 0.6
            self.view.layoutIfNeeded()
        }, completion: nil)
        logStickerOpened()
    }

    private func logStickerOpened() {
        guard let imageExtension = sticker?.filenameBinded.absoluteString.components(separatedBy: ".").last else { return }
        guard let stickerType = AnalyticEventType.StickerType(rawValue: imageExtension) else { return }
        guard let platformController = PlatformViewController.get() else { return }
        guard let pack = platformController.tabBarItems[platformController.selectedIndex].pack else { return }
        guard let stickerNumber = sticker?.position else { return }
        guard let packName = pack.name else { return }
        AnalyticsService.log(.stickerOpened(packName: packName, packSize: pack.quantity, stickerNumber: stickerNumber, stickerType: stickerType))
    }
    
    // MARK: - Helpers
    
    private func fillDataSource() {
        let iMessage = SharingControlItem(type: .iMessage)
        let whatsApp = SharingControlItem(type: .WhatsApp)
        let facebookMessenger = SharingControlItem(type: .Messenger)
        let snapChat = SharingControlItem(type: .Snapchat)
        let skype = SharingControlItem(type: .Skype)
        let viber = SharingControlItem(type: .Viber)
        let wechat = SharingControlItem(type: .WeChat)
        // TODO: - // mqqiapi - for qq international and https://itunes.apple.com/us/app/qq-international/id710380093?mt=8
        // Don't forget add URL Scheme to Plist !!!
        let qq = SharingControlItem(type: .QQMobile)
        let line = SharingControlItem(type: .Line)
        let telegram = SharingControlItem(type: .Telegram)
        let more = SharingControlItem(type: .More)
        
        let inputSocialItems = [whatsApp, facebookMessenger, snapChat, skype, viber, wechat, qq, line, telegram]
        var outputSocialItems = inputSocialItems
        outputSocialItems = outputSocialItems.filter { value -> Bool in
            guard let url = URL(string: value.url) else { return false }
            return UIApplication.shared.canOpenURL(url)
        }
        if outputSocialItems.count > 4 {
            outputSocialItems = outputSocialItems.enumerated().filter({ (value) -> Bool in
                return value.offset < 4
            }).map({ $0.element })
        } else if outputSocialItems.count < 4 {
            let tmp = inputSocialItems.filter({ (value) -> Bool in
                return !outputSocialItems.contains(where: { (valueInOutput) -> Bool in
                    return valueInOutput.type == value.type
                })
            })
            for i in 0..<4 - outputSocialItems.count {
                outputSocialItems.append(tmp[i])
            }
        }
        outputSocialItems.insert(iMessage, at: 0)
        outputSocialItems.append(more)
        
        dataSource = [iMessage, more]
    }
    
    private func configureCollectionView() {
        sharingItemsCollectionView.dataSource = self
        sharingItemsCollectionView.delegate = self
        
        let itemWidth = 96
        let itemHeight = 105
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
        flowLayout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        flowLayout.minimumLineSpacing = 0.0
        flowLayout.minimumInteritemSpacing = 0.0
        
        sharingItemsCollectionView.collectionViewLayout = flowLayout
        sharingItemsCollectionView.register(UINib(resource: R.nib.sharingItemCell),
                                            forCellWithReuseIdentifier: R.reuseIdentifier.sharingItemCell.identifier)
    }
    
    // MARK: - Actions
    
    @IBAction private func handleTapToShadowView(_ sender: UITapGestureRecognizer) {
        containerViewTopConstraint.constant = self.view.bounds.height
        UIView.animate(withDuration: 0.15, delay: 0.0, options: .curveEaseIn, animations: {
            self.shadowView.alpha = 0
            self.view.layoutIfNeeded()
        }, completion: { _ in
            self.dismiss(animated: false, completion: nil)
        })
    }
    
    func share(item: SharingControlItem) {
        guard let sticker = sticker else { return }
        logQuickShare(sticker: sticker, item: item)
        
        guard !item.url.isEmpty else {
            if item.type == .More {
                logStandardShare()
            }
            SharingHelper.share(toType: item.type, filenameURLString: sticker.filenameBinded.absoluteString, presenter: self, completion: nil)
            return
        }
        if let url = URL(string: item.url), UIApplication.shared.canOpenURL(url) {
            MBProgressHUD.showAdded(to: self.view, animated: true)
            SharingHelper.share(toType: item.type, filenameURLString: sticker.filenameBinded.absoluteString, presenter: self) { [weak self] in
                if let weakSelf = self {
                    MBProgressHUD.hide(for: weakSelf.view, animated: true)
                }
            }
        } else if let url = URL(string: item.appStoreLink), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            logStandardShare()
             SharingHelper.share(toType: .More, filenameURLString: sticker.filenameBinded.absoluteString, presenter: self, completion: nil)
            
        }
    }

    private func logQuickShare(sticker: StickerFull, item: SharingControlItem) {
        guard let platformController = PlatformViewController.get() else { return }
        guard let pack = platformController.tabBarItems[platformController.selectedIndex].pack else { return }
        guard let packName = pack.name else { return }
        guard let stickerExtension = sticker.filenameBinded.absoluteString.components(separatedBy: ".").last else { return }
        guard let stickerType = AnalyticEventType.StickerType(rawValue: stickerExtension) else { return }
        AnalyticsService.log(.quickShare(packName: packName, packSize: pack.quantity, stickerNumber: sticker.position, stickerType: stickerType, shareButtonName: item.title))
    }
    
    private func logStandardShare() {
        guard let platformController = PlatformViewController.get() else { return }
        guard let pack = platformController.tabBarItems[platformController.selectedIndex].pack else { return }
        guard let packName = pack.name else { return }
        guard let sticker = sticker else { return }
        guard let imageExtension = sticker.filenameBinded.absoluteString.components(separatedBy: ".").last else { return }
        guard let stickerType = AnalyticEventType.StickerType(rawValue: imageExtension) else { return }
        AnalyticsService.log(.standardShare(packName: packName, packSize: pack.quantity, stickerNumber: sticker.position, stickerType: stickerType))
    }

}
