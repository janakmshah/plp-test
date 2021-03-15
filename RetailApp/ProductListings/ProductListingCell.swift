//
//  ProductListingCell.swift
//  RetailApp
//
//  Created by Janak Shah on 13/03/2021.
//  Copyright © 2021 Marks and Spencer. All rights reserved.
//

import UIKit

class ProductListingCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    private var viewModel: ProductListingViewModel?
    
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
    
    // MARK: - Bindings
    
    func update(with viewModel: ProductListingViewModel) {
        self.viewModel = viewModel
        bind()
    }
    
    private func bind() {
        viewModel?.badge.bind(self) { [weak self] value in
            guard let self = self else { return }
            guard let badgeImage = value else {
                self.badgeView.isHidden = true
                return
            }
            self.badgeView.image = badgeImage
            self.badgeView.isHidden = false
            self.badgeWidthConstraint?.constant = (self.badgeHeight / badgeImage.size.height) * badgeImage.size.width
        }
        viewModel?.image.bind(self) { [weak self] value in
            self?.imageView.image = value
        }
        viewModel?.title.bind(self) { [weak self] value in
            self?.titleLabel.text = value
        }
        viewModel?.price.bind(self) { [weak self] value in
            self?.priceLabel.attributedText = value
        }
    }
    
    func unbind() {
        viewModel?.title.unbind(self)
        viewModel?.price.unbind(self)
        viewModel?.badge.unbind(self)
        viewModel?.image.unbind(self)
    }
    
    deinit {
        unbind()
    }
    
}
