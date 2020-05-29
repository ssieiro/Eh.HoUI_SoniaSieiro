//
//  TopicsViewController.swift
//  Discourse_SoniaSieiro
//
//  Created by Sonia Sieiro on 17/03/2020.
//  Copyright © 2020 Sonia Sieiro. All rights reserved.
//

import UIKit

protocol TopicViewControllerDelegate: AnyObject {
    func reloadTable()
}

enum LatestTopicsError: Error {
    case malformedURL
    case emptyData
}

class TopicsViewController: UIViewController, TopicViewControllerDelegate {
    
    private let apiProvider = ApiProvider()
    private var latestTopicsResponse: LatestTopicsResponse?
    private var latestTopics : [Topic] = []
    private var users: [User] = []

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var newTopicButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refreshControlPulled), for: .valueChanged)
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()

    }
    
    func setupUI() {
        self.navigationController?.isNavigationBarHidden = true
        newTopicButton.layer.cornerRadius = 4
        titleLabel.font = .largeTitle2Bold1Light1LabelColor1LeftAligned
        titleLabel.text = "Topics"
        
        let nib = UINib.init(nibName: "TopicsTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "TopicsTableViewCell")
        
        let nib2 = UINib.init(nibName: "TopicsTableViewWelcomeCell", bundle: nil)
        tableView.register(nib2, forCellReuseIdentifier: "TopicsTableViewWelcomeCell")
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.refreshControl = refreshControl
        
        apiProvider.getLatestTopics { [weak self] (result) in
            switch result {
            case .success(let latestTopicsResponse):
                self?.latestTopicsResponse = latestTopicsResponse
                self?.latestTopics = latestTopicsResponse.topicList.topics
                self?.users = latestTopicsResponse.users
                self?.tableView.reloadData()
                
            case .failure(let error):
                print(error)
                self?.showErrorAlert(message: error.localizedDescription)
            }
        }
        tableView.reloadData()
    }
    
    @objc func refreshControlPulled() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            self?.refreshControl.endRefreshing()
            self?.reloadTable()
        }
    }

    

    func showErrorAlert(message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }

    func reloadTable() {
        print("recargado")
        apiProvider.getLatestTopics { [weak self] (result) in
            switch result {
            case .success(let latestTopicsResponse):
                self?.latestTopicsResponse = latestTopicsResponse
                self?.users = latestTopicsResponse.users
                self?.tableView.reloadData()
                print("reload data")
            case .failure(let error):
                print(error)
                self?.showErrorAlert(message: error.localizedDescription)
            }
        }

    }
    
    
    @IBAction func createNewTopic(_ sender: Any) {
        let newTopicVC = NewTopicViewController()
        let navigationController = UINavigationController(rootViewController: newTopicVC)
    
        navigationController.modalPresentationStyle = .fullScreen
        newTopicVC.delegate = self
        self.present(navigationController, animated: true, completion: nil)
        
    }
}


extension TopicsViewController: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - UITableViewDatasource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return latestTopics.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "TopicsTableViewWelcomeCell", for: indexPath) as? TopicsTableViewWelcomeCell {
                cell.setWelcomeCell()
                return cell
            }
            fatalError("Could not create the Welcome Cell")
        } else {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "TopicsTableViewCell", for: indexPath) as? TopicsTableViewCell {
                let topic = latestTopics[indexPath.row]
                cell.setTopic(topic: topic, users: users)
                return cell
            }
            fatalError("Could not create the Topic Cell")
        }
    }
    
    
    // MARK: UITableViewDelegate
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 151
        } else { return 96 }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let topic = latestTopics[indexPath.row]
        let topicsDetailVC = TopicsDetailViewController.init(withId: topic.id)
        topicsDetailVC.delegate = self
        let navigationController = UINavigationController(rootViewController: topicsDetailVC)
        navigationController.modalPresentationStyle = .fullScreen
        self.present(navigationController, animated: true, completion: nil)
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
}


