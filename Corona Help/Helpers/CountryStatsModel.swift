 //
//  CountryStatsModel.swift
//  Corona Help
//
//  Created by Botosoft Technologies on 20/03/2020.
//  Copyright © 2020 freetek. All rights reserved.
//

import Foundation
 
 struct CountryStatsModel:Decodable {
    let lastUpdate: String
    let country: String
    let province: String
    let confirmed: Int
    let deaths: Int
    let recovered: Int
    
    
    init(lastUpdate: String, country: String, province: String, confirmed: Int, deaths: Int,recovered: Int){
        self.lastUpdate = lastUpdate
        self.country = country
        self.province = province
        self.confirmed = confirmed
        self.deaths = deaths
        self.recovered = recovered
    }
    
    
    
 }
