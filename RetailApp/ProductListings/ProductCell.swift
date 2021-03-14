//
//  ProductCell.swift
//  RetailApp
//
//  Created by Janak Shah on 13/03/2021.
//  Copyright © 2021 Marks and Spencer. All rights reserved.
//

import UIKit

protocol ProductCellDisplayable {
    var title: String { get }
    var imageKey: String { get }
    var price: NSAttributedString { get }
}

struct ProductCellDisplayableImplementation: ProductCellDisplayable {
    let title: String
    let imageKey: String
    let price: NSAttributedString
}

class ProductCell: UICollectionViewCell {
    
    // MARK: - Properties
    
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
    
    let priceLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 15)
        return label
    }()
    
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
        
        contentView.add(imageView, titleLabel, priceLabel)
        imageView.pinTo(top: 0, left: 0, right: 0)
        let imageHeightRatio = imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 1.3)
        imageHeightRatio.priority = UILayoutPriority(999)
        imageHeightRatio.isActive = true
        
        titleLabel.pinTo(left: 0, right: 0)
        titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: Size.spacingRegular).isActive = true
        
        priceLabel.pinTo(bottom: 0, left: 0, right: 0)
        priceLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Size.spacingRegular).isActive = true
        
        let widthConstraint = contentView.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width / 2) - (Size.spacingRegular * 1.5))
        widthConstraint.priority = UILayoutPriority(999)
        widthConstraint.isActive = true
        
    }
    
    func update(with productDetails: ProductCellDisplayable) {
        titleLabel.text = productDetails.title
        priceLabel.attributedText = productDetails.price
        
        imageView.image = UIImage(named: "Placeholder")
        ImageServiceImplementation(api: API(urlSession: URLSession(configuration: .default), baseURL: URL(string: "http://interview-tech-testing.herokuapp.com")!)).downloadImage(key: productDetails.imageKey) { [weak self] (result) in
            switch result {
            case .value(let downloadedImage):
                self?.imageView.image = downloadedImage
            case .error(let error):
                self?.imageView.image = UIImage(named: "Placeholder")
                print(error)
            }
        }
    }
    
}
