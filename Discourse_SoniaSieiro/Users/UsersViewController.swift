//
//  ViewController.swift
//  Discourse_SoniaSieiro
//
//  Created by Sonia Sieiro on 17/03/2020.
//  Copyright © 2020 Sonia Sieiro. All rights reserved.
//

import UIKit


enum UsersError: Error {
    case empty
}

class UsersViewController: UIViewController  {

    
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var titleLabel: UILabel!
    
    private let apiProvider = ApiProvider()
    var users: [Users] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()

    }
    
    func setupUI() {
        self.navigationController?.isNavigationBarHidden = true
        titleLabel.font = .largeTitle2Bold1Light1LabelColor1LeftAligned
        titleLabel.text = "Users"

        let nib = UINib.init(nibName: "UsersCollectionViewCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "UsersCollectionViewCell")
        collectionView.dataSource = self
        collectionView.delegate = self

        apiProvider.getUsers { [weak self] result in
            switch result {
            case .success(let users):
                self?.users = users
                self?.collectionView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }    
}

extension UsersViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 94, height: 124)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 24, left: 26, bottom: 0, right: 26);
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 19
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 20.5
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return users.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UsersCollectionViewCell", for: indexPath) as? UsersCollectionViewCell {
            
            let user = users[indexPath.row].user
            cell.setUser(user: user)
            return cell
        }
        fatalError("Could not create the User cell")
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let singleUser = users[indexPath.row]
        let userDetailVC = UserDetailViewController.init(withUsername: singleUser.user.username)
        let navigationController = UINavigationController(rootViewController: userDetailVC)
        navigationController.modalPresentationStyle = .fullScreen
        self.present(navigationController, animated: true, completion: nil)

        collectionView.deselectItem(at: indexPath, animated: true)
    }
}
    

