//
//  CenteredTableViewCell.swift
//  tutorial-one
//
//  Created by Samuel Heavner on 5/8/15.
//  Copyright (c) 2015 Samuel Heavner. All rights reserved.
//

import UIKit

class CenteredTableViewCell: UITableViewCell {

    @IBOutlet weak var textCenter: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
