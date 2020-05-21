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
    
    var singleTopic: SingleTopicResponse?
    var id: Int?
    var delegate: TopicViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.deleteButton.isHidden = true
    
    fetchSingleTopics { [weak self] (result) in
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

    func fetchSingleTopics(completion: @escaping (Result<SingleTopicResponse, Error>) -> Void) {
        guard let singleTopicURL = URL(string: "https://mdiscourse.keepcoding.io/t/\(id ?? 0).json") else {
            completion(.failure(LatestTopicsError.malformedURL))
            return
        }

        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration)

        var request = URLRequest(url: singleTopicURL)
        request.httpMethod = "GET"
        request.addValue("699667f923e65fac39b632b0d9b2db0d9ee40f9da15480ad5a4bcb3c1b095b7a", forHTTPHeaderField: "Api-Key")
        request.addValue("ssieiro2", forHTTPHeaderField: "Api-Username")

        let dataTask = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }

            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(SingleTopicError.emptyData))
                }
                return
            }

            do {
                let response = try JSONDecoder().decode(SingleTopicResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(response))
                }
            } catch(let error) {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }

        dataTask.resume()
    }
    
    
    @IBAction func deleteTopic(_ sender: Any) {

    if let id = id {
        guard let updateStatusURL = URL(string: "https://mdiscourse.keepcoding.io/t/\(id).json") else { return }

        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration)

        var request = URLRequest(url: updateStatusURL)
        request.httpMethod = "DELETE"
        request.addValue("699667f923e65fac39b632b0d9b2db0d9ee40f9da15480ad5a4bcb3c1b095b7a", forHTTPHeaderField: "Api-Key")
        request.addValue("ssieiro2", forHTTPHeaderField: "Api-Username")

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
    
