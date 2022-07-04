//
//  ReusableTableViewController.swift
//  Batch
//
//  Created by Kevin Shiflett on 6/29/22.
//

import UIKit

class TableViewDataSource<Model>: NSObject, UITableViewDataSource {
    typealias CellConfigurator = (Model, UITableViewCell) -> Void
    
    var models: [Model]
    
    private let reuseIdentifier: String
    private let cellConfigurator: CellConfigurator
    
    init(models: [Model], reuseIdentifier: String, cellConfigurator: @escaping CellConfigurator) {
        self.models = models
        self.reuseIdentifier = reuseIdentifier
        self.cellConfigurator = cellConfigurator
    }
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = models[indexPath.row]
        let cell = tableView.dequeueReusableCell(
            withIdentifier: reuseIdentifier,
            for: indexPath
        )
        
        cellConfigurator(model, cell)
        
        return cell
    }
}

extension TableViewDataSource where Model == SettingOption {
    static func make(for options: [SettingOption],
                     reuseIdentifier: String = "option") -> TableViewDataSource {
        return TableViewDataSource(models: options, reuseIdentifier: reuseIdentifier) { (data, cell) in
            var content = cell.defaultContentConfiguration()
        
            content.textProperties.font = UIFont(name: "Avenir", size: 17)!
            
            content.text = data.rawValue.capitalizingFirstLetter()
            
            cell.contentConfiguration = content
            
        }
    }
}

class SectionedTableViewDataSource: NSObject {
    private let dataSources: [UITableViewDataSource]
    
    init(dataSources: [UITableViewDataSource]) {
        self.dataSources = dataSources
    }
}

extension SectionedTableViewDataSource: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSources.count
    }
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        let dataSource = dataSources[section]
        return dataSource.tableView(tableView, numberOfRowsInSection: 0)
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dataSource = dataSources[indexPath.section]
        let indexPath = IndexPath(row: indexPath.row, section: indexPath.section)
        return dataSource.tableView(tableView, cellForRowAt: indexPath)
    }
}
