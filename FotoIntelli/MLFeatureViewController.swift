//
//  MLFeatureViewController.swift
//  FotoIntelli
//
//  Created by Abhishek Yadav on 05/07/24.
//

import UIKit
import Accelerate

class MLFeatureViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    var model: TorchModule!

    let imageView = UIImageView()
    let label = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        imageView.frame = CGRect(x: 20, y: 100, width: view.bounds.width - 40, height: view.bounds.width - 40)
        view.addSubview(imageView)

        label.frame = CGRect(x: 20, y: view.bounds.width + 120, width: view.bounds.width - 40, height: 40)
        view.addSubview(label)

        let selectButton = UIButton(type: .system)
        selectButton.setTitle("Select Image", for: .normal)
        selectButton.addTarget(self, action: #selector(selectImage), for: .touchUpInside)
        selectButton.frame = CGRect(x: 20, y: view.bounds.height - 60, width: view.bounds.width - 40, height: 40)
        view.addSubview(selectButton)

        // Load your model here (replace 'model.ptl' with your actual model file name)
        if let modelPath = Bundle.main.path(forResource: "model", ofType: "ptl") {
            do {
                model = try TorchModule(fileAtPath: modelPath)
            } catch {
                print("Error loading model: \(error.localizedDescription)")
                // Handle the error appropriately, e.g., show an alert or log the error
            }
        } else {
            print("Model file not found in bundle.")
            // Handle the case where the model file is missing from the app bundle
        }
    }

    @objc func selectImage() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        present(picker, animated: true, completion: nil)
    }

    func processImage(_ image: UIImage) {
        guard let pixelBuffer = image.toCVPixelBuffer() else {
            print("Failed to convert image to CVPixelBuffer")
            return }
        let tensor = Tensor<Float>(shape: [1, Int(image.size.height), Int(image.size.width), 3], scalars: Array(repeating: 0.0, count: Int(image.size.height * image.size.width * 3)))
        let result = model.predict(inputTensor: tensor)
        label.text = "Prediction: \(result)"
    }
}
