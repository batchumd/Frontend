//
//  SettingsOptionsTableView.swift
//  Batch
//
//  Created by Kevin Shiflett on 6/28/22.
//

import Foundation
import UIKit


protocol SelectionDelegate {
    func selectionChanged(_ options: [SettingOption], _ type: ProfileSetting)
}

class SettingOptionsTableViewController: UITableViewController {
    
    public var options: [SettingOption]?
    
    var allowMultipleSelection: Bool = false
    
    var selectionDelegate: SelectionDelegate?
    
    var selectedOptions = [SettingOption]()
    
    var profileSettintType: ProfileSetting
                
    init(profileSettingType: ProfileSetting) {
        
        switch profileSettingType {
            case .gender:
                self.options = Gender.allCases
                self.allowMultipleSelection = false
        }
        
        self.profileSettintType = profileSettingType
        
        self.selectedOptions = profileSettingType.result ?? []
        
        super.init(style: .insetGrouped)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "option")
        self.navigationItem.title = profileSettingType.description
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.options!.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "option", for: indexPath)

        var content = cell.defaultContentConfiguration()

        let currentOption = self.options![indexPath.row]
        
        if self.selectedOptions.contains(where: {$0.rawValue == currentOption.rawValue}) {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }

        content.textProperties.font = UIFont(name: "Avenir", size: 17)!
        content.text = currentOption.rawValue.capitalizingFirstLetter()

        cell.contentConfiguration = content

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let currentOption = self.options![indexPath.row]
        if self.selectedOptions.contains(where: {$0.rawValue == currentOption.rawValue}) {
            if self.selectedOptions.count > 1 {
                self.selectedOptions.removeAll(where: {$0.rawValue == currentOption.rawValue})
            }
        } else {
            if allowMultipleSelection {
                self.selectedOptions.append(currentOption)
            } else {
                self.selectedOptions = [currentOption]
            }
        }
        selectionDelegate?.selectionChanged(self.selectedOptions, self.profileSettintType)
        self.tableView.reloadData()
    }

}
