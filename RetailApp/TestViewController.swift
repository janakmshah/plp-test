//
//  TestViewController.swift
//  RetailApp
//
//  Created by Janak Shah on 13/03/2021.
//  Copyright © 2021 Marks and Spencer. All rights reserved.
//

import UIKit

class TestViewController: UIViewController {
    
    var items = [ProductDetailsBasic]()
    let collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumInteritemSpacing = Size.spacingSmall
        flowLayout.minimumLineSpacing = Size.spacingSmall
        
        return UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Tops"
        self.navigationItem.largeTitleDisplayMode = .always
        self.navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = .white
        
        view.add(collectionView)
        collectionView.pinTo(top: 0, bottom: 0, left: 0, right: 0)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.contentInset = UIEdgeInsets(top: 0, left: Size.spacingSmall, bottom: 0, right: Size.spacingSmall)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .white
        
        collectionView.register(ProductCell.self, forCellWithReuseIdentifier: String(describing: ProductCell.self))
        
        ProductsServiceImplementation(api: API(urlSession: URLSession(configuration: .default), baseURL: URL(string: "http://interview-tech-testing.herokuapp.com")!)).getProducts { [weak self] (result) in
            switch result {
            case .value(let products):
                self?.items = products.products
                self?.collectionView.reloadData()
            case .error(let error):
                fatalError(error.localizedDescription)
            }
        }
        
    }
    
}

extension TestViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ProductCell.self), for: indexPath as IndexPath) as? ProductCell else { return UICollectionViewCell() }
        cell.update(with: self.items[indexPath.row])
        
        return cell
    }
    
}

extension TestViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("You selected cell #\(indexPath.item)!")
    }
    
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
        let imageHeightRatio = imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 1.5)
        imageHeightRatio.priority = UILayoutPriority(999)
        imageHeightRatio.isActive = true
        
        titleLabel.pinTo(left: 0, right: 0)
        titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: Size.spacingSmall).isActive = true
        
        priceLabel.pinTo(bottom: 25, left: 0, right: 0)
        priceLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Size.spacingSmall).isActive = true
        
        let widthConstraint = contentView.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width / 2) - (Size.spacingSmall * 1.5))
        widthConstraint.priority = UILayoutPriority(999)
        widthConstraint.isActive = true
        
    }
    
    func update(with productDetails: ProductDetailsBasic) {
        titleLabel.text = productDetails.name
        priceLabel.attributedText = PriceFormatterImplementation().formatPrice(productDetails.price)
        backgroundColor = UIColor.cyan
        
        // First check cache
        if let cachedImage = ImageCache.fetch(for: productDetails.imageKey) {
            imageView.image = cachedImage
            return
        }
        
        // If nothing in cache, load from remote
        imageView.image = UIImage(named: "Placeholder")
        ImageServiceImplementation(api: API(urlSession: URLSession(configuration: .default), baseURL: URL(string: "http://interview-tech-testing.herokuapp.com")!)).downloadImage(key: productDetails.imageKey) { [weak self] (result) in
            switch result {
            case .value(let downloadedImage):
                self?.imageView.image = downloadedImage
                ImageCache.cache(downloadedImage, for: productDetails.imageKey) // Save to cache
            case .error(let error):
                self?.imageView.image = UIImage(named: "Placeholder")
                print(error)
            }
        }
    }
    
}
