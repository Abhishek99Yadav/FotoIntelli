//
//  SplashScreenViewController.swift
//  FotoIntelli
//
//  Created by Abhishek Yadav on 05/07/24.
//

import UIKit

class SplashScreenViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up splash screen UI
        view.backgroundColor = .white
        
        // Create and configure the image view
        let imageView = UIImageView(image: UIImage(named: "AppIcon"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true
        
        view.addSubview(imageView)
        
        // Add constraints to center the image view in the middle of the screen
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 300),
            imageView.heightAnchor.constraint(equalToConstant: 300)
        ])
        
        // Navigate to the Main Screen after a delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            let mainVC = MainViewController()
            self.navigationController?.pushViewController(mainVC, animated: true)
        }
    }
}
