//
//  StickerPackViewController.swift
//  pixelparadeiMessage
//
//  Created by Chethan Jayaram on 12/11/24.
//

import UIKit



protocol StickerPackViewControllerDelegate: AnyObject {
    func didSelectSticker(filename: String)
}

class StickerPackViewController: UIViewController {

    
    @IBOutlet var collectionView: UICollectionView!
    
    
    weak var delegate: StickerPackViewControllerDelegate?
    var pack:Array<Dictionary<String,Any>>!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configureCollectionView()
        
        print(pack)
    }
    


    
    func configureCollectionView() {
        let itemWidth = (Screen.width - 5.0) / 3.0
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 2.5, bottom: 20, right: 2.5)
        flowLayout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        flowLayout.minimumLineSpacing = 0.0
        flowLayout.minimumInteritemSpacing = 0.0

        collectionView.collectionViewLayout = flowLayout
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(UINib(nibName: "StickerViewInMsg", bundle: nil),
                                forCellWithReuseIdentifier: "StickerViewInMsg")
//        collectionView.register(UINib(resource: R.nib.stikerPackHeader), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: R.reuseIdentifier.stickerPackHeader.identifier)
    }
}


extension StickerPackViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        /*guard let sections = fetchedResultC*/ontroller.sections else { return 0 }
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        guard let sections = fetchedResultController.sections, !sections.isEmpty else { return 0 }
        
        return pack.count
    }
    
  
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StickerViewInMsg", for: indexPath) as! StickerViewInMsg
        
        cell.fill(sticker: (pack[indexPath.row]["filename"] as? String) ?? "")
        
        return cell
    }


    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        print(cell.bounds)
    }
    
}

extension StickerPackViewController: UICollectionViewDelegateFlowLayout {

    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
     
//            let sticker = fetchedResultController.object(at: indexPath)
//            if let delegate = delegate {
//                guard let fileCachedPath = SDImageCache.shared().defaultCachePath(forKey: sticker.filenameBinded.absoluteString) else { return }
//                delegate.didSelectSticker(filename: fileCachedPath)
//            }
     
    }
    
}
