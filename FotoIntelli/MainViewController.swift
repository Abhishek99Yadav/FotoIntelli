//
//  MainViewController.swift
//  FotoIntelli
//
//  Created by Abhishek Yadav on 05/07/24.
//

import UIKit

class MainViewController: UITableViewController {
    let features = ["Photo Editing", "AR Feature", "ML Feature"]//, "React Native Feature"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "FotoIntelli Features"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return features.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = features[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let photoVC = PhotoEditingViewController()
            self.navigationController?.pushViewController(photoVC, animated: true)
        case 1:
            let arVC = ARFeatureViewController()
            self.navigationController?.pushViewController(arVC, animated: true)
        case 2:
            let mlVC = MLFeatureViewController()
            self.navigationController?.pushViewController(mlVC, animated: true)
        case 3:
            //            let reactNativeVC = ReactNativeViewController()
            //            self.navigationController?.pushViewController(reactNativeVC, animated: true)
            return
        default:
            break
        }
    }
}
