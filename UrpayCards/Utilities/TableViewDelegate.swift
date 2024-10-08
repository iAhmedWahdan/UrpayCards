//
//  TableViewDelegate.swift
//  UrpayCards
//
//  Created by Ahmed Wahdan on 08/10/2024.
//

import UIKit

class TableViewDelegate<Model>: NSObject, UITableViewDelegate {
    var models: [Model]
    let didSelectItem: (Model) -> Void
    
    init(models: [Model], didSelectItem: @escaping (Model) -> Void) {
        self.models = models
        self.didSelectItem = didSelectItem
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = models[indexPath.row]
        didSelectItem(model)
    }
}
