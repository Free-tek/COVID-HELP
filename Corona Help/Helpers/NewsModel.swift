//
//  NewsModel.swift
//  Corona Help
//
//  Created by Botosoft Technologies on 21/03/2020.
//  Copyright © 2020 freetek. All rights reserved.
//

import Foundation

struct NewsModel:Decodable{
    let title: String
    let image: String
    let time: String
    let url: String
    
    
    init(title: String, image: String, time: String, url: String){
        self.title = title
        self.image = image
        self.time = time
        self.url = url
    }
}
