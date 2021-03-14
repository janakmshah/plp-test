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
        
        ProductsServiceImplementation(api: API(urlSession: URLSession(configuration: .default), baseURL: URL(string: "http://admin:password@interview-tech-testing.herokuapp.com")!)).getProducts { [weak self] (result) in
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
        cell.titleLabel.text = self.items[indexPath.row].name
        cell.priceLabel.attributedText = PriceFormatterImplementation().formatPrice(self.items[indexPath.row].price)
        cell.backgroundColor = UIColor.cyan
        
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
    
    let image = UIImageView()
    
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
        
        contentView.add(image, titleLabel, priceLabel)
        image.pinTo(top: 0, left: 0, right: 0)
        let imageHeightRatio = image.heightAnchor.constraint(equalTo: image.widthAnchor, multiplier: 1.5)
        imageHeightRatio.priority = .defaultHigh
        imageHeightRatio.isActive = true
        
        titleLabel.pinTo(left: 0, right: 0)
        titleLabel.topAnchor.constraint(equalTo: image.bottomAnchor, constant: Size.spacingSmall).isActive = true
        
        priceLabel.pinTo(bottom: 25, left: 0, right: 0)
        priceLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Size.spacingSmall).isActive = true
        
        let widthConstraint = contentView.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width / 2) - (Size.spacingSmall * 1.5))
        widthConstraint.priority = .defaultHigh
        widthConstraint.isActive = true

    }
    
}
