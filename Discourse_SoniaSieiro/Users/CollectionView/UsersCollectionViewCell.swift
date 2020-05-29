//
//  UsersCollectionViewCell.swift
//  Discourse_SoniaSieiro
//
//  Created by Sonia Sieiro on 21/05/2020.
//  Copyright © 2020 Sonia Sieiro. All rights reserved.
//

import UIKit
 
class UsersCollectionViewCell: UICollectionViewCell {
    
//    MARK: Properties
    
    private var user: User?
    
//    MARK: Lifecycle methods
    
    override func prepareForReuse() {
        user = nil
        userImage.image = nil
        
       }
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setNeedsLayout()
        userImage.layer.cornerRadius = 40

    }
    
//    MARK: IBOutlet
    
    @IBOutlet weak var battleLabel: UILabel!
    
//    MARK: ConfigureView
    
    func setUser(user: User) {
        userName.font = .avatar
        userName.textColor = .black
        userName.text = user.username
        let alphaAnimation = CABasicAnimation(keyPath: "opacity")
        alphaAnimation.fromValue = 0.0
        alphaAnimation.toValue = 1.0
        alphaAnimation.duration = 1.0
        alphaAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        DispatchQueue.global(qos:.userInitiated).async { [weak self] in
                let avatarTemplate = user.avatarTemplate
                let sized = avatarTemplate.replacingOccurrences(of: "{size}", with: "80")
                let usersURL = "https://mdiscourse.keepcoding.io\(sized)"
                guard let url = URL(string: usersURL),
                let data = try? Data(contentsOf: url) else {return}
                let image = UIImage(data: data)
                DispatchQueue.main.async {
                    self?.userImage.image = image
                    self?.userImage.layer.opacity = 1
                    self?.userImage.layer.add(alphaAnimation, forKey: "fade")
                }
            }
}
}


