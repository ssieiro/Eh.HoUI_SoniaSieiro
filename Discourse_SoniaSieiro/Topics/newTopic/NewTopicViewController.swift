//
//  NewTopicViewController.swift
//  Discourse_SoniaSieiro
//
//  Created by Sonia Sieiro on 27/03/2020.
//  Copyright © 2020 Sonia Sieiro. All rights reserved.
//

import UIKit

class NewTopicViewController: UIViewController {
    
    private var apiProvider = ApiProvider()
    weak var delegate: TopicViewControllerDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Create"
        topicTitle.placeholder = "Introduzca título del topic"
    }
 

    @IBOutlet weak var topicTitle: UITextField!
    
    
    
    @IBAction func closeNewTopic(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    @IBAction func submit(_ sender: Any) {
        if let topicTitle = topicTitle.text {
            if topicTitle.count < 19 {
                self.showAlert(title: "Error", message: "Your title is too short")
                return
            } else {
                let configuration = URLSessionConfiguration.default
                let session = URLSession(configuration: configuration)
                let request  = apiProvider.createNewTopicRequest(topicTitle: topicTitle)
                let dataTask = session.dataTask(with: request) { (_, response, error) in

                    if let response = response as? HTTPURLResponse {
                        let statusCode = response.statusCode
                        if statusCode == 200 {
                            DispatchQueue.main.async { [weak self] in
                                self?.delegate?.reloadTable()
                                self?.dismiss(animated: true, completion: nil)
                            }

                        } else {
                            DispatchQueue.main.async { [weak self] in
                                self?.showAlert(title: "Error", message: "Error de red, status code: \(statusCode)")
                            }
                            return
                        }
                    }
                    if let error = error {
                        DispatchQueue.main.async { [weak self] in
                            self?.showAlert(title: "Error", message: error.localizedDescription)
                            return
                        }
                        return
                    }
                    }
                dataTask.resume()
            }
            }
    }

    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
}
