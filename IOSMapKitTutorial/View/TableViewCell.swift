//
//  TableViewCell.swift
//  IOSMapKitTutorial
//
//  Created by Field Employee on 6/1/21.
//  Copyright © 2021 Arthur Knopper. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var ciudad: UILabel!
    
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
