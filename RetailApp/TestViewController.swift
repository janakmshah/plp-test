//
//  TestViewController.swift
//  RetailApp
//
//  Created by Janak Shah on 13/03/2021.
//  Copyright © 2021 Marks and Spencer. All rights reserved.
//

import UIKit

class TestViewController: UIViewController {
    
    var items = ["1", "2 long string should go multiline hopefully yes please", "3", "4", "5", "6", "7", "8", "9", "10 long string should go multiline hopefully yes please", "11", "12", "13", "14", "15 long string should go multiline hopefully yes please", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "31", "32 long string should go multiline hopefully yes please", "33", "34", "35", "36", "37", "38", "39", "40", "41", "42", "43", "44", "45", "46", "47", "48"]
        
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        ProductsServiceImplementation(api: API(urlSession: URLSession(configuration: .default), baseURL: URL(string: "http://admin:password@interview-tech-testing.herokuapp.com")!)).getProducts { (result) in
            switch result {
            case .value(let products):
                //print(products)
            break
            case .error(let error):
                fatalError(error.localizedDescription)
            }
        }
                
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumInteritemSpacing = Size.spacingSmall
        flowLayout.minimumLineSpacing = Size.spacingSmall
        
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
                
        view.add(collectionView)
        collectionView.pinTo(top: 0, bottom: 0, left: 0, right: 0)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.contentInset = UIEdgeInsets(top: 0, left: Size.spacingSmall, bottom: 0, right: Size.spacingSmall)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .white
        
        collectionView.register(ProductCell.self, forCellWithReuseIdentifier: String(describing: ProductCell.self))
        
    }

}

extension TestViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ProductCell.self), for: indexPath as IndexPath) as? ProductCell else { return UICollectionViewCell() }
        cell.titleLabel.text = self.items[indexPath.row]
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
    
    let titleLabel = UILabel()
    
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
        self.contentView.add(self.titleLabel)
        self.titleLabel.pinTo(top: 0, bottom: 0, left: 0, right: 0)
        self.titleLabel.numberOfLines = 0
        self.titleLabel.pinWidth((UIScreen.main.bounds.width / 2) - (Size.spacingSmall*1.5))
    }
    
}
