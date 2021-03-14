//
//  ProductListingsViewController.swift
//  RetailApp
//
//  Created by Janak Shah on 14/03/2021.
//  Copyright © 2021 Marks and Spencer. All rights reserved.
//

import UIKit

class ProductListingsViewController: UIViewController {
    
    // MARK: - Properties
    
    private let viewModel: ProductListingsViewModel
    private var products = [ProductCellDisplayable]()

    let collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumInteritemSpacing = Size.spacingRegular
        flowLayout.minimumLineSpacing = Size.spacingLarge
        return UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
    }()
    
    // MARK: - Initialisers
    
    init(_ viewModel: ProductListingsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Tops"
        self.navigationItem.largeTitleDisplayMode = .always
        self.navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = .white
        bind()
    }
    
    deinit {
        viewModel.displayProducts.unbind(self)
    }
    
    // MARK: - Helpers
    
    private func setupCollectionView() {
        view.add(collectionView)
        collectionView.pinTo(top: 0, bottom: 0, left: 0, right: 0)
        collectionView.register(ProductCell.self, forCellWithReuseIdentifier: String(describing: ProductCell.self))
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.contentInset = UIEdgeInsets(top: 0, left: Size.spacingRegular, bottom: 0, right: Size.spacingRegular)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .white
    }
    
    private func bind() {
        viewModel.displayProducts.bind(self) { [weak self] products in
            self?.products = products
            self?.collectionView.reloadData()
        }
    }
    
}

extension ProductListingsViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ProductCell.self), for: indexPath as IndexPath) as? ProductCell else { return UICollectionViewCell() }
        cell.update(with: self.products[indexPath.item])
        return cell
    }
    
}

extension ProductListingsViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.viewModel.openProductDetails(indexPath.item)
    }
    
}
