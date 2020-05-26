//
//  ApiProvider.swift
//  Discourse_SoniaSieiro
//
//  Created by Sonia Sieiro on 23/05/2020.
//  Copyright © 2020 Sonia Sieiro. All rights reserved.
//

import UIKit

class ApiProvider {
    
//    Constants
    private let url = "https://mdiscourse.keepcoding.io"
    private let httpGet = "GET"
    private let httpPost = "POST"
    private let httpDelete = "DELETE"
    private let httpPut = "PUT"
    private let apiKeyHeaderField = "Api-Key"
    private let apiKey = "699667f923e65fac39b632b0d9b2db0d9ee40f9da15480ad5a4bcb3c1b095b7a"
    private let usernameHeaderField = "Api-Username"
    private let username = "ssieiro2"
    private let contentTypeHeaderField = "Content-Type"
    private let contentType = "application/json"

    

//    Request Methods

    func createNewTopicRequest(topicTitle: String) -> URLRequest {
        guard let updateStatusURL = URL(string: "\(url)/posts.json") else { fatalError() }



        var request = URLRequest(url: updateStatusURL)
        request.httpMethod = httpPost
        request.addValue(apiKey, forHTTPHeaderField: apiKeyHeaderField)
        request.addValue(username, forHTTPHeaderField: usernameHeaderField)
        request.addValue(contentType, forHTTPHeaderField: contentTypeHeaderField)

        let body: [String: Any] = [
          "title": topicTitle,
          "raw": topicTitle
        ]

        guard let dataBody = try? JSONSerialization.data(withJSONObject: body) else { fatalError() }
        request.httpBody = dataBody
        return request
    }

    func deleteTopicRequest(id: Int) -> URLRequest {
        guard let updateStatusURL = URL(string: "\(url)/t/\(id).json") else { fatalError() }

        var request = URLRequest(url: updateStatusURL)
        request.httpMethod = httpDelete
        request.addValue(apiKey, forHTTPHeaderField: apiKeyHeaderField)
        request.addValue(username, forHTTPHeaderField: usernameHeaderField)
        return request
    }
    
    func updateName (username: String, nameField: String) -> URLRequest {
        guard let updateNameURL = URL(string: "https://mdiscourse.keepcoding.io/users/\(username)") else { fatalError() }
        var request = URLRequest(url: updateNameURL)
        request.httpMethod = "PUT"
        request.addValue("699667f923e65fac39b632b0d9b2db0d9ee40f9da15480ad5a4bcb3c1b095b7a", forHTTPHeaderField: "Api-Key")
        request.addValue("ssieiro2", forHTTPHeaderField: "Api-Username")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
          "name": nameField
        ]
        guard let dataBody = try? JSONSerialization.data(withJSONObject: body) else { fatalError() }
        request.httpBody = dataBody
        return request
    }
    
//    Fetch Methods
    
    func getLatestTopics(completion: @escaping (Result<LatestTopicsResponse, Error>) -> Void) {
        guard let latestTopicsURL = URL(string: "\(url)/latest.json") else {
            completion(.failure(LatestTopicsError.malformedURL))
            return
        }

        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration)

        var request = URLRequest(url: latestTopicsURL)
        request.httpMethod = httpGet
        request.addValue(apiKey, forHTTPHeaderField: apiKeyHeaderField)
        request.addValue(username, forHTTPHeaderField: usernameHeaderField)

        let dataTask = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }

            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(LatestTopicsError.emptyData))
                }
                return
            }

            do {
                let response = try JSONDecoder().decode(LatestTopicsResponse.self, from: data)
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

    func getSingleTopic(id: Int, completion: @escaping (Result<SingleTopicResponse, Error>) -> Void) {
        guard let singleTopicURL = URL(string: "\(url)/t/\(id).json") else {
            completion(.failure(LatestTopicsError.malformedURL))
            return
        }

        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration)

        var request = URLRequest(url: singleTopicURL)
        request.httpMethod = httpGet
        request.addValue(apiKey, forHTTPHeaderField: apiKeyHeaderField)
        request.addValue(username, forHTTPHeaderField: usernameHeaderField)

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
    
    func getUsers(completion: @escaping (Result<[Users], Error>) -> Void){
        
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration)
        guard let url = URL(string:"https://mdiscourse.keepcoding.io/directory_items.json?period=all") else { fatalError() }

        let task = session.dataTask(with: url) { (data, response, error) in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                    return
                }
                if let data = data {
                    guard let UsersListResponse = try? JSONDecoder().decode(UsersListResponse.self, from: data) else {
                        completion(.failure(UsersError.empty))
                        return
                    }
                    completion(.success(UsersListResponse.directoryItems))
                }
            }
        }
        
        task.resume()
    }
    
    func getCategories(completion: @escaping (Result<[Category], Error>) -> Void) {
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
    
    func getSingleUser(username: String, completion: @escaping (Result<SingleUserResponse, Error>) -> Void) {
            guard let singleUserURL = URL(string: "https://mdiscourse.keepcoding.io/users/\(username).json") else {
                completion(.failure(SingleUserError.malformedURL))
                return }
            let configuration = URLSessionConfiguration.default
            let session = URLSession(configuration: configuration)

            var request = URLRequest(url: singleUserURL)
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
                        completion(.failure(SingleUserError.emptyData))
                    }
                    return
                }

                do {
                    let response = try JSONDecoder().decode(SingleUserResponse.self, from: data)
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
    
//    Date Formatter
    
    func dateFormater (_ inputStringDate: String) -> String {
        let inputFormat = "YYYY-MM-DD'T'HH:mm:ss.SSSZ"
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "es_ES")
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        dateFormatter.dateFormat = inputFormat
        // Generar la fecha a partir del string y el formato de entrada
        guard let date = dateFormatter.date(from: inputStringDate) else { fatalError() }

        // Generar el string en el format de fecha requerido
        // Friday 17, January
        let outputFormat = "MMM d"
        dateFormatter.dateFormat = outputFormat
        let outputStringDate = dateFormatter.string(from: date)
        return outputStringDate
    }

}

