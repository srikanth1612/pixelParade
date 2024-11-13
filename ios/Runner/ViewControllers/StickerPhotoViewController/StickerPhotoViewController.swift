//
//  StickerPhotoViewController.swift
//  Pixel-parade
//
//  Created by Roman Solodyankin on 17/06/2019.
//  Copyright © 2019 Live Typing. All rights reserved.
//

import UIKit
import CoreData
import FLAnimatedImage

final class StickerPhotoViewController: UIViewController {

    @IBOutlet private var scrollView: UIScrollView!
    @IBOutlet private var photoImageView: UIImageView!
    @IBOutlet private var collectionView: UICollectionView!
    @IBOutlet private var dragToDeleteView: DragToDeleteView!
    @IBOutlet var containerView: UIView!
    
    weak var tabBarDelegate: PlatformTabBarDelegate?
    var addedStickers: [FLAnimatedImageView: StickerFull] = [:]
    private var selectedImage: UIImage?
    private var initialTransform: CGAffineTransform?
    private var gestures = Set<UIGestureRecognizer>(minimumCapacity: 3)
    var stickers = [FLAnimatedImageView]()
    private var fetchedResultsController: NSFetchedResultsController<StickerFull>?
    var frc: NSFetchedResultsController<StickerFull> {
        guard fetchedResultsController == nil else { return fetchedResultsController! }
        let fetchRequest: NSFetchRequest<StickerFull> = StickerFull.fetchRequest()
        let managedObjectContext = StorageService.shared.dataStack.viewContext
        fetchRequest.predicate = NSPredicate(value: false)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "position", ascending: true)]
        let resultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController = resultsController
        do {
            try fetchedResultsController!.performFetch()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror)")
        }
        return fetchedResultsController!
    }
    private let stickerInactiveAlpha: CGFloat = 0.2
    private let stickerDefaultAplha: CGFloat = 1
    private let shareButtonContentInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 0)
    private let shareButtonImageInsets = UIEdgeInsets(top: -5, left: 0, bottom: 0, right: 0)
    private let shareButtonTitleInsets = UIEdgeInsets(top: 0, left: 6, bottom: 0, right: -6)
    private let semiOpacity: CGFloat = 0.5
    
    // MARK: - ViewController life-cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let selectedImage = selectedImage else { return }
        photoImageView.image = selectedImage
        photoImageView.backgroundColor = .clear
        containerView.backgroundColor = .clear
        scrollView.backgroundColor = .black
        configureNavigationBar()
        configureScrollView()
        configureCollectionView()
        configureFlowLayout()
        dragToDeleteView.isHidden = true
        
        guard let tabBarDelegate = tabBarDelegate else { return }
        tabBarDelegate.toggleSelectionDelegate(self)
        guard let id = PackStorage.getFirstBoughtPackId() else { return }
        selectStickerPackWith(id: id)
        tabBarDelegate.selectFirstStickerPack()
    }
    
    deinit {
        guard let tabBarDelegate = tabBarDelegate else { return }
        tabBarDelegate.toggleSelectionDelegate(nil)
        tabBarDelegate.selectShop()
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // MARK: - Helpers
    
    // MARK: Public
    
    /// Function to pass selected photo from library/camera screen
    ///
    /// - Parameter image: selected photo
    func setSelectedImage(_ image: UIImage) {
        selectedImage = image
    }
    
    private func generateHapticFeedback() {
        let generator = UINotificationFeedbackGenerator()
        generator.prepare()
        generator.notificationOccurred(.success)
    }
    
    /// Configuration for sticker view: add gesture recognizers
    ///
    /// - Parameter sticker: view that contains added sticker from stickerpack
    func configureGestureRecognizer(for sticker: UIView) {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handleGesture(gesture:)))
        panGesture.cancelsTouchesInView = false
        panGesture.delegate = self
        sticker.isUserInteractionEnabled = true
        sticker.isMultipleTouchEnabled = true
        sticker.addGestureRecognizer(panGesture)
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handleGesture(gesture:)))
        pinchGesture.cancelsTouchesInView = false
        pinchGesture.delegate = self
        sticker.addGestureRecognizer(pinchGesture)
        let rotationGesture = UIRotationGestureRecognizer(target: self, action: #selector(handleGesture(gesture:)))
        rotationGesture.cancelsTouchesInView = false
        rotationGesture.delegate = self
        sticker.addGestureRecognizer(rotationGesture)
    }
    
    // MARK: Private
    
    /// Handling gesture, that fires now
    ///
    /// - Parameter gesture: gesture that fires
    @objc private func handleGesture(gesture: UIGestureRecognizer) {
        guard let sticker = stickers.first(where: { $0 === gesture.view }) else { return }
        switch gesture.state {
        case .began:
            handleBeganGestureState(in: gesture, for: sticker)
        case .changed:
            guard var initial = initialTransform else { return }
            gestures.forEach({ gesture in
                initial = transformUsingRecognizer(gesture, transform: initial)
            })
            sticker.transform = initial
        case .ended:
            handleEndedGestureState(in: gesture, for: sticker)
        default:
            break
        }
    }
    
    private func handleBeganGestureState(in gesture: UIGestureRecognizer, for sticker: FLAnimatedImageView) {
        for stickerItem in stickers where stickerItem != sticker {
            stickerItem.alpha = stickerInactiveAlpha
        }
        if gestures.isEmpty {
            initialTransform = sticker.transform
        }
        gestures.insert(gesture)
        guard gesture is UIPanGestureRecognizer else { return }
        dragToDeleteView.isHidden = false
    }
    
    private func handleEndedGestureState(in gesture: UIGestureRecognizer, for sticker: FLAnimatedImageView) {
        for stickerItem in stickers where stickerItem != sticker {
            stickerItem.alpha = stickerDefaultAplha
        }
        gestures.remove(gesture)
        guard let panGesture = gesture as? UIPanGestureRecognizer else { return }
        let location = panGesture.location(in: containerView)
        if dragToDeleteView.frame.contains(location) {
            generateHapticFeedback()
            sticker.removeFromSuperview()
            stickers.remove(object: sticker)
        }
        dragToDeleteView.isHidden = true
    }
    
    private func transformUsingRecognizer(_ recognizer: UIGestureRecognizer, transform: CGAffineTransform) -> CGAffineTransform {
        if let rotateRecognizer = recognizer as? UIRotationGestureRecognizer {
            return transform.rotated(by: rotateRecognizer.rotation)
        }
        if let pinchRecognizer = recognizer as? UIPinchGestureRecognizer {
            return pinched(gestureRecognizer: pinchRecognizer, transform: transform)
        }
        if let panRecognizer = recognizer as? UIPanGestureRecognizer {
            panned(gestureRecognizer: panRecognizer)
        }
        return transform
    }
    
    private func panned(gestureRecognizer: UIPanGestureRecognizer) {
        let translation = gestureRecognizer.translation(in: scrollView)
        guard let gestureView = gestureRecognizer.view else { return }
        gestureView.center = CGPoint(x: gestureView.center.x + translation.x, y: gestureView.center.y + translation.y)
        gestureRecognizer.setTranslation(CGPoint.zero, in: scrollView)
    }
    
    private func pinched(gestureRecognizer: UIPinchGestureRecognizer, transform: CGAffineTransform) -> CGAffineTransform {
        return transform.scaledBy(x: gestureRecognizer.scale, y: gestureRecognizer.scale)
    }
    
    private func configureNavigationBar() {
        guard let navigationController = navigationController else { return }
        title = R.string.localizable.photoStickerPlaceSticker()
        
        navigationController.navigationBar.tintColor = UIColor.ppDarkGreenBlue
        navigationController.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.ppDarkGreenBlue]
        navigationController.navigationBar.isTranslucent = false
        
        let closeButton = UIBarButtonItem(image: R.image.close(), style: .plain, target: self, action: #selector(closeAction(_:)))
        navigationItem.leftBarButtonItem = closeButton
        navigationItem.rightBarButtonItem = shareButtonForNavigationBar()
    }

    private func configureScrollView() {
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.bounces = false
    }
    
    private func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(UINib(resource: R.nib.stickerLargeCell),
                                forCellWithReuseIdentifier: R.reuseIdentifier.stikerLargeCell.identifier)
    }
    
    private func configureFlowLayout() {
        let itemWidth = collectionView.frame.size.height
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        collectionView.collectionViewLayout = flowLayout
    }
    
    private func shareButtonForNavigationBar() -> UIBarButtonItem {
        let button = UIButton(type: .custom)
        button.setImage(R.image.share(), for: .normal)
        button.setImage(R.image.share()!.alpha(semiOpacity), for: .highlighted)
        button.setTitle(R.string.localizable.share(), for: .normal)
        button.addTarget(self, action: #selector(shareAction(_:)), for: .touchUpInside)
        button.backgroundColor = .clear
        button.setTitleColor(UIColor.ppDarkGreenBlue, for: .normal)
        button.setTitleColor(.ppDarkGreenBlueHighlighted, for: .highlighted)
        button.contentEdgeInsets = shareButtonContentInsets
        button.imageEdgeInsets = shareButtonImageInsets
        button.titleEdgeInsets = shareButtonTitleInsets
        return UIBarButtonItem(customView: button)
    }
    
    // MARK: - Actions
    
    @objc private func shareAction(_ sender: UIBarButtonItem) {
        let image = UIImage.image(from: containerView, without: collectionView)
        let imageToShare = [image.trim()]
        let activityViewController = UIActivityViewController(activityItems: imageToShare, applicationActivities: nil)
        logStandardShare()
        AnalyticsService.log(.photoShare)
        present(activityViewController, animated: true, completion: nil)
    }

    private func logStandardShare() {
        guard let platformController = PlatformViewController.get() else { return }
        guard let pack = platformController.tabBarItems[platformController.selectedIndex].pack else { return }
        guard let packName = pack.name else { return }
        for stickerImage in stickers {
            guard let sticker = addedStickers[stickerImage] else { continue }
            guard let imageExtension = sticker.filenameBinded.absoluteString.components(separatedBy: ".").last else { continue }
             guard let stickerType = AnalyticEventType.StickerType(rawValue: imageExtension) else { continue }
            AnalyticsService.log(.standardShare(packName: packName, packSize: pack.quantity, stickerNumber: sticker.position, stickerType: stickerType))
        }
    }
    
    @objc private func closeAction(_ sender: UIBarButtonItem) {
        showDismissAlert()
    }
    
    private func showDismissAlert() {
        showMessage(R.string.localizable.errorDismissStickerPhotoMessage(), title: R.string.localizable.errorDismissStickerPhotoTitle(), dismissTitle: R.string.localizable.dismiss(), dismissBlock: { [weak self] in
            guard let strongSelf = self else { return }
            guard let navigationController = strongSelf.navigationController else { return }
            PlatformViewController.get()?.childControllerType = .main
            navigationController.popViewController(animated: true)
        })
    }

}

extension StickerPhotoViewController: StickerPackSelectionProtocol {
    
    func selectStickerPackWith(id: Int32?) {
        guard let id = id else {
            showDismissAlert()
            return
        }
        let fetchRequest = frc.fetchRequest
        fetchRequest.predicate = NSPredicate(format: "stickerpackID = %i", id)
        do {
            try frc.performFetch()
        } catch {
            print(error.localizedDescription)
        }
        collectionView.reloadData()
    }
    
}

extension StickerPhotoViewController: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
}
