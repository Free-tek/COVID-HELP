//
//  FriendTableViewCell.swift
//  Corona Help
//
//  Created by Botosoft Technologies on 23/03/2020.
//  Copyright © 2020 freetek. All rights reserved.
//

import UIKit

protocol FriendCellDelegate{
    
    func onClickWhatsapp(name: String,phone: String, lastWash: String)
    func onClickCall(name: String,phone: String, lastWash: String)
    func onClickMessage(name: String,phone: String, lastWash: String)
    
}

class FriendTableViewCell: UITableViewCell {

    
    @IBOutlet weak var friendName: UILabel!
    @IBOutlet weak var lastWashIcon: UIImageView!
    @IBOutlet weak var lastWashTime: UILabel!
    var cellDelegate: FriendCellDelegate?
    
    
    var friendItem: FriendModel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setFriend(friend: FriendModel) {
        friendItem = friend
    }

    
    @IBAction func whatsApp(_ sender: Any) {
        cellDelegate?.onClickWhatsapp(name: friendItem.name, phone: friendItem.number, lastWash: friendItem.lastWash)
        
    }
    
    
    @IBAction func phoneCall(_ sender: Any) {
        cellDelegate?.onClickCall(name: friendItem.name, phone: friendItem.number, lastWash: friendItem.lastWash)
    }
    
    
    @IBAction func message(_ sender: Any) {
        cellDelegate?.onClickMessage(name: friendItem.name, phone: friendItem.number, lastWash: friendItem.lastWash)
        
    }
}
