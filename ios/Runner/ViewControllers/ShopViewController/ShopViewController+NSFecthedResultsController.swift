//
//  ShopViewController+NSFecthedResultsController.swift
//  Pixel-parade
//
//  Created by Vladimir Vishnyagov on 09/10/2017.
//  Copyright © 2017 Live Typing. All rights reserved.
//

import Foundation
import CoreData

extension ShopViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            tableView.insertSections([sectionIndex], with: .automatic)
        case .delete:
            tableView.deleteSections([sectionIndex], with: .automatic)
        default:
            break
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            guard let indexPath = newIndexPath else { return }
            tableView.insertRows(at: [indexPath], with: .automatic)
        case .update:
            updateRow(at: indexPath)
        case .move:
            moveRow(from: indexPath, to: newIndexPath)
        case .delete:
            guard let indexPath = indexPath else { return }
            tableView.deleteRows(at: [indexPath], with: .automatic)
        @unknown default:
            print("unknown behaviour!")
        }
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }

    private func updateRow(at indexPath: IndexPath?) {
        guard let indexPath = indexPath else { return }
        let pack = frcPacks.object(at: indexPath)
        guard let cell = tableView.cellForRow(at: indexPath) as? ShopCell else { return }
        cell.fill(pack: pack)
    }

    private func moveRow(from indexPath: IndexPath?, to newIndexPath: IndexPath?) {
        if let indexPath = indexPath {
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        if let newIndexPath = newIndexPath {
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        }
    }
    
}
