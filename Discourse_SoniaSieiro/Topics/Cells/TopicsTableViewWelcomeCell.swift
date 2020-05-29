//
//  TopicsTableViewWelcomeCell.swift
//  Discourse_SoniaSieiro
//
//  Created by Sonia Sieiro on 29/05/2020.
//  Copyright © 2020 Sonia Sieiro. All rights reserved.
//

import UIKit

class TopicsTableViewWelcomeCell: UITableViewCell {
    
    @IBOutlet weak var orangeView: UIView!
    @IBOutlet weak var welcomeTitle: UILabel!
    
    override func awakeFromNib() {
        orangeView.layer.cornerRadius = 8
     }


     func setWelcomeCell() {
        setNeedsLayout()
     }


}
