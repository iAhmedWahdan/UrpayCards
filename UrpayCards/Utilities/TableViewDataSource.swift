//
//  TableViewDataSource.swift
//  UrpayCards
//
//  Created by Ahmed Wahdan on 08/10/2024.
//

import UIKit

class TableViewDataSource<Model, Cell: UITableViewCell>: NSObject, UITableViewDataSource {
    var models: [Model]
    let configureCell: (Cell, Model) -> Void
    
    init(models: [Model], configureCell: @escaping (Cell, Model) -> Void) {
        self.models = models
        self.configureCell = configureCell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Cell.className, for: indexPath) as! Cell
        let model = models[indexPath.row]
        configureCell(cell, model)
        return cell
    }
}

extension UITableView {
    func register<Cell: UITableViewCell>(cellType: Cell.Type) {
        let frameworkBundle = Bundle(for: UrpayCardsSDK.self)
        let nib = UINib(nibName: String(describing: Cell.self), bundle: frameworkBundle)
        register(nib, forCellReuseIdentifier: String(describing: Cell.self))
    }
}
