//
//  PreferencesViewController.swift
//  Batch
//
//  Created by Kevin Shiflett on 6/26/22.
//

import UIKit
import FirebaseAuth

class PreferencesViewController: UIViewController {
        
    let tableView = UITableView(frame: .zero, style: .insetGrouped)
    
    let imagePicker = UIImagePickerController()
    
    let backend = FirebaseHelpers()
    
    var heightConstraint: NSLayoutConstraint?
    
    var preferencesDelegate: PreferencesDelegate?
    
    lazy var userPhotosCollectionView: UserPhotosCollectionView = {
        let userPhotosCollectionView = UserPhotosCollectionView(frame: .zero)
        userPhotosCollectionView.photoSelectionDelegate = self
        return userPhotosCollectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemGray6
        self.navigationItem.title = "Preferences"
        configureTable()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        LocalStorage.shared.delegate = self
        userDataChanged()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let height = userPhotosCollectionView.collectionViewLayout.collectionViewContentSize.height + 18
        if let header = tableView.tableHeaderView {
            header.frame.size.height = height
        }
    }
    
    fileprivate func configureTable() {
        tableView.rowHeight = 60
        tableView.delegate = self
        tableView.backgroundColor = .clear
        tableView.dataSource = self
        tableView.register(SettingsCell.self, forCellReuseIdentifier: "setting")
        view.addSubview(tableView)
        tableView.fillSuperView(useSafeAreaLayouts: false)
        tableView.tableHeaderView = userPhotosCollectionView
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
            guard let email = LocalStorage.shared.currentUserData?.email else { return }
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
        if type == .gender {
            FirebaseHelpers().updateUserData(data: ["gender": options.first!.rawValue]) {}
        }
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
            case .gender:
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

extension PreferencesViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate, PhotoSelectionDelegate {
    
    func photoCellSelected(isEmpty: Bool) {
        if isEmpty {
            openImagePicker()
        } else {
            showAlertWithImageOptions()
        }
    }
    
    func openImagePicker() {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
            self.imagePicker.delegate = self
            self.imagePicker.sourceType = .savedPhotosAlbum
            self.imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    // MARK: UIImagePickerControllerDelegate Methods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            guard let uid = backend.getUserID(), let imagesCount = LocalStorage.shared.currentUserData?.profileImages.count else {
                return
            }
            let reference = "profileImages/\(uid)\(imagesCount + 1).jpg"
            self.handleUpload(reference, image: pickedImage) {
            }
        }
        
        dismiss(animated: true, completion: nil)
    }
       
        
    fileprivate func handleUpload(_ reference: String, image: UIImage, complete: @escaping () -> ()) {
        self.userPhotosCollectionView.selectedCell?.startLoadingProgress()
        backend.uploadImage(reference: reference, image: image) {
            self.backend.downloadURL(reference: reference) { imageURL in
                self.backend.addImageToUserData(imageURL) {}
                complete()
            }
        }
    }
    
    fileprivate func showAlertWithImageOptions() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (result : UIAlertAction) -> Void in
            //action when pressed button
        }
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { (result : UIAlertAction) -> Void in
            self.userPhotosCollectionView.selectedCell?.startLoadingProgress()
            if let imageURL = self.userPhotosCollectionView.selectedCell?.imageURL {
                FirebaseHelpers().deleteUserImages(url: imageURL) {}
            }
        }
        
        alert.addAction(cancelAction)
        alert.addAction(deleteAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.preferencesDelegate?.dismissPreferences()
    }
}

extension PreferencesViewController: LocalStorageDelegate {
    func userDataChanged() {
        self.tableView.reloadData()
        self.userPhotosCollectionView.reloadData()
    }
}
