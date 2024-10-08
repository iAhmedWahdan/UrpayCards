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

