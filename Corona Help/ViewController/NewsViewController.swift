//
//  NewsViewController.swift
//  Corona Help
//
//  Created by Botosoft Technologies on 21/03/2020.
//  Copyright © 2020 freetek. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import CoreLocation
import Lottie

class NewsViewController: UIViewController , UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate{
    
    
    let locationManager = CLLocationManager()
    var latitude = ""
    var longitude = ""

    @IBOutlet weak var imageHeader: UIImageView!
    @IBOutlet weak var Headline: UILabel!
    
    @IBOutlet weak var selectCountry: UITextField!
    @IBOutlet weak var search: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    var News = [NewsModel]()
    
    let animationViewApiDown = AnimationView()
    let animationView1 = AnimationView()

    
    var _totalCases : Int!
    var _totalCasesToday : Int!
    var _totalRecovered : Int!
    var _deathsToday : Int!
    var _totalSeriousCases : Int!
    var _totalUnresolved : Int!
    var countryCode = "None"
    var goToLink = ""
    
    
                     
    
    let thePicker = UIPickerView()
    let countriesList = [String](arrayLiteral: "Afghanistan","Albania","Algeria","Angola","Argentina","Armenia","Australia","Austria","Azerbaijan","Bahamas","Bangladesh","Belarus","Belgium","Belize","Benin","Bhuta","Bolivia","Bosnia and Herzegovina","Botswana","Brazil","Brunei Darussalam","Bulgaria","Burkina Faso","Burundi","Cambodia","Cameroon","Canada","Ivory Coast","Central African Republic","Chad","Chile","China","Colombia","Congo","Democratic Republic of Congo","Costa Rica","Croatia","Cuba","Cyprus","Czech Republic","Denmark","Diamond Princess","Djibouti","Dominican Republic","DR Congo","Ecuador","Egypt","El Salvador","Equatorial Guinea","Eritrea","Estonia","Ethiopia","Falkland Islands","Fiji","Finland","France","French Guiana","French Southern Territories","Gabon","Gambia","Georgia","Germany","Ghana","Greece","Greenland","Guatemala","Guinea","Guinea-Bissau","Guyana","Haiti","Honduras","Hong Kong","Hungary","Iceland","India","Indonesia","Iran","Iraq","Ireland","Israel","Italy","Jamaica","Japan","Jordan","Kazakhstan","Kenya","Korea","Kosovo","Kuwait","Kyrgyzstan","Lao","Latvia","Lebanon","Lesotho","Liberia","Libya","Lithuania","Luxembourg","Macedonia","Madagascar","Malawi","Malaysia","Mali","Mauritania","Mexico","Moldova","Mongolia","Montenegro","Morocco","Mozambique","Myanmar","Namibia","Nepal","Netherlands","New Caledonia","New Zealand","Nicaragua","Niger","Nigeria","North Korea","Norway","Oman","Pakistan","Palestine","Panama","Papua New Guinea","Paraguay","Peru","Philippines","Poland","Portugal","Puerto Rico","Qatar","Republic of Kosovo","Romania","Russia","Rwanda","Saudi Arabia","Senegal","Serbia","Sierra Leone","Singapore","Slovakia","Slovenia","Solomon Islands","Somalia","South Africa","South Korea","South Sudan","Spain","Sri Lanka","Sudan","Suriname","Svalbard and Jan Mayen","Swaziland","Sweden","Switzerland","Syrian Arab Republic","Taiwan","Tajikistan","Tanzania","Thailand","Timor-Leste","Togo","Trinidad and Tobago","Tunisia","Turkey","Turkmenistan","UAE","Uganda","United Kingdom","Ukraine","USA","Uruguay","Uzbekistan","Vanuatu","Venezuela","Vietnam","Western Sahara","Yemen","Zambia","Zimbabwe")
    
    let countriesCode = [String](arrayLiteral: "AF", "AL", "DZ", "AO", "AR", "AM", "AU", "AT", "AZ", "BS", "BD", "BY", "BE", "BZ", "BJ", "BT", "BO", "BA", "BW", "BR", "BN", "BG", "BF", "BI", "KH", "CM", "CA", "CI", "CF", "TD", "CL", "CN", "CO", "CG", "CD", "CR", "HR", "CU", "CY", "CZ", "DK", "DP", "DJ", "DO", "CD", "EC", "EG", "SV", "GQ", "ER", "EE", "ET", "FK", "FJ", "FI", "FR", "GF", "TF", "GA", "GM", "GE", "DE", "GH", "GR", "GL", "GT", "GN", "GW", "GY", "HT", "HN", "HK", "HU", "IS", "IN", "ID", "IR", "IQ", "IE", "IL", "IT", "JM", "JP", "JO", "KZ", "KE", "KP", "XK", "KW", "KG", "LA", "AV", "LB", "LS", "LR", "LY", "LT", "LU", "MK", "MG", "MW", "MY", "ML", "MR", "MX", "MD", "MN", "ME", "MA", "MZ", "MN", "NA", "NP", "NL", "NC", "NZ", "NI", "NE", "NG", "KP", "NO", "OM", "PK", "PS", "PA", "PG", "PY", "PE", "PH", "PL", "PT", "PR", "QA", "XK", "RO", "RU", "RW", "SA", "SN", "RS", "SL", "SG", "SK", "SI", "SB", "SO", "ZA", "KR", "SS", "ES", "LK", "SD", "SR", "SJ", "SZ", "SE", "CH", "SY", "TW", "TJ", "TZ", "TH", "TL", "TG", "TT", "TN", "TR", "TM", "AE", "UG", "GB", "UA", "US", "UY", "UZ", "VU", "VE", "VN", "EH", "YE", "ZM", "ZW")
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let bundleID = Bundle.main.bundleIdentifier
        print("This is your bundle id \(bundleID)")
        setUpView()
        setUpHeader()
        getLocation()
        
    }
    
    func getLocation(){
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled(){
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
    }
    
    func locationManager(_ manager:CLLocationManager, didUpdateLocations locations: [CLLocation]){
        guard let locationValue: CLLocationCoordinate2D = manager.location?.coordinate else{
            return
        }
        
        
        longitude = String(locationValue.longitude)
        latitude = String(locationValue.latitude)
        
        updateCurrentUsersData()
        
        

    }
    
    
    func updateCurrentUsersData(){
        
        
        
        let userId = Auth.auth().currentUser?.uid
    
        
        let ref1 = Database.database().reference().child("users").child(userId!).child("last_login")
        ref1.setValue(getTodayString()) { (err, resp) in
            guard err == nil else {
                print("Posting failed : ")
                //print(err)

                return
            }
            print("No errors while posting, :")
            print(resp)
        }
        
        
        let ref2 = Database.database().reference().child("users").child(userId!).child("location")
        ref2.child("longitude").setValue(getTodayString()) { (err, resp) in
            guard err == nil else {
                print("Posting failed : ")
                return
            }
            print("No errors while posting, :")
            print(resp)
        }
        
        ref2.child("latitude").setValue(getTodayString()) { (err, resp) in
            guard err == nil else {
                print("Posting failed : ")
                return
            }
            print("No errors while posting, :")
            print(resp)
        }
        
        
    
        
    }
    
    
    
    func setUpHeader(){
        let refAds = Database.database().reference().child("center_news")
        
        
        refAds.observeSingleEvent(of: .value){
            (snapshot) in
            let data = snapshot.value as? [String:Any]
            let Headline = (data?["Headline"])
            let link = (data?["goto"])
            let imageUrl = (data?["image"])
            
            
            self.goToLink = (link as? String)!
            self.Headline.text = (Headline as? String)!
            self.Headline.alpha = 1
            let url = URL(string: imageUrl as! String)
            let data1 = try? Data(contentsOf: url!)

                    if let imageData = data1 {
                        let image = UIImage(data: imageData)
                        self.imageHeader.image = image
                    }
            
        }
        
        
    }
    
    
    func setUpView(){
        //set up loaders
        animationViewApiDown.alpha = 0
        
        self.animationView1.alpha = 1
        self.animationView1.animation = Animation.named("lf30_editor_WqPUUE")
        self.animationView1.frame = CGRect(x:0, y:0, width: 150, height: 150)
        self.animationView1.center = self.view.center
        self.animationView1.contentMode = .scaleAspectFit
        self.animationView1.loopMode = .loop
        self.animationView1.play()
        self.view.addSubview(self.animationView1)
        
        
        selectCountry.inputView = thePicker
        thePicker.delegate = self
        thePicker.dataSource = self
        thePicker.tag = 1
        
        
        countryCode = "US"
        downloadJson2 {
            print("successful")
            self.tableView.reloadData()
            

        }
        
        tableView.alpha = 0
      
        
        
        tableView.delegate = self
        tableView.dataSource = self
        
        
        // Do any additional setup after loading the view.
        
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        imageHeader.isUserInteractionEnabled = true
        imageHeader.addGestureRecognizer(tapGestureRecognizer)
        
        tableView.tableFooterView = UIView()
        
        
        
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        _ = tapGestureRecognizer.view as! UIImageView

        // Your action
        if goToLink.isEmpty == false{
            if let url = URL(string: goToLink) {
                UIApplication.shared.open(url)
            }
        }
    }


 
    func downloadJson2(completed: @escaping  () -> ()){
        
        if (countryCode == "US"){
            let jsonUrlString  = "https://thevirustracker.com/free-api?countryTotal=US"
                    guard let url = URL(string : jsonUrlString) else {return}
                    URLSession.shared.dataTask(with: url) {
                        (data, response, err) in
                        
                        guard let data = data else {return}
                        let dataAsString  = String(data: data, encoding: .utf8)
                        
                        print("Statement 1 \(dataAsString)")
                        
                        
                        do{
                           let fetchedData = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                        
                            if  fetchedData == nil{
                                
                                self.animationView1.alpha = 0
                                self.animationView1.stop()
                                self.tableView.alpha = 0
                                
                                self.animationViewApiDown.alpha = 1
                                self.animationViewApiDown.animation = Animation.named("47-gears")
                                self.animationViewApiDown.frame = CGRect(x:0, y:0, width: 150, height: 150)
                                self.animationViewApiDown.center = self.view.center
                                self.animationViewApiDown.contentMode = .scaleAspectFit
                                self.animationViewApiDown.loopMode = .loop
                                self.animationViewApiDown.play()
                                self.view.addSubview(self.animationViewApiDown)
                                
                            }else{
                                
                                DispatchQueue.main.async {
                                    do{
                                        let fetchedData = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as! NSDictionary
                                        
                                        
                                        print( "----------------------------)")
                                
                                            if fetchedData["countrynewsitems"] ==  nil{
                                                self.tableView.alpha = 0
                                                self.animationView1.alpha = 0
                                                self.animationView1.stop()
                                                self.animationViewApiDown.alpha = 1
                                                self.animationViewApiDown.animation = Animation.named("47-gears")
                                                self.animationViewApiDown.frame = CGRect(x:0, y:0, width: 150, height: 150)
                                                self.animationViewApiDown.center = self.view.center
                                                self.animationViewApiDown.contentMode = .scaleAspectFit
                                                self.animationViewApiDown.loopMode = .loop
                                                self.animationViewApiDown.play()
                                                self.view.addSubview(self.animationViewApiDown)
                                                
                                                
                                                
                                                
                                            }else{
                                                let value =  fetchedData["countrynewsitems"] as! NSArray
                                                 
                                                 for _value in value{
                                                     let eachCountry = _value as! [String : Any]
                                                     
                                                     for (_, value) in eachCountry{
                                                         var _title = ""
                                                         var _time = ""
                                                         var _image = ""
                                                         var _url = ""
                                                         
                                                         let check = "\(type(of: value))"
                                                         if check == "__NSDictionaryI" {
                                                             for (key1, value1) in value as! NSDictionary{
                                                                 
                                                                 if key1 as! String == "title"{
                                                                     _title = value1 as! String
                                                                 }
                                                                 
                                                                 if key1 as! String == "image"{
                                                                     _image = value1 as! String
                                                                     
                                                                 }
                                                                 
                                                                 if key1 as! String == "time"{
                                                                     _time = value1 as! String
                                                                 }
                                                             
                                                                 if key1 as! String == "url"{
                                                                     _url = value1 as! String
                                                                 }
                                                             
                                                             }
                                                         }
                                                         
                                                         
                                                         _title = _title.replacingOccurrences(of: "&Isquo;", with: " ")
                                                         _title = _title.replacingOccurrences(of: "&lsquo;", with: " ")
                                                         _title = _title.replacingOccurrences(of: "&Lsquo;", with: " ")
                                                         _title = _title.replacingOccurrences(of: "&isquo;", with: " ")
                                                         _title = _title.replacingOccurrences(of: "&rsquo;", with: " ")
                                                         _title = _title.replacingOccurrences(of: "&rsquo;s", with: " ")
                                                         _title = _title.replacingOccurrences(of: "&Isquo;s;", with: " ")
                                                         _title = _title.replacingOccurrences(of: "&Isquo;s;", with: " ")
                                                         _title = _title.replacingOccurrences(of: "&Isquo", with: " ")
                                                         _title = _title.replacingOccurrences(of: "&rsquo", with: " ")
                                                         _title = _title.replacingOccurrences(of: "&mdash;", with: " ")
                                                         _title = _title.replacingOccurrences(of: "&mdash;", with: " ")
                                                         _title = _title.replacingOccurrences(of: "R&#233;", with: " ")
                                                         _title = _title.replacingOccurrences(of: "R&#233;s", with: " ")
                                                         _title = _title.replacingOccurrences(of: "R&#233", with: " ")
                                                         _title = _title.replacingOccurrences(of: "&ndash;", with: " ")
                                                         _title = _title.replacingOccurrences(of: "&ndash;s", with: " ")
                                                         _title = _title.replacingOccurrences(of: "&amp;", with: " ")
                                                         _title = _title.replacingOccurrences(of: "&ndash;", with: " ")
                                                         _title = _title.replacingOccurrences(of: "&#163;6k", with: " ")

                                                         
                                                         self.News.append(NewsModel(title: _title, image: _image, time: _time, url: _url))
                                                     }

                                                
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
                        
                        
                        
                        
                            
                            
                        
                    }.resume()
            }else{
                
                News = [NewsModel]()
            
                let jsonUrlString  = "https://thevirustracker.com/free-api?countryTotal=\(countryCode)"
                guard let url = URL(string : jsonUrlString) else {return}
                URLSession.shared.dataTask(with: url) {
                    (data, response, err) in
                    
                    guard let data = data else {return}
                    
                    let dataAsString  = String(data: data, encoding: .utf8)
                    
                    print(dataAsString)
                    
                    
                    do{
                       let fetchedData = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                    
                        if  fetchedData == nil{
                            
                            self.tableView.alpha = 0
                            self.animationView1.alpha = 0
                            self.animationView1.stop()
                            
                            self.animationViewApiDown.alpha = 1
                            self.animationViewApiDown.animation = Animation.named("47-gears")
                            self.animationViewApiDown.frame = CGRect(x:0, y:0, width: 150, height: 150)
                            self.animationViewApiDown.center = self.view.center
                            self.animationViewApiDown.contentMode = .scaleAspectFit
                            self.animationViewApiDown.loopMode = .loop
                            self.animationViewApiDown.play()
                            self.view.addSubview(self.animationViewApiDown)
                            
                        }else{
                            
                            DispatchQueue.main.async {
                                do{
                                    let fetchedData = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as! NSDictionary
                                    
                                    
                                    print( "----------------------------)")
                            
                                        if fetchedData["countrynewsitems"] ==  nil{
                                            self.tableView.alpha = 0
                                            self.animationView1.alpha = 0
                                            self.animationView1.stop()
                                            self.animationViewApiDown.alpha = 1
                                            self.animationViewApiDown.animation = Animation.named("47-gears")
                                            self.animationViewApiDown.frame = CGRect(x:0, y:0, width: 150, height: 150)
                                            self.animationViewApiDown.center = self.view.center
                                            self.animationViewApiDown.contentMode = .scaleAspectFit
                                            self.animationViewApiDown.loopMode = .loop
                                            self.animationViewApiDown.play()
                                            self.view.addSubview(self.animationViewApiDown)
                                            
                                            
                                            
                                            
                                        }else{
                                            let value =  fetchedData["countrynewsitems"] as! NSArray
                                             
                                             for _value in value{
                                                 let eachCountry = _value as! [String : Any]
                                                 
                                                 for (_, value) in eachCountry{
                                                     var _title = ""
                                                     var _time = ""
                                                     var _image = ""
                                                     var _url = ""
                                                     
                                                     let check = "\(type(of: value))"
                                                     if check == "__NSDictionaryI" {
                                                         for (key1, value1) in value as! NSDictionary{
                                                             
                                                             if key1 as! String == "title"{
                                                                 _title = value1 as! String
                                                             }
                                                             
                                                             if key1 as! String == "image"{
                                                                 _image = value1 as! String
                                                                 
                                                             }
                                                             
                                                             if key1 as! String == "time"{
                                                                 _time = value1 as! String
                                                             }
                                                         
                                                             if key1 as! String == "url"{
                                                                 _url = value1 as! String
                                                             }
                                                         
                                                         }
                                                     }
                                                     
                                                     
                                                     _title = _title.replacingOccurrences(of: "&Isquo;", with: " ")
                                                     _title = _title.replacingOccurrences(of: "&lsquo;", with: " ")
                                                     _title = _title.replacingOccurrences(of: "&Lsquo;", with: " ")
                                                     _title = _title.replacingOccurrences(of: "&isquo;", with: " ")
                                                     _title = _title.replacingOccurrences(of: "&rsquo;", with: " ")
                                                     _title = _title.replacingOccurrences(of: "&rsquo;s", with: " ")
                                                     _title = _title.replacingOccurrences(of: "&Isquo;s;", with: " ")
                                                     _title = _title.replacingOccurrences(of: "&Isquo;s;", with: " ")
                                                     _title = _title.replacingOccurrences(of: "&Isquo", with: " ")
                                                     _title = _title.replacingOccurrences(of: "&rsquo", with: " ")
                                                     _title = _title.replacingOccurrences(of: "&mdash;", with: " ")
                                                     _title = _title.replacingOccurrences(of: "&mdash;", with: " ")
                                                     _title = _title.replacingOccurrences(of: "R&#233;", with: " ")
                                                     _title = _title.replacingOccurrences(of: "R&#233;s", with: " ")
                                                     _title = _title.replacingOccurrences(of: "R&#233", with: " ")
                                                     _title = _title.replacingOccurrences(of: "&ndash;", with: " ")
                                                     _title = _title.replacingOccurrences(of: "&ndash;s", with: " ")
                                                     _title = _title.replacingOccurrences(of: "&amp;", with: " ")
                                                     _title = _title.replacingOccurrences(of: "&ndash;", with: " ")
                                                     _title = _title.replacingOccurrences(of: "&#163;6k", with: " ")

                                                     
                                                     self.News.append(NewsModel(title: _title, image: _image, time: _time, url: _url))
                                                 }


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
                    
                    
                          
                    }.resume()
          
                }
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
        selectCountry.text = countriesList[row]
        if (countryCode != "None") {
            self.countryCode = "None"
        }
        countryCode = countriesCode[row]
        self.view.endEditing(true)
        
    }
    
    
    @IBAction func searchFunction(_ sender: Any) {
        if(countryCode == "None"){
            countryCode = "US"
            
        }
        
        self.animationViewApiDown.alpha = 0
        self.animationView1.alpha = 1
        self.animationView1.animation = Animation.named("lf30_editor_WqPUUE")
        self.animationView1.frame = CGRect(x:0, y:0, width: 150, height: 150)
        self.animationView1.center = self.view.center
        self.animationView1.contentMode = .scaleAspectFit
        self.animationView1.loopMode = .loop
        self.animationView1.play()
        self.view.addSubview(self.animationView1)
        
        
        
        self.view.endEditing(true)
        self.tableView.alpha = 0
        downloadJson2{
            print("successful2")
            self.tableView.reloadData()
            self.animationView1.stop()
            self.animationView1.alpha = 0
            self.tableView.alpha = 1
            
            
            
            
        }
        
            
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return News.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "newsCell", for: indexPath) as! NewsTableViewCell
               
        let item: NewsModel
        item = News[indexPath.row]
        
        // Stop and hide indicator
        self.animationView1.stop()
        self.animationView1.alpha = 0
        
        tableView.alpha = 1
        
        
        cell.newsHeadline.text = item.title
        cell.newsDate.text = item.time
        
        //set image
        
        let url = URL(string: item.image as! String)
        let data1 = try? Data(contentsOf: url!)

                if let imageData = data1 {
                    let image = UIImage(data: imageData)
                    cell.newsImage.image = image
                }
        
        
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
    
    //get clicked item
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item: NewsModel
        item = News[indexPath.row]
        
        createAlert(title: "Proceed", message: "Open in browser", url: item.url)
            
        
    }
    
    
    func createAlert(title: String, message: String, url: String){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: { (agree) in
            if let url = URL(string: url) {
                UIApplication.shared.open(url)
            }
            
        }))
        alert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.default, handler: { (cancel) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    func getTodayString() -> String{

        let date = Date()
        let calender = Calendar.current
        let components = calender.dateComponents([.year,.month,.day,.hour,.minute,.second], from: date)

        let year = components.year
        let month = components.month
        let day = components.day
        let hour = components.hour
        let minute = components.minute
        let second = components.second

        let today_string = String(year!) + "-" + String(month!) + "-" + String(day!) + " " + String(hour!)  + ":" + String(minute!) + ":" +  String(second!)

        return today_string

    }
    
    
    
}
