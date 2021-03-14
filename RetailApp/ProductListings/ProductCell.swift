//
//  ProductCell.swift
//  RetailApp
//
//  Created by Janak Shah on 13/03/2021.
//  Copyright © 2021 Marks and Spencer. All rights reserved.
//

import UIKit

//TODO: Move to ViewModel
protocol ProductCellDisplayable {
    var title: String { get }
    var imageKey: String { get }
    var price: NSAttributedString { get }
    var badgeKey: String? { get }
}

struct ProductCellDisplayableImplementation: ProductCellDisplayable {
    let title: String
    let imageKey: String
    let price: NSAttributedString
    let badgeKey: String?
}

class ProductCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    let badgeHeight: CGFloat = 26
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 15)
        return label
    }()
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let badgeView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let priceLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 15)
        return label
    }()
    
    var badgeWidthConstraint: NSLayoutConstraint?
    
    // MARK: - Initialisers
    
    override init(frame: CGRect) {
        super.init(frame: CGRect.zero)
        setInitialLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layout
    
    func setInitialLayout() {
        
        contentView.add(imageView, titleLabel, priceLabel, badgeView)
        imageView.pinTo(top: 0, left: 0, right: 0)
        let imageHeightRatio = imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 1.3)
        imageHeightRatio.priority = UILayoutPriority(999)
        imageHeightRatio.isActive = true
        
        titleLabel.pinTo(left: 0, right: 0)
        titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: Size.spacingRegular).isActive = true
        
        priceLabel.pinTo(bottom: 0, left: 0, right: 0)
        priceLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Size.spacingRegular).isActive = true
        
        badgeView.pinTo(top: Size.spacingExtraSmall, right: Size.spacingExtraSmall)
        badgeView.pinHeight(badgeHeight)
        badgeWidthConstraint = badgeView.widthAnchor.constraint(equalToConstant: 0)
        badgeWidthConstraint?.isActive = true
        
        let widthConstraint = contentView.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width / 2) - (Size.spacingRegular * 1.5))
        widthConstraint.priority = UILayoutPriority(999)
        widthConstraint.isActive = true
        
    }
    
    // MARK: - Update view
    
    func update(with productDetails: ProductCellDisplayable) {
        titleLabel.text = productDetails.title
        priceLabel.attributedText = productDetails.price
        
        //TODO: API calls should be in a ViewModel
        imageView.image = UIImage(named: "Placeholder")
        ImageServiceImplementation(api: API.defaultAPI).downloadImage(key: productDetails.imageKey) { [weak self] (result) in
            switch result {
            case .value(let downloadedImage):
                self?.imageView.image = downloadedImage
            case .error:
                self?.imageView.image = UIImage(named: "Placeholder")
            }
        }
                
        badgeView.isHidden = true
        
        guard let badgeKey = productDetails.badgeKey else { return }
        
        ImageServiceImplementation(api: API.defaultAPI).downloadImage(key: badgeKey + "_icon") { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .value(let downloadedImage):
                self.badgeView.image = downloadedImage
                self.badgeWidthConstraint?.constant = (self.badgeHeight / downloadedImage.size.height) * downloadedImage.size.width
                self.badgeView.isHidden = false
            case .error:
                self.badgeView.isHidden = true
            }
        }
    }
    
}
