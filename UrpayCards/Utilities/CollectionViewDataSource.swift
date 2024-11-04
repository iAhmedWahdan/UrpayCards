//
//  CollectionViewDataSource.swift
//  UrpayCards
//
//  Created by Ahmed Wahdan on 08/10/2024.
//

import UIKit

class CollectionViewDataSource<Model, Cell: UICollectionViewCell>: NSObject, UICollectionViewDataSource {
    var models: [Model]
    let configureCell: (Cell, Model) -> Void
    
    init(models: [Model], configureCell: @escaping (Cell, Model) -> Void) {
        self.models = models
        self.configureCell = configureCell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return models.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cell.className, for: indexPath) as! Cell
        let model = models[indexPath.row]
        configureCell(cell, model)
        return cell
    }
}

extension UICollectionView {
    func register<Cell: UICollectionViewCell>(cellType: Cell.Type) {
        let frameworkBundle = Bundle(for: UrpayCardsSDK.self)
        guard let resourceBundleURL = frameworkBundle.url(forResource: "UrpayCardsResources", withExtension: "bundle"),
              let resourceBundle = Bundle(url: resourceBundleURL) else {
            print("Error: Could not locate UrpayCardsResources bundle.")
            return
        }
        let nib = UINib(nibName: String(describing: Cell.self), bundle: resourceBundle)
        register(nib, forCellWithReuseIdentifier: String(describing: Cell.self))
    }
}

