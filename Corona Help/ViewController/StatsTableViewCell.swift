//
//  StatsTableViewCell.swift
//  Corona Help
//
//  Created by Botosoft Technologies on 21/03/2020.
//  Copyright © 2020 freetek. All rights reserved.
//

import UIKit

class StatsTableViewCell: UITableViewCell {

    
    @IBOutlet weak var country: UILabel!
    @IBOutlet weak var confirmed: UILabel!
    @IBOutlet weak var recovered: UILabel!
    @IBOutlet weak var deaths: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
