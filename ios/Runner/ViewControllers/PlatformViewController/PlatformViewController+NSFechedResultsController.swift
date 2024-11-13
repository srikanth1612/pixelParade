//
//  PlatformViewController+NSFechedResultsController.swift
//  Pixel-parade
//
//  Created by Vladimir Vishnyagov on 09/10/2017.
//  Copyright © 2017 Live Typing. All rights reserved.
//

import Foundation
import CoreData

extension PlatformViewController: NSFetchedResultsControllerDelegate {
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.reloadTabBar()
    }
    
}
