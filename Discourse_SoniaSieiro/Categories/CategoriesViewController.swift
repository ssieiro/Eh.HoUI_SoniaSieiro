//
//  CategoriesViewController.swift
//  Discourse_SoniaSieiro
//
//  Created by Sonia Sieiro on 17/03/2020.
//  Copyright © 2020 Sonia Sieiro. All rights reserved.
//

import UIKit

enum CategoriesError: Error {
    case malformedURL
    case emptyData
}

class CategoriesViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private let apiProvider = ApiProvider()
    var categories: [Category] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")

        apiProvider.getCategories { [weak self] (result) in
            switch result {
            case .success(let categories):
                self?.categories = categories
                self?.tableView.reloadData()
            case .failure(let error):
                print(error)
                self?.showErrorAlert(message: error.localizedDescription)
            }
        }
    }
    
    func showErrorAlert(message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
}

extension CategoriesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = categories[indexPath.row].name
        cell.textLabel?.textColor = .black
//        cell.contentView.backgroundColor = UIColor.darkGray
        return cell
    }
}

