//
//  FilterListCell.swift
//  DisplayFilterUI_v2
//
//  Created by Akanksha Gupta on 27/07/21.
//

import UIKit

class FilterListCell: UICollectionViewCell {
    
    private lazy var checkMarkImageView :UIImageView = {
        let image = UIImage(named: "ic_address_checkbox_off")
        return UIImageView(image: image)
    }()
    
    private lazy var filterLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    public lazy var categoryID: String = {
        return ""
    }()
    
    public lazy var filterID: String = {
        return ""
    }()
    
    override var isSelected: Bool {
        didSet {
            if(isSelected == true) {
                self.checkMarkImageView.image = UIImage(named: "ic_address_checkbox_on")
            } else {
                self.checkMarkImageView.image = UIImage(named: "ic_address_checkbox_off")
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension FilterListCell {
    
    private func setupViews() {
        
        addSubview(checkMarkImageView)
        checkMarkImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            checkMarkImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            checkMarkImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            checkMarkImageView.widthAnchor.constraint(equalToConstant: 24),
            checkMarkImageView.heightAnchor.constraint(equalToConstant: 24)
        ])
        
        addSubview(filterLabel)
        NSLayoutConstraint.activate([
            filterLabel.leadingAnchor.constraint(equalTo: checkMarkImageView.trailingAnchor, constant: 8),
            filterLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    public func configure(filterName: String, isSelected: Bool = false) {
        filterLabel.text = filterName
        if isSelected {
            checkMarkImageView.image = UIImage(named: "ic_address_checkbox_on")
        } else {
            checkMarkImageView.image = UIImage(named: "ic_address_checkbox_off")
        }
    }
    
}
