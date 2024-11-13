//
//  ShopViewController.swift
//  Pixel-parade
//
//  Created by Vladimir Vishnyagov on 04/10/2017.
//  Copyright © 2017 Live Typing. All rights reserved.
//

import UIKit
import MBProgressHUD
import CoreData
import FLAnimatedImage
import SDWebImage
import SnapKit

protocol ShopHeaderCameraDelegate: class {
    func openCamera()
    func searchDidPressed()
}

enum ShopScreenState {
    case `default`
    case searching
}

class ShopViewController: BaseViewController {
    
    private struct Constants {
        static let imageRatio = 640 / 190
    }
    
    // MARK: - Views

    lazy var bannerButton: UIButton = {
        let button = UIButton(type: .custom)
        button.addTarget(self, action: #selector(clickOnBanner), for: .touchUpInside)
        
        return button
    }()
    
    lazy var bannerImageView: FLAnimatedImageView = {
        let imageView = FLAnimatedImageView()
        imageView.isUserInteractionEnabled = false
        imageView.contentMode = .scaleToFill
        
        return imageView
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()

    lazy var tagsCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .white
        return collectionView
    }()

    private lazy var collectionViewLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = CGSize(width: 50, height: 24)
        layout.scrollDirection = .horizontal
        return layout
    }()

    private lazy var collectionViewBackground: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()

    lazy var rightTagsShadowView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()

    lazy var leftTagsShadowView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()

    @IBOutlet private var backgroundView: ShopPlaceholderFooter!

    var tags: [String] = [] {
        didSet {
            runThisInMainThread { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.tagsCollectionView.reloadData()
            }
        }
    }

    private var timer: Timer?
    private var screenState: ShopScreenState = .default {
        didSet {
            backgroundView.set(state: self.screenState)
        }
    }
    weak var hud: MBProgressHUD?
    lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.returnKeyType = .search
        searchBar.showsCancelButton = true
        searchBar.delegate = self
        searchBar.tintColor = .ppDarkGreenBlue
        return searchBar
    } ()

    lazy private var shopHeader: ShopHeader = {
        guard let header = R.nib.shopHeader.firstView(owner: self) else { return ShopHeader() }
        header.delegate = self
        header.snp.makeConstraints { (make) in
            make.width.equalTo(Screen.width)
        }
        return header
    } ()
    
    lazy var frcPacks: NSFetchedResultsController <Pack> = {
        let fr = NSFetchRequest<Pack>(entityName: NSStringFromClass(Pack.self))
        fr.predicate = NSPredicate(format: "isPurchased = false")
        let alphabetSortDescriptor = NSSortDescriptor(key: "position",
                                                  ascending: true)
        fr.sortDescriptors = [alphabetSortDescriptor]
        let frc = NSFetchedResultsController(fetchRequest: fr,
                                             managedObjectContext: StorageService.shared.dataStack.viewContext,
                                             sectionNameKeyPath: nil,
                                             cacheName: nil)
        frc.delegate = self
        return frc
    } ()
    
    // MARK: - ViewController life-cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        loadPacks()
        reloadTable()
        fetchBanner()
    }
    
    // MARK: - UI settings

    private func setupUI() {
        bannerButton.addSubview(bannerImageView)
        collectionViewBackground.addSubviews([tagsCollectionView, rightTagsShadowView, leftTagsShadowView])
        view.addSubviews([collectionViewBackground, tableView])
        configureBackgroundView()
        configureTableView()
        configureCollectionView()
        configureNavigationBar(dependOn: screenState)
        configureConstraints()
    }

    private func configureConstraints() {
        collectionViewBackground.snp.makeConstraints { (make) in
            if #available(iOS 11.0, *) {
                make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            } else {
                make.top.leading.trailing.equalToSuperview()
            }
        }
        
        bannerImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        tagsCollectionView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(50)
        }
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(collectionViewBackground.snp.bottom)
            if #available(iOS 11.0, *) {
                make.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
            } else {
                make.leading.trailing.bottom.equalToSuperview()
            }
        }
        searchBar.snp.makeConstraints { (make) in
            make.height.equalTo(44)
        }
        rightTagsShadowView.snp.makeConstraints { (make) in
            make.height.width.equalTo(40)
            make.trailing.equalToSuperview()
            make.centerY.equalTo(tagsCollectionView.snp.top)
        }
        leftTagsShadowView.snp.makeConstraints { (make) in
            make.height.width.equalTo(40)
            make.leading.equalToSuperview()
            make.centerY.equalTo(tagsCollectionView.snp.top)
        }
    }

    private func configureBackgroundView() {
        backgroundView = ShopPlaceholderFooter.viewFromNib()
        backgroundView.isHidden = true
    }

    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = TableView.estimatedRowHeight
        tableView.rowHeight = UITableView.automaticDimension
        tableView.backgroundView = UIView()
        tableView.backgroundView?.addSubview(backgroundView)
        tableView.register(UINib(resource: R.nib.shopCell),
                           forCellReuseIdentifier: R.reuseIdentifier.shopCell.identifier)
        tableView.register(UINib(resource: R.nib.shopPlaceholderFooter), forHeaderFooterViewReuseIdentifier: NSStringFromClass(ShopPlaceholderFooter.self))
    }

    private func configureCollectionView() {
        tagsCollectionView.register(SearchTagCell.self, forCellWithReuseIdentifier: SearchTagCell.reuseIdentifier)
        tagsCollectionView.dataSource = self
        tagsCollectionView.delegate = self
        tagsCollectionView.reloadData()
    }

    private func enableSearchBarCancelButton() {
        let subviews = searchBar.subviews.first?.subviews ?? []
        for case let button as UIButton in subviews {
            button.isEnabled = true
        }
    }
    
    class SearchBarContainerView: UIView {
      let searchBar: UISearchBar
      init(customSearchBar: UISearchBar) {
        searchBar = customSearchBar
        super.init(frame: CGRect.zero)

        addSubview(searchBar)
      }

      override convenience init(frame: CGRect) {
        self.init(customSearchBar: UISearchBar())
        self.frame = frame
      }

      required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
      }

      override func layoutSubviews() {
        super.layoutSubviews()
        searchBar.frame = bounds
      }
    }

    private func configureNavigationBar(dependOn state: ShopScreenState) {
        let view: UIView
        let navigationBackgroundColor: UIColor
        switch state {
        case .default:
            view = shopHeader
            navigationBackgroundColor = .white
            navigationController?.navigationBar.barTintColor = navigationBackgroundColor
            navigationItem.titleView = view
        case .searching:
            
            let searchBar = searchBar
               let searchBarContainer = SearchBarContainerView(customSearchBar: searchBar)
            searchBarContainer.frame = CGRect(x: 0, y: 0, width: Screen.width, height: 44)
               navigationItem.titleView = searchBarContainer
            navigationBackgroundColor = .ppLightCyan
            searchBar.becomeFirstResponder()
            navigationController?.navigationBar.barTintColor = navigationBackgroundColor
            enableSearchBarCancelButton()
        }
    }

    // MARK: - Keyboard

    override func keyboardTransitionAnimation(_ state: KeyboardState) {
        switch state {
        case .activeWithHeight(var height):
            if let bottomBarHeight = tabBarController?.tabBar.frame.height {
                height -= bottomBarHeight
            }
            tableView.snp.updateConstraints { (make) in
                if #available(iOS 11.0, *) {
                    make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-height)
                } else {
                    make.bottom.equalToSuperview().offset(-height)
                }
            }
        case .hidden:
            tableView.snp.updateConstraints { (make) in
                if #available(iOS 11.0, *) {
                    make.bottom.equalTo(view.safeAreaLayoutGuide)
                } else {
                    make.bottom.equalToSuperview()
                }
            }
        }
        view.layoutIfNeeded()
    }
    
    // MARK: - Fetching
    
    private func loadPacks() {
        guard StorageService.shared.getAccessToken() == nil else {
            fetchPacks()
            return
        }
        
        showStickersLoader()
        
        UserManager.createToken(completion: { [weak self] in
            guard let self = self else { return }
            self.fetchPacks()
            self.fetchTags()
        })
    }
    
    private func fetchPacks() {
        PackManager.getPacks { [weak self] isLastPage in
            guard isLastPage else {
                self?.fetchPacks()
                return
            }
            
            self?.hideStickersLoader()
        }
    }
    
    func showStickersLoader() {
        hideStickersLoader()
        DispatchQueue.main.async {
            self.hud = MBProgressHUD.showAdded(to: self.view, animated: true)
            guard let hud = self.hud else { return }
            
            hud.label.text = "Loading stickers, \nplease wait"
            hud.label.numberOfLines = 0
        }
    }
    
    func hideStickersLoader() {
        DispatchQueue.main.async {
            self.hud?.hide(animated: true)
            self.hud = nil
        }
    }

    private func fetchTags() {
        SearchService.fetchTags(success: { [weak self] (tags) in
            guard let strongSelf = self else { return }
            strongSelf.tags = tags
        }, failure: { (error) in
            print(error.localizedDescription)
        })
    }
    
    // MARK: - UI actions

    func showPlaceholder() {
        guard hud == nil else { return }
        backgroundView.isHidden = false
        tableView.isScrollEnabled = false
    }
    
    func hidePlaceholder() {
        backgroundView.isHidden = true
        tableView.isScrollEnabled = true
    }

    func reloadTable() {
        do {
            try self.frcPacks.performFetch()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func showScreen(forType type: UIImagePickerController.SourceType) {
        let cameraViewController = UIImagePickerController()
        cameraViewController.sourceType = type
        if type == .camera {
            cameraViewController.cameraFlashMode = .auto
        }
        cameraViewController.delegate = self
        present(cameraViewController, animated: true, completion: nil)
    }
    
    private func navigateToEditPhotoScreen(withImage image: UIImage) {
        guard let navigationController = navigationController else { return }
        guard let photoViewController = R.storyboard.stickerPhoto().instantiateInitialViewController() as? StickerPhotoViewController else { return }
        photoViewController.setSelectedImage(image)
        let platform = PlatformViewController.get()
        platform?.childControllerType = .photo
        photoViewController.tabBarDelegate = platform
        navigationController.pushViewController(photoViewController, animated: true)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        leftTagsShadowView.applyGradient(colors: [.white, UIColor.white.withAlphaComponent(0)], locations: nil, startPoint: .zero, endPoint: CGPoint(x: 1, y: 0))
        rightTagsShadowView.applyGradient(colors: [UIColor.white.withAlphaComponent(0), .white], locations: nil, startPoint: .zero, endPoint: CGPoint(x: 1, y: 0))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        fetchTags()
    }
    
}

// MARK: - Banner

extension ShopViewController {
    @objc private func clickOnBanner() {
        guard let banner = UserDefaults.standard.banner,
              let url = URL(string: banner.link)
        else { return }
        
        UIApplication.shared.open(url, options: [:])
    }
    
    func fetchBanner() {
        BannerManager.updateBanner { [weak self] in
            let imageURL = UserDefaults.standard.banner?.imageURL
            self?.bannerImageView.sd_setImage(with: imageURL)
            
            DispatchQueue.main.async {
                self?.updateBannerConstraints()
            }
        }
    }
    
    func updateBannerConstraints() {
        let height: CGFloat = UserDefaults.standard.banner == nil ? .zero :
            tableView.frame.width / CGFloat(Constants.imageRatio)
        bannerButton.frame.size.height = height
        bannerButton.frame.size.width = tableView.frame.width
        tableView.tableHeaderView = bannerButton
        
        backgroundView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(bannerButton.frame.height / 2)
            $0.leading.trailing.equalToSuperview()
        }
    }
}

// MARK: - ShopHeaderCameraDelegate

extension ShopViewController: ShopHeaderCameraDelegate {
    
    func openCamera() {
        AnalyticsService.log(.photoFeature)
        let haveStickerPacks = !PackStorage.getPacks(context: StorageService.shared.dataStack.viewContext, isPurchased: true).isEmpty
        guard haveStickerPacks else {
            showMessage(R.string.localizable.errorNoStickerPacksTitle(), message: R.string.localizable.errorNoStickerPacksMessage())
            return
        }
        let alertController = CameraService.actionSheetSourceSelection(cameraAction: { [weak self] in
            guard let strongSelf = self else { return }
            CameraService.checkCameraAuthorization({ granted in
                runThisInMainThread {
                    guard granted else {
                        strongSelf.present(CameraService.settingsPopup(forType: .camera), animated: true, completion: nil)
                        return
                    }
                    strongSelf.showScreen(forType: .camera)
                }
            })
        }, libraryAction: { [weak self] in
            guard let strongSelf = self else { return }
            CameraService.checkPhotoLibraryAuthorization({ granted in
                runThisInMainThread {
                    guard granted else {
                        strongSelf.present(CameraService.settingsPopup(forType: .photoLibrary), animated: true, completion: nil)
                        return
                    }
                    strongSelf.showScreen(forType: .photoLibrary)
                }
            })
        })
        present(alertController, animated: true, completion: nil)
        
    }

    func searchDidPressed() {
        screenState = .searching
        configureNavigationBar(dependOn: screenState)
        AnalyticsService.log(.searchFeature)
    }
    
}

// MARK: - UIImagePickerControllerDelegate & UINavigationControllerDelegate

extension ShopViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let image = info[.originalImage] as? UIImage else { return }
        navigateToEditPhotoScreen(withImage: image)
        picker.dismiss(animated: false)
    }
    
}

// MARK: - UISearchBarDelegate

extension ShopViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        fetch(with: predicate(for: searchText))
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (_) in
            AnalyticsService.log(.searchResults(input: searchText))
        })
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        screenState = .default
        searchBar.text = ""
        configureNavigationBar(dependOn: screenState)
        fetch(with: defaultPredicate())
    }

    private func fetch(with predicate: NSPredicate) {
        frcPacks.fetchRequest.predicate = predicate
        do {
            try frcPacks.performFetch()
        } catch let error {
            print(error)
        }
        tableView.reloadData()
        tableView.scrollToTop()
    }

    private func predicate(for searchText: String) -> NSPredicate {
        let formattedSearchText = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !formattedSearchText.isEmpty else { return defaultPredicate() }
        let searchPredicate = NSPredicate(format: "name CONTAINS[cd] %@ OR descriptionText CONTAINS[cd] %@", formattedSearchText, formattedSearchText)
        return NSCompoundPredicate(andPredicateWithSubpredicates: [defaultPredicate(), searchPredicate])
    }

    private func defaultPredicate() -> NSPredicate {
        return NSPredicate(format: "isPurchased = false")
    }

}
