//
//  PreferencesViewController.swift
//  Batch
//
//  Created by Kevin Shiflett on 6/26/22.
//

import UIKit
import FirebaseAuth

class PreferencesViewController: ViewControllerWithHeader {
        
    let tableView = UITableView(frame: .zero, style: .insetGrouped)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemGray6
        setupHeader(title: "Preferences")
        configureTable()
    }
    
    fileprivate func configureTable() {
        tableView.rowHeight = 60
        tableView.delegate = self
        tableView.backgroundColor = .clear
        tableView.dataSource = self
        tableView.register(SettingsCell.self, forCellReuseIdentifier: "setting")
        view.addSubview(tableView)
        tableView.anchor(top: headerLabel.bottomAnchor, bottom: view.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: margin/2, left: 10, bottom: 0, right: 10))
    }
    
    func showGenderOptionsController(_ setting: ProfileSetting) {
        let vc = SettingOptionsTableViewController(profileSettingType: setting)
        vc.selectionDelegate = self
        let transition:CATransition = CATransition()
        transition.duration = 0.25
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.fade
        self.navigationController!.view.layer.add(transition, forKey: kCATransition)
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    func showReAuthAlert(title: String = "Confirm your password.") {
        let alert = UIAlertController(title: title, message: "To delete your account please enter your password.", preferredStyle: UIAlertController.Style.alert)
        alert.addTextField { field in
            field.placeholder = "Password"
            field.isSecureTextEntry = true
            field.returnKeyType = .continue
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Done", style: UIAlertAction.Style.default, handler: { _ in
            guard let email = LocalStorage.shared.currentUserData()?.email else { return }
            guard let passwordField = alert.textFields?[0].text else { return }
            Auth.auth().signIn(withEmail: email, password: passwordField) { result, error in
                if error != nil {
                    self.showReAuthAlert(title: "Password was incorrect")
                    return
                }
                FirebaseHelpers().deleteCurrentUser { error in
                    if let error = error {
                        print(error.localizedDescription)
                        return
                    }
                }
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func handleSignOut() {
        FirebaseHelpers().signOutUser()
    }
}

extension PreferencesViewController: SelectionDelegate {

    func selectionChanged(_ options: [SettingOption], _ type: ProfileSetting) {
        if type == .interestedIn {
            FirebaseHelpers().updateUserData(data: ["interestedIn": options.map({$0.rawValue})])
        } else if type == .gender {
            FirebaseHelpers().updateUserData(data: ["gender": options.first!.rawValue])
        }
        self.tableView.reloadData()
    }
}

extension PreferencesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return SettingsSection.allCases.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "setting", for: indexPath) as! SettingsCell
        
        guard let section = SettingsSection(rawValue: indexPath.section) else { return UITableViewCell() }
                
        switch section {
            case .profile:
                let profileSetting = ProfileSetting(rawValue: indexPath.row)
                cell.sectionType = profileSetting
            case .notifications:
                let notificationSetting = NotificationsSetting(rawValue: indexPath.row)
                cell.sectionType = notificationSetting
            case .auth:
                let authSetting = AuthSetting(rawValue: indexPath.row)
                cell.sectionType = authSetting
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = SettingsSection(rawValue: section) else { return 0 }
        
        switch section {
            case .profile: return ProfileSetting.allCases.count
            case .notifications: return NotificationsSetting.allCases.count
            case .auth: return AuthSetting.allCases.count
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let section = SettingsSection(rawValue: indexPath.section) else { return }
        
        let cell = tableView.cellForRow(at: indexPath) as! SettingsCell
        
        switch section {
        case .profile:
            guard let profileSetting = ProfileSetting(rawValue: indexPath.row) else { return }
            switch profileSetting {
            case .photos:
                print("showPhotos")
            case .interestedIn, .gender:
                showGenderOptionsController(profileSetting)
            }
        case .notifications: cell.toggleSwitch.toggle()
        case .auth:
            guard let authSetting = AuthSetting(rawValue: indexPath.row) else { return }
            switch authSetting {
                case .signOut: FirebaseHelpers().signOutUser()
                case .deleteAccount: showReAuthAlert()
            }
        }
      
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        let title = UILabel()
        title.text = SettingsSection(rawValue: section)?.description
        title.font = UIFont(name: "Brown-bold", size: 15)
        title.textColor = .systemGray2
        view.addSubview(title)
        title.anchor(top: nil, bottom: nil, leading: view.leadingAnchor, trailing: nil, padding: UIEdgeInsets(top: 0, left: 0, bottom: 15, right: 0))
        return view
    }
    
}
