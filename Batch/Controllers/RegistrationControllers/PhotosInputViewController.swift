//
//  PhotosInputViewController.swift
//  Batch
//
//  Created by Kevin Shiflett on 6/14/22.
//

import Foundation
import UIKit

class PhotosInputViewController: RegistrationViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var selectedImageIndex: Int = 0
        
    //MARK: UI Elements
    
    let imagePicker = UIImagePickerController()
    
    let firstImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .white
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 15
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    let secondImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .white
        imageView.layer.cornerRadius = 15
        imageView.isUserInteractionEnabled = true
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    lazy var imagesStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [firstImageView, secondImageView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 15
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        return stackView
    }()
    
    //MARK: UI Lifecycle Methods
    override func viewDidLoad() {
        titleLabel.text = "Add two photos."
        subtitleLabel.text = "Show off your best pics. You can change these later."
        setupView()
        self.setupGradient()
        self.animateGradient()
        self.mainStackView.addArrangedSubview(imagesStackView)
        
        let openImagePickerForImage1 = UITapGestureRecognizer(target: self, action: #selector(self.openImagePicker))
        let openImagePickerForImage2 = UITapGestureRecognizer(target: self, action: #selector(self.openImagePicker))
        openImagePickerForImage1.name = "image1"
        openImagePickerForImage2.name = "image2"

        firstImageView.addGestureRecognizer(openImagePickerForImage1)
        secondImageView.addGestureRecognizer(openImagePickerForImage2)

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.imagesStackView.layoutIfNeeded()
        self.imagesStackView.heightAnchor.constraint(equalToConstant: self.firstImageView.frame.size.width).isActive = true
    }
    
    //MARK: Business Logic
    @objc func openImagePicker(sender: UITapGestureRecognizer) {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
            if sender.name == "image1" {
                self.selectedImageIndex = 0
            } else if sender.name == "image2" {
                self.selectedImageIndex = 1
            }
            self.imagePicker.delegate = self
            self.imagePicker.sourceType = .savedPhotosAlbum
            self.imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    // MARK: UIImagePickerControllerDelegate Methods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {

            if selectedImageIndex == 1 && firstImageView.image != nil {
                self.secondImageView.backgroundColor = .none
                self.secondImageView.image = pickedImage
            } else {
                self.firstImageView.backgroundColor = .none
                self.firstImageView.image = pickedImage
            }
        }
        
        dismiss(animated: true, completion: nil)
    }

    
}
