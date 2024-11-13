//
//  StickerPackViewController.swift
//  Pixel-parade
//
//  Created by Vladimir Vishnyagov on 04/10/2017.
//  Copyright © 2017 Live Typing. All rights reserved.
//

import UIKit
import CoreData

protocol StickerPackViewControllerDelegate: class {
    func didSelectSticker(filename: String)
}

final class StickerPackViewController: UIViewController {
    
    @IBOutlet var collectionView: UICollectionView!
    
    var pack: Pack!
    var frc: NSFetchedResultsController <StickerFull>?
    var blockOperations: [BlockOperation] = []
    var shouldReloadCollectionView: Bool = false
    
    weak var delegate: StickerPackViewControllerDelegate?
    
    var fetchedResultController: NSFetchedResultsController<StickerFull> {
        guard frc == nil else { return frc! }
        
        let fetchRequest: NSFetchRequest<StickerFull> = StickerFull.fetchRequest()
        let managedObjectContext = StorageService.shared.dataStack.viewContext
        
        fetchRequest.predicate = NSPredicate(format: "stickerpackID = %i", pack.id)
        
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "position", ascending: true)]
        let resultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        
        resultsController.delegate = self
        frc = resultsController
        
        do {
            try frc!.performFetch()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror)")
        }
        return frc!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let navigationController = navigationController {
            navigationController.setNavigationBarHidden(true, animated: false)
        }
        configureCollectionView()
        
        do {
            try fetchedResultController.performFetch()
        } catch {
            print(error)
        }
        
        PackManager.getPack(id: pack.id, completion: {})
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
        collectionView.register(UINib(resource: R.nib.stickerLargeCell),
                                forCellWithReuseIdentifier: R.reuseIdentifier.stikerLargeCell.identifier)
        collectionView.register(UINib(resource: R.nib.stikerPackHeader), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: R.reuseIdentifier.stickerPackHeader.identifier)
    }

}
