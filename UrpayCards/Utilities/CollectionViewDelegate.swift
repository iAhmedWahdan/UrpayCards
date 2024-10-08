//
//  CollectionViewDelegate.swift
//  UrpayCards
//
//  Created by Ahmed Wahdan on 08/10/2024.
//

import UIKit

class CollectionViewDelegate<Model>: NSObject, UICollectionViewDelegate {
    var models: [Model]
    let didSelectItem: (Model) -> Void
    
    init(models: [Model], didSelectItem: @escaping (Model) -> Void) {
        self.models = models
        self.didSelectItem = didSelectItem
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = models[indexPath.row]
        didSelectItem(model)
    }

    // Implement other delegate methods as needed
}

