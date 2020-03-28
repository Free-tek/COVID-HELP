//
//  FriendModel.swift
//  Corona Help
//
//  Created by Botosoft Technologies on 23/03/2020.
//  Copyright © 2020 freetek. All rights reserved.
//

import Foundation

struct FriendModel{
    let name: String
    let number: String
    let lastWash: String

    init(name: String, number: String, lastWash: String){
        self.name = name
        self.number = number
        self.lastWash = lastWash
        
    }
}
