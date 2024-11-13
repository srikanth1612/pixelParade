//
//  SearchTagCell.swift
//  Pixel-parade
//
//  Created by Mikhail Muzhev on 31/07/2019.
//  Copyright © 2019 Live Typing. All rights reserved.
//

import UIKit

class SearchTagCell: UICollectionViewCell {

    static var reuseIdentifier: String = "SearchTagCell"

    // MARK: - Views

    lazy private var roundedBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .ppAquaBlue2
        view.layer.cornerRadius = 5
        return view
    }()

    lazy private var titleLabel: UILabel = {
        let label = UILabel()
        return label
    }()

    // MARK: - Lifecycle

    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        commonInit()
    }

    private func commonInit() {
        roundedBackgroundView.addSubview(titleLabel)
        addSubview(roundedBackgroundView)
        configureConstraints()
    }

    private func configureConstraints() {
        roundedBackgroundView.snp.makeConstraints { (make) in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
        titleLabel.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(8)
            make.trailing.equalToSuperview().offset(-8)
            make.top.equalToSuperview().offset(4)
            make.bottom.equalToSuperview().offset(-4)
        }
    }

    // MARK: - Setters

    func fill(with text: String) {
        titleLabel.attributedText = NSAttributedString(string: text,
                                                       style: .text(.button(.darkGreenBlue)))
    }

}
