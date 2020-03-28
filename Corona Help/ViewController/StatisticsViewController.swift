//
//  StatisticsViewController.swift
//  Corona Help
//
//  Created by Botosoft Technologies on 20/03/2020.
//  Copyright © 2020 freetek. All rights reserved.
//

import UIKit
import Foundation

class StatisticsViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDelegate, UITableViewDataSource {
    


    @IBOutlet weak var total: UILabel!
    @IBOutlet weak var totalCasesToday: UILabel!
    @IBOutlet weak var deathsToday: UILabel!
    @IBOutlet weak var recovered: UILabel!
    
    
    @IBOutlet weak var searchCountry: UITextField!
    @IBOutlet weak var search: UIButton!
    @IBOutlet weak var country: UILabel!
    @IBOutlet weak var totalSearch: UILabel!
    @IBOutlet weak var todaySearch: UILabel!
    @IBOutlet weak var recoveredSearch: UILabel!
    @IBOutlet weak var deathsSearch: UILabel!
    
    
    
    @IBOutlet weak var icon1: UIImageView!
    @IBOutlet weak var icon2: UIImageView!
    @IBOutlet weak var icon3: UIImageView!
    @IBOutlet weak var icon4: UIImageView!
    
    
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    
    let thePicker = UIPickerView()
    
    var countryCode = "None"
    
    let countriesList = [String](arrayLiteral: "Afghanistan","Albania","Algeria","Angola","Argentina","Armenia","Australia","Austria","Azerbaijan","Bahamas","Bangladesh","Belarus","Belgium","Belize","Benin","Bhuta","Bolivia","Bosnia and Herzegovina","Botswana","Brazil","Brunei Darussalam","Bulgaria","Burkina Faso","Burundi","Cambodia","Cameroon","Canada","Ivory Coast","Central African Republic","Chad","Chile","China","Colombia","Congo","Democratic Republic of Congo","Costa Rica","Croatia","Cuba","Cyprus","Czech Republic","Denmark","Diamond Princess","Djibouti","Dominican Republic","DR Congo","Ecuador","Egypt","El Salvador","Equatorial Guinea","Eritrea","Estonia","Ethiopia","Falkland Islands","Fiji","Finland","France","French Guiana","French Southern Territories","Gabon","Gambia","Georgia","Germany","Ghana","Greece","Greenland","Guatemala","Guinea","Guinea-Bissau","Guyana","Haiti","Honduras","Hong Kong","Hungary","Iceland","India","Indonesia","Iran","Iraq","Ireland","Israel","Italy","Jamaica","Japan","Jordan","Kazakhstan","Kenya","Korea","Kosovo","Kuwait","Kyrgyzstan","Lao","Latvia","Lebanon","Lesotho","Liberia","Libya","Lithuania","Luxembourg","Macedonia","Madagascar","Malawi","Malaysia","Mali","Mauritania","Mexico","Moldova","Mongolia","Montenegro","Morocco","Mozambique","Myanmar","Namibia","Nepal","Netherlands","New Caledonia","New Zealand","Nicaragua","Niger","Nigeria","North Korea","Norway","Oman","Pakistan","Palestine","Panama","Papua New Guinea","Paraguay","Peru","Philippines","Poland","Portugal","Puerto Rico","Qatar","Republic of Kosovo","Romania","Russia","Rwanda","Saudi Arabia","Senegal","Serbia","Sierra Leone","Singapore","Slovakia","Slovenia","Solomon Islands","Somalia","South Africa","South Korea","South Sudan","Spain","Sri Lanka","Sudan","Suriname","Svalbard and Jan Mayen","Swaziland","Sweden","Switzerland","Syrian Arab Republic","Taiwan","Tajikistan","Tanzania","Thailand","Timor-Leste","Togo","Trinidad and Tobago","Tunisia","Turkey","Turkmenistan","UAE","Uganda","United Kingdom","Ukraine","USA","Uruguay","Uzbekistan","Vanuatu","Venezuela","Vietnam","Western Sahara","Yemen","Zambia","Zimbabwe")
    
    let countriesCode = [String](arrayLiteral: "AF", "AL", "DZ", "AO", "AR", "AM", "AU", "AT", "AZ", "BS", "BD", "BY", "BE", "BZ", "BJ", "BT", "BO", "BA", "BW", "BR", "BN", "BG", "BF", "BI", "KH", "CM", "CA", "CI", "CF", "TD", "CL", "CN", "CO", "CG", "CD", "CR", "HR", "CU", "CY", "CZ", "DK", "DP", "DJ", "DO", "CD", "EC", "EG", "SV", "GQ", "ER", "EE", "ET", "FK", "FJ", "FI", "FR", "GF", "TF", "GA", "GM", "GE", "DE", "GH", "GR", "GL", "GT", "GN", "GW", "GY", "HT", "HN", "HK", "HU", "IS", "IN", "ID", "IR", "IQ", "IE", "IL", "IT", "JM", "JP", "JO", "KZ", "KE", "KP", "XK", "KW", "KG", "LA", "AV", "LB", "LS", "LR", "LY", "LT", "LU", "MK", "MG", "MW", "MY", "ML", "MR", "MX", "MD", "MN", "ME", "MA", "MZ", "MN", "NA", "NP", "NL", "NC", "NZ", "NI", "NE", "NG", "KP", "NO", "OM", "PK", "PS", "PA", "PG", "PY", "PE", "PH", "PL", "PT", "PR", "QA", "XK", "RO", "RU", "RW", "SA", "SN", "RS", "SL", "SG", "SK", "SI", "SB", "SO", "ZA", "KR", "SS", "ES", "LK", "SD", "SR", "SJ", "SZ", "SE", "CH", "SY", "TW", "TJ", "TZ", "TH", "TL", "TG", "TT", "TN", "TR", "TM", "AE", "UG", "GB", "UA", "US", "UY", "UZ", "VU", "VE", "VN", "EH", "YE", "ZM", "ZW")
    
  
    
    var News = [NewsModel]()
    @IBOutlet weak var tableView: UITableView!
       
    var stats = [CountryStatsModel]()


    override func viewDidLoad() {
        super.viewDidLoad()

        setUpView()
        
    }
    
    func setUpView(){
        
        totalSearch.alpha = 0
        todaySearch.alpha = 0
        recoveredSearch.alpha = 0
        deathsSearch.alpha = 0
        country.alpha = 0
        icon1.alpha = 0
        icon2.alpha = 0
        icon3.alpha = 0
        icon4.alpha = 0

        searchCountry.inputView = thePicker
        thePicker.delegate = self
        thePicker.dataSource = self
        thePicker.tag = 1
        
        
        downloadJsonStats {
            print("successful")
        }
        
        downloadJson {
            print("successful ")
            self.tableView.reloadData()
        }
        
        tableView.alpha = 0
        //----set up activity indicator-----
        activityIndicator.center = self.view.center;
        activityIndicator.hidesWhenStopped = true;
        activityIndicator.color = UIColor.init(red: 120/255, green: 214/255, blue: 124/255, alpha: 1)
        if #available(iOS 13.0, *) {
            activityIndicator.style = UIActivityIndicatorView.Style.medium
        } else {
            // Fallback on earlier versions
        }
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        countriesList.count
    }

    func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.countriesList[row]
    }

    func pickerView( _ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        searchCountry.text = countriesList[row]
        if (countryCode != "None") {
            self.countryCode = "None"
        }
        countryCode = countriesCode[row]
        self.view.endEditing(true)

    }

    
    
    @IBAction func searchFunc(_ sender: Any) {
        if(countryCode == "None"){
            countryCode = "US"
            
        }
        
        self.view.endEditing(true)
        let jsonUrlString  = "https://thevirustracker.com/free-api?countryTotal=\(countryCode)"
        guard let url = URL(string : jsonUrlString) else {return}
        URLSession.shared.dataTask(with: url) {
            (data, response, err) in
            
            guard let data = data else {return}
            
            do{
                let fetchedData = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
            
                if fetchedData == nil{
                    //error
                }else{
                    DispatchQueue.main.async {
                               do{
                                   let fetchedData = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as! NSDictionary
                                   
                                
                                   
                                    
                                   let value = fetchedData["countrydata"] as! NSArray
                                 
                                   for _value in value{


                                       let allStats = _value as! [String : Any]
                                       let _totalCases = allStats["total_cases"] as! Int
                                       let _totalCasesToday = allStats["total_new_cases_today"] as! Int
                                       let _totalRecovered = allStats["total_recovered"] as! Int
                                       let _deathsTotal = allStats["total_deaths"] as! Int
                                       
                                       DispatchQueue.main.async {
                                        self.country.text = self.searchCountry.text
                                        self.totalSearch.text = "Total - \(_totalCases)"
                                        self.todaySearch.text = "Today - \(_totalCasesToday)"
                                        self.recoveredSearch.text = "Recovered - \(_totalRecovered)"
                                        self.deathsSearch.text = "Deaths - \(_deathsTotal)"
                                        
                                        self.country.alpha = 1
                                        self.totalSearch.alpha = 1
                                        self.todaySearch.alpha = 1
                                        self.recoveredSearch.alpha = 1
                                        self.deathsSearch.alpha = 1
                                        
                                        self.icon1.alpha = 1
                                        self.icon2.alpha = 1
                                        self.icon3.alpha = 1
                                        self.icon4.alpha = 1
                                        
                                       }
                                       

                                   }
                                   
                                   
                                   
                    
                               }catch{
                                   print("JSON error")
                               }
                            }
                }
                
            }catch{
                
            }
            
            
                 
            //print( "String(myvar0.dynamicType) -> \(type(of: data))")
            
        }.resume()
        
        
        
    }
    
    
    func downloadJsonStats(completed: @escaping  () -> ()){
        
        let jsonUrlString  = "https://thevirustracker.com/free-api?global=stats"
        guard let url = URL(string : jsonUrlString) else {return}
        URLSession.shared.dataTask(with: url) {
            (data, response, err) in
            
            guard let data = data else {return}
            
            do {
                let fetchedData = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                
                if fetchedData == nil{
                    //error with API
                    
                    
                }else{
                    DispatchQueue.main.async {
                       do{
                           let fetchedData = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as! NSDictionary
                           
                           //print(print( "String(myvar0.dynamicType) -> \(type(of: fetchedData["results"]))"))
                           
                           let value = fetchedData["results"] as! NSArray
                         
                           for _value in value{


                               let allStats = _value as! [String : Any]
                               let _totalCases = allStats["total_active_cases"] as! Int
                               let _totalCasesToday = allStats["total_new_cases_today"] as! Int
                               let _totalRecovered = allStats["total_recovered"] as! Int
                               let _deathsToday = allStats["total_new_deaths_today"] as! Int
                               let _totalSeriousCases = allStats["total_serious_cases"] as! Int
                               let _totalUnresolved = allStats["total_unresolved"] as! Int

                               DispatchQueue.main.async {
                                  self.total.text = "Total: \(_totalCases)"
                                  self.totalCasesToday.text = "Today: \(_totalCasesToday)"
                                  self.recovered.text = "Recovered: \(_totalRecovered)"
                                  self.deathsToday.text = "Deaths Today: \(_deathsToday)"
                                  
                               }
                               

                           }
                           
                           
                           
                           DispatchQueue.main.async {
                           completed()
                                                   }
                       }catch{
                           print("JSON error")
                       }
                    }
                         
                }
                
            }catch{
                
            }
            
            
            
            
            //print( "String(myvar0.dynamicType) -> \(type(of: data))")
            
        }.resume()
        
    }
    
    
    func downloadJson(completed: @escaping  () -> ()){
        let headers = [
                    "x-rapidapi-host": "covid-19-coronavirus-statistics.p.rapidapi.com",
                    "x-rapidapi-key": "f2e5562378mshfc6ba95af168154p1759c6jsna2e80e5353c4"
                ]

                let request = NSMutableURLRequest(url: NSURL(string: "https://covid-19-coronavirus-statistics.p.rapidapi.com/v1/stats")! as URL,
                                                        cachePolicy: .useProtocolCachePolicy,
                                                    timeoutInterval: 10.0)
                request.httpMethod = "GET"
                request.allHTTPHeaderFields = headers

                let session = URLSession.shared
                let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
                    if (error != nil) {
                        print(error!)
                    } else {
                        let httpResponse = response as? HTTPURLResponse
                        print(httpResponse!)
                        
                        do{
                            let fetchedData = try JSONSerialization.jsonObject(with: data!, options: .mutableLeaves)
                            
                            if fetchedData == nil{
                                //error detected
                            }else{
                                
                                do{
                                    let fetchedData = try JSONSerialization.jsonObject(with: data!, options: .mutableLeaves) as! NSDictionary
                                    
                                    let value = fetchedData["data"] as! NSDictionary
                                    let value2 = value["covid19Stats"] as! NSArray
                                    
                                    print(value2)
                                    
                                    for _value in value2{
                                        
                                        let eachCountry = _value as! [String : Any]
                                        let lastUpdate = eachCountry["lastUpdate"] as! String
                                        let country = eachCountry["country"] as! String
                                        let province = eachCountry["province"] as! String
                                        let confirmed = eachCountry["confirmed"] as! Int
                                        let deaths = eachCountry["deaths"] as! Int
                                        let recovered = eachCountry["recovered"] as! Int

                                        self.stats.append(CountryStatsModel(lastUpdate: lastUpdate, country: country, province: province, confirmed: confirmed, deaths: deaths, recovered: recovered))
                                    }
                                    
                                    
                                    
                                    DispatchQueue.main.async {
                                    completed()
                                                            }
                                }catch{
                                    print("JSON error")
                                }
                                
                                
                            }
                            
                        }catch{
                            
                        }
                        
                        
                        
                        
                        
                        

                        
                    }
                })

                dataTask.resume()
                //reloading the tableview
                
        
        
    }
        
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
      {
          return 1
      }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stats.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "statsCell", for: indexPath) as! StatsTableViewCell
               
        let item: CountryStatsModel
        item = stats[indexPath.row]
        
        // Stop and hide indicator
        self.activityIndicator.stopAnimating()
        self.activityIndicator.isHidden = true
        tableView.alpha = 1
        
        if(item.province.isEmpty){
            cell.country.text = item.country
        }else{
            cell.country.text = item.country + " : " + item.province
        }
        
        cell.confirmed.text = "Confirmed- \(item.confirmed)"
        cell.recovered.text = "Recovered- \(item.recovered)"
        cell.deaths.text = "Deaths- \(item.deaths)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    
    //get clicked item
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }

}
