//
//  ShopViewController+UITableView.swift
//  Pixel-parade
//
//  Created by Vladimir Vishnyagov on 09/10/2017.
//  Copyright © 2017 Live Typing. All rights reserved.
//

import UIKit

extension ShopViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let sections = frcPacks.sections else {
            showPlaceholder()
            return 0
        }
        guard sections.isEmpty else { return sections.count }
        showPlaceholder()
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = frcPacks.sections, !sections.isEmpty else {
            showPlaceholder()
            return 0
        }
        if sections[section].numberOfObjects == 0 {
            showPlaceholder()
            return 0
        }
        hidePlaceholder()
        return sections[section].numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.shopCell.identifier, for: indexPath)
        cell.selectionStyle = .none
        guard let shopCell = cell as? ShopCell else { return cell }
        shopCell.fill(pack: frcPacks.object(at: indexPath))
        return shopCell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
}

extension ShopViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
}
