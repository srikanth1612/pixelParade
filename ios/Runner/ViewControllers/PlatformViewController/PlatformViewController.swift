//
//  PlatformViewController.swift
//  Pixel-parade
//
//  Created by Vladimir Vishnyagov on 04/10/2017.
//  Copyright © 2017 Live Typing. All rights reserved.
//

import UIKit
import MBProgressHUD
import CoreData
import DownloadButton

protocol StickerPackSelectionProtocol: class {
    func selectStickerPackWith(id: Int32?)
}

protocol PlatformTabBarDelegate: class {
    func selectFirstStickerPack()
    func selectShop()
    func toggleSelectionDelegate(_ delegate: StickerPackSelectionProtocol?)
}

// MARK: - fake model, begin code

enum TabBarItemType {
    case shop
    case sticker
}

typealias TabBarItem = (type: TabBarItemType, pack: Pack?)

// MARK: - end code

final class PlatformViewController: UIViewController {
    
    @IBOutlet var restorePurchaseButton: PKDownloadButton!
    @IBOutlet var tabBarCollectionView: UICollectionView!
    
    weak var containerTabBarController: BaseTabBarController?
    weak var selectionDelegate: StickerPackSelectionProtocol?
    var hud: MBProgressHUD?
    var childControllerType: AnalyticEventType.Source = .main
    
    var selectedIndex = 0
    var tabBarItems: [TabBarItem] = [TabBarItem(type: .shop,
                                                pack: nil)]
    
    lazy var frcPacks: NSFetchedResultsController <Pack> = {
        let fr = NSFetchRequest<Pack>(entityName: NSStringFromClass(Pack.self))
        fr.predicate = NSPredicate(format: "isPurchased = true")
        let purchasedDateSortDescriptor = NSSortDescriptor(key: "purchasedDate", ascending: false)
        let positionSortDescriptor = NSSortDescriptor(key: "position", ascending: true)
        fr.sortDescriptors = [purchasedDateSortDescriptor, positionSortDescriptor]
        let frc = NSFetchedResultsController(fetchRequest: fr,
                                             managedObjectContext: StorageService.shared.dataStack.viewContext,
                                             sectionNameKeyPath: nil,
                                             cacheName: nil)
        frc.delegate = self
        return frc
    } ()
    
    override var prefersStatusBarHidden: Bool {
        let defaultStatusBarIsHidden = false
        guard let baseTabBarController = children.first as? BaseTabBarController else { return defaultStatusBarIsHidden }
        return baseTabBarController.prefersStatusBarHidden
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        selectionDelegate = self
        if !UserStorage.fetchRestoredPurchases() {
            configureRestorePurchasesButton()
        } else {
            restorePurchaseButton.removeFromSuperview()
        }
        
        tabBarCollectionView.delegate = self
        tabBarCollectionView.dataSource = self
        tabBarCollectionView.register(UINib(resource: R.nib.tabBarItemCell),
                                      forCellWithReuseIdentifier: R.reuseIdentifier.tabBarItemCell.identifier)
        if let containerTabBarController = containerTabBarController {
            containerTabBarController.viewControllers = [R.storyboard.shop().instantiateInitialViewController()!]
            containerTabBarController.selectedIndex = selectedIndex
        }
        
        do {
            try frcPacks.performFetch()
        } catch {
            print(error.localizedDescription)
        }
        reloadTabBar()
    }
    
    func configureRestorePurchasesButton() {
        restorePurchaseButton.isHidden = false
        let title = R.string.localizable.restorePurchases().uppercased()
        restorePurchaseButton.startDownloadButton.setAttributedTitle(NSAttributedString(string: title,
                                                                                        style: .text(.button(.ppDeepSkyBlue))), for: .normal)
        restorePurchaseButton.startDownloadButton.setAttributedTitle(NSAttributedString(string: title,
                                                                                        style: .text(.button(.ppWhite))), for: .selected)
        restorePurchaseButton.startDownloadButton.setAttributedTitle(NSAttributedString(string: title,
                                                                                        style: .text(.button(.ppWhite))), for: .highlighted)
        restorePurchaseButton.startDownloadButton.setBackgroundImage(UIImage.buttonBackground(with: UIColor.ppDeepSkyBlue), for: .normal)
        restorePurchaseButton.startDownloadButton.setBackgroundImage(UIImage.highlitedButtonBackground(with: UIColor.ppDeepSkyBlue), for: .selected)
        restorePurchaseButton.startDownloadButton.setBackgroundImage(UIImage.highlitedButtonBackground(with: UIColor.ppDeepSkyBlue), for: .highlighted)
        restorePurchaseButton.delegate = self
    }
    
    func reloadTabBar() {
        guard let sections = frcPacks.sections, !sections.isEmpty else { return }
        let numberOfObjects = sections[0].numberOfObjects
        guard let containerTabBarController = containerTabBarController else { return }
        guard var controllers = containerTabBarController.viewControllers else { return }
        controllers = controllers.filter({ (navigationController) -> Bool in
            guard let navigationController = navigationController as? BaseNavigationViewController else { return false }
            return !(navigationController.topViewController is StickerPackViewController)
        })
        tabBarItems = [TabBarItem(type: .shop, pack: nil)]
        for i in 0..<numberOfObjects {
            let indexPath = IndexPath(item: i, section: 0)
            let pack = frcPacks.object(at: indexPath)
            self.tabBarItems.append(TabBarItem(type: .sticker, pack: pack))
        }
        self.tabBarItems.forEach { (tuple) in
            switch tuple.type {
            case .shop:
                break
            default:
                if let navigationController = R.storyboard.stickerPack().instantiateInitialViewController() as? BaseNavigationViewController, let stikersViewController = navigationController.topViewController as? StickerPackViewController {
                    if let pack = tuple.pack {
                        stikersViewController.pack = pack
                    }
                    controllers.append(navigationController)
                }
            }

        }
        tabBarCollectionView.reloadData()
        containerTabBarController.viewControllers = controllers
        containerTabBarController.selectedIndex = selectedIndex
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let tabBarController = segue.destination as? BaseTabBarController {
            containerTabBarController = tabBarController
        } else if let detailNavigationController = segue.destination as? BaseNavigationViewController,
               let detailViewController = detailNavigationController.topViewController as? StickerViewController,
               let sticker = sender as? StickerFull {
            detailViewController.sticker = sticker
        }
    }
    
    class func get() -> PlatformViewController? {
        
        guard let window = UIApplication.shared.keyWindow else { return nil }
        guard let rootViewController = window.rootViewController else { return nil }
        guard let platformNavigationController = rootViewController as? BaseNavigationViewController else { return nil }
        guard let platform = platformNavigationController.topViewController as? PlatformViewController else { return nil }
        return platform
    }
    
    class func showHud() {
        guard let platform = get() else { return }
        platform.hud = MBProgressHUD.showAdded(to: platform.view, animated: true)
    }
    
    class func hideHud() {
        runThisInMainThread {
            guard let platform = get() else { return }
            guard let hud = platform.hud else { return }
            hud.hide(animated: true)
        }

    }
    
    class func showShop() {
        guard let platform = get() else { return }
        guard let containerTabBarController = platform.containerTabBarController else { return }
        guard let tabBarCollectionView = platform.tabBarCollectionView else { return }
        platform.selectedIndex = 0
        platform.childControllerType = .main
        containerTabBarController.selectedIndex = 0
        tabBarCollectionView.reloadData()
    }
    
    private func restorePurchases(fromReceipt receipt: String, downloadButton: PKDownloadButton) {
        PackManager.restorePurchases(receipt: receipt, completion: { ids in
            PackStorage.syncRestoredPurchases(ids: ids, completion: {
                UserStorage.persistRestoredPurchases()
                PlatformViewController.hideHud()
                downloadButton.removeFromSuperview()
            })
        }, failure: { [weak self] in
            guard let strongSelf = self else { return }
            PlatformViewController.hideHud()
            strongSelf.showMessage(R.string.localizable.error(), message: R.string.localizable.errorInternalServer())
        })
    }
    
    private func restorePurchases(downloadButton: PKDownloadButton) {
        UserStorage.persistRestoredPurchases()
        showMessage(R.string.localizable.errorNothingRestore())
        PlatformViewController.hideHud()
        downloadButton.removeFromSuperview()
    }
    
}

// MARK: - PKDownloadButtonDelegate

extension PlatformViewController: PKDownloadButtonDelegate {
    
    func downloadButtonTapped(_ downloadButton: PKDownloadButton!, currentState state: PKDownloadButtonState) {
        PlatformViewController.showHud()
        AnalyticsService.log(.restorePurchases)
        IAPHelper.restorePurchases(completion: { [weak self] hasPurchases in
            IAPHelper.fetchReceipt(completion: { receipt in
                guard let strongSelf = self else { return }
                guard let receipt = receipt else {
                    strongSelf.showMessage(R.string.localizable.errorReceiptMissing())
                    PlatformViewController.hideHud()
                    downloadButton.removeFromSuperview()
                    return
                }
                guard hasPurchases else {
                   strongSelf.restorePurchases(downloadButton: downloadButton)
                    return
                }
                strongSelf.restorePurchases(fromReceipt: receipt, downloadButton: downloadButton)
            })
        }, failure: { [weak self] in
            guard let strongSelf = self else { return }
            PlatformViewController.hideHud()
            strongSelf.showMessage(R.string.localizable.error(), message: R.string.localizable.errorStoreKitRestore())
        })
    }
    
}

extension PlatformViewController: StickerPackSelectionProtocol {
    
    func selectStickerPackWith(id: Int32?) {
        guard let containerTabBarController = containerTabBarController else { return }
        containerTabBarController.selectedIndex = selectedIndex
    }
    
}

extension PlatformViewController: PlatformTabBarDelegate {
    
    func selectFirstStickerPack() {
        guard tabBarItems.count > 1 else { return }
        selectedIndex = 1
        tabBarCollectionView.reloadData()
    }
    
    func selectShop() {
        selectedIndex = 0
        tabBarCollectionView.reloadData()
    }
    
    func toggleSelectionDelegate(_ delegate: StickerPackSelectionProtocol?) {
        selectionDelegate = delegate ?? self
    }
    
}
