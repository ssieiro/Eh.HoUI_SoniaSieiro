//
//  UserDetailViewController.swift
//  Discourse_SoniaSieiro
//
//  Created by Sonia Sieiro on 07/04/2020.
//  Copyright © 2020 Sonia Sieiro. All rights reserved.
//

import UIKit

enum SingleUserError: Error {
    case emptyData
    case malformedURL
}

class UserDetailViewController: UIViewController {
    
    private var apiProvider = ApiProvider()
    var singleUser: SingleUserResponse?
    var username: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateButton.isHidden = true
        self.nameField.isHidden = true
        if let username = username {
            apiProvider.getSingleUser (username: username) { [weak self] (result) in
             switch result {
             case .success(let singleUser):
                 self?.singleUser = singleUser
                 self?.setupUI()
             case .failure(let error):
                 print(error)
                 self?.showAlert(title: "Error", message: error.localizedDescription)
             }
            }
        }
    }
    
    func setupUI() {
        updateButton.layer.cornerRadius = 10
        if let singleUser = singleUser {
            userId.text = "Id: \(singleUser.user.id)"
            usernameLabel.text = singleUser.user.username
            name.text = singleUser.user.name ?? "-"
            if singleUser.user.canEditName == true {
                nameField.isHidden = false
                name.isHidden = true
                updateButton.isHidden = false
                nameField.text = singleUser.user.name
            }
        }

    }
    
    convenience init(withUsername username: String) {
        self.init(nibName: "UserDetailViewController", bundle: nil)
        self.username = username
        self.title = "User detail"
    }
    
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var userId: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var updateButton: UIButton!
    
    
    @IBAction func close(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func updateName(_ sender: Any) {
    guard let nameField = nameField.text, let username = username else {return}
    let configuration = URLSessionConfiguration.default
    let session = URLSession(configuration: configuration)
        let request = apiProvider.updateName(username: username, nameField: nameField)

    let dataTask = session.dataTask(with: request) { (_, response, error) in
        
        if let response = response as? HTTPURLResponse {
            print(response.statusCode)
            if response.statusCode != 200 {
                DispatchQueue.main.async { [weak self] in
                    self?.showAlert(title: "Error", message: "Error de red, status code: \(response.statusCode)")
                }
            } else {
                DispatchQueue.main.async { [weak self] in
                self?.showAlert(title: "Success", message: "Name changed")

                }
            }
        }

        if let error = error {
            DispatchQueue.main.async { [weak self] in
                self?.showAlert(title: "Error", message: error.localizedDescription)
            }
            return
        }

    }
    dataTask.resume()

    }
    
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    }
 
