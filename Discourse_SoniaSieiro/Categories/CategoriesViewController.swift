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
    var categories: [Category] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")

        fetchCategories { [weak self] (result) in
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

    func fetchCategories(completion: @escaping (Result<[Category], Error>) -> Void) {
        guard let categoriesURL = URL(string: "https://mdiscourse.keepcoding.io/categories.json") else {
            completion(.failure(CategoriesError.malformedURL))
            return
        }

        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration)

        var request = URLRequest(url: categoriesURL)
        request.httpMethod = "GET"
        request.addValue("699667f923e65fac39b632b0d9b2db0d9ee40f9da15480ad5a4bcb3c1b095b7a", forHTTPHeaderField: "Api-Key")
        request.addValue("soniasieiro", forHTTPHeaderField: "Api-Username")

        let dataTask = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }

            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(CategoriesError.emptyData))
                }
                return
            }

            do {
                let response = try JSONDecoder().decode(CategoriesResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(response.categoryList.categories))
                }
            } catch(let error) {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }

        dataTask.resume()
    }

}

extension CategoriesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = categories[indexPath.row].name
        cell.textLabel?.textColor = UIColor.white
        cell.contentView.backgroundColor = UIColor.darkGray
        return cell
    }
}

