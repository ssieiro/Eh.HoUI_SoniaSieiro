//
//  TopicsTableViewController.swift
//  Discourse_SoniaSieiro
//
//  Created by Sonia Sieiro on 24/05/2020.
//  Copyright © 2020 Sonia Sieiro. All rights reserved.
//

import UIKit

class TopicsTableViewCell: UITableViewCell {
    
    private var topic: Topic?
    private var users: [Users] = []
    private var apiProvider = ApiProvider()
    
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var topicTitle: UILabel!
    @IBOutlet weak var postCountLabel: UILabel!
    @IBOutlet weak var posterNumberLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
    avatar.layer.cornerRadius = 32
    }
    
    func setTopic(topic: Topic, users: [Users]) {
        self.users = users
        let imageId = getImageId(posters: topic.posters)
        let user = filterUser(id: imageId)
        DispatchQueue.global(qos:.userInitiated).async { [weak self] in
                let avatarTemplate = user.avatarTemplate
                let sized = avatarTemplate.replacingOccurrences(of: "{size}", with: "80")
                let usersURL = "https://mdiscourse.keepcoding.io\(sized)"
                guard let url = URL(string: usersURL),
                let data = try? Data(contentsOf: url) else {return}
                let image = UIImage(data: data)
                DispatchQueue.main.async {
                    self?.avatar.image = image
        
                }
            }

        topicTitle.font = .style27
        topicTitle.text = topic.title
        postCountLabel.text = String(topic.postsCount)
        let date = apiProvider.dateFormater(topic.lastPostedAt)
        dateLabel.text = date.capitalized
        
    }
    
    func getImageId (posters: [Poster]) -> Int {
        var id = 0
        for poster in posters {
            if poster.description.contains("Most Recent Poster") {
                id = poster.user_id
            }
        }
        return id
    }
    
    func filterUser (id: Int) -> User {
        guard let user = users.first(where: ({ $0.user.id == id }) ) else {fatalError()}
        return user.user
    }
    
    
    
    

}
