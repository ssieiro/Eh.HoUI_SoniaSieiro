//
//  TopicsDetailViewController.swift
//  Discourse_SoniaSieiro
//
//  Created by Sonia Sieiro on 23/03/2020.
//  Copyright © 2020 Sonia Sieiro. All rights reserved.
//
//
import UIKit

enum SingleTopicError: Error {
    case malformedURL
    case emptyData
}

class TopicsDetailViewController: UIViewController {
    
    private var apiProvider = ApiProvider()
    var singleTopic: SingleTopicResponse?
    var id: Int?
    var delegate: TopicViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.deleteButton.isHidden = true
        if let id = id {
            apiProvider.getSingleTopic(id: id){ [weak self] (result) in
                switch result {
                case .success(let singleTopic):
                    self?.singleTopic = singleTopic
                    DispatchQueue.main.async {
                        self?.setupUI()
                    }
                case .failure(let error):
                    print(error)
                    self?.showErrorAlert(message: error.localizedDescription)
                }
            }
        }
    }
    
    func setupUI() {
        topicTitle.text = singleTopic?.title
        topicId.text = "Id: \(singleTopic?.id ?? 0)"
        postNumber.text = "Número de posts: \(singleTopic?.postsCount ?? 0)"
        if singleTopic?.details.canDelete == true {
            self.deleteButton.isHidden = false
        }
        
    }
    
    convenience init(withId id: Int) {
        self.init(nibName: "TopicsDetailViewController", bundle: nil)
        self.id = id
        self.title = "Detail"
    }
    
    @IBOutlet weak var topicTitle: UILabel!
    @IBOutlet weak var topicId: UILabel!
    @IBOutlet weak var postNumber: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    
    func showErrorAlert(message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func deleteTopic(_ sender: Any) {
    if let id = id {
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration)
        let request = apiProvider.deleteTopicRequest(id: id)
        let dataTask = session.dataTask(with: request) { (_, response, error) in

            if let response = response as? HTTPURLResponse {
                print(response.statusCode)
                DispatchQueue.main.async { [weak self] in
                    self?.delegate?.reloadTable()
                }
                if response.statusCode != 200 {
                    DispatchQueue.main.async { [weak self] in
                        self?.showAlert(title: "Error", message: "Error de red, status code: \(response.statusCode)")
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
        self.dismiss(animated: true, completion: nil)

    }
    }

    @IBAction func closeTopic(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
}
    
