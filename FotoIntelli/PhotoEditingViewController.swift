//
//  PhotoEditingViewController.swift
//  FotoIntelli
//
//  Created by Abhishek Yadav on 05/07/24.
//

import UIKit

class PhotoEditingViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    let imageView = UIImageView()
    var selectedImage: UIImage?
    let hoverView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupImageView()
        setupHoverView()
        setupButtons()
    }
    
    private func setupImageView() {
        imageView.frame = view.bounds
        imageView.contentMode = .scaleAspectFit
        view.addSubview(imageView)
    }
    
    private func setupHoverView() {
        hoverView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        hoverView.layer.cornerRadius = 10
        hoverView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(hoverView)
        
        NSLayoutConstraint.activate([
            hoverView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            hoverView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            hoverView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            hoverView.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    private func setupButtons() {
        let buttonStack = UIStackView()
        buttonStack.axis = .horizontal
        buttonStack.spacing = 20
        buttonStack.distribution = .fillEqually
        buttonStack.translatesAutoresizingMaskIntoConstraints = false
        
        let cameraButton = createButton(title: "Open Camera", action: #selector(openCamera))
        let cropButton = createButton(title: "Crop", action: #selector(cropImage))
        let rotateButton = createButton(title: "Rotate", action: #selector(rotateImage))
        let filterButton = createButton(title: "Filter", action: #selector(applyFilter))
        let saveButton = createButton(title: "Save", action: #selector(saveImage))
        
        buttonStack.addArrangedSubview(cameraButton)
        buttonStack.addArrangedSubview(cropButton)
        buttonStack.addArrangedSubview(rotateButton)
        buttonStack.addArrangedSubview(filterButton)
        buttonStack.addArrangedSubview(saveButton)
        
        hoverView.addSubview(buttonStack)
        
        NSLayoutConstraint.activate([
            buttonStack.topAnchor.constraint(equalTo: hoverView.topAnchor, constant: 10),
            buttonStack.leadingAnchor.constraint(equalTo: hoverView.leadingAnchor, constant: 10),
            buttonStack.trailingAnchor.constraint(equalTo: hoverView.trailingAnchor, constant: -10),
            buttonStack.bottomAnchor.constraint(equalTo: hoverView.bottomAnchor, constant: -10)
        ])
        
        // Hide editing buttons initially
        cropButton.isHidden = true
        rotateButton.isHidden = true
        filterButton.isHidden = true
        saveButton.isHidden = true
    }
    
    private func createButton(title: String, action: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 5
        button.addTarget(self, action: action, for: .touchUpInside)
        return button
    }
    
    @objc func openCamera() {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            showAlert(title: "Camera Unavailable", message: "Your device does not support camera.")
            return
        }
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .camera
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            selectedImage = image
            imageView.image = image
            
            // Hide the camera button and show the editing buttons
            for button in hoverView.subviews.first!.subviews {
                if let button = button as? UIButton {
                    if button.title(for: .normal) == "Open Camera" {
                        button.isHidden = true
                    } else {
                        button.isHidden = false
                    }
                }
            }
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    @objc func cropImage() {
        guard let image = selectedImage else { return }
        
        // Example crop: Crop the image to a square
        let cgImage = image.cgImage!
        let width = min(cgImage.width, cgImage.height)
        let x = (cgImage.width - width) / 2
        let y = (cgImage.height - width) / 2
        let croppedCgImage = cgImage.cropping(to: CGRect(x: x, y: y, width: width, height: width))
        let croppedImage = UIImage(cgImage: croppedCgImage!)
        
        selectedImage = croppedImage
        imageView.image = croppedImage
    }
    
    @objc func rotateImage() {
        guard let image = selectedImage else { return }
        
        let rotatedImage = image.rotate(radians: .pi / 2)
        selectedImage = rotatedImage
        imageView.image = rotatedImage
    }
    
    @objc func applyFilter() {
        guard let image = selectedImage else { return }
        
        let context = CIContext(options: nil)
        let ciImage = CIImage(image: image)
        
        let filter = CIFilter(name: "CISepiaTone")
        filter?.setValue(ciImage, forKey: kCIInputImageKey)
        filter?.setValue(0.8, forKey: kCIInputIntensityKey)
        
        if let output = filter?.outputImage, let cgImage = context.createCGImage(output, from: output.extent) {
            let filteredImage = UIImage(cgImage: cgImage)
            selectedImage = filteredImage
            imageView.image = filteredImage
        }
    }
    
    @objc func saveImage() {
        guard let image = selectedImage else { return }
        
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            showAlert(title: "Save Error", message: error.localizedDescription)
        } else {
            showAlert(title: "Saved", message: "Your edited image has been saved to your photos.")
        }
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
