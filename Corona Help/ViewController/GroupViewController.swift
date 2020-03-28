//
//  GroupViewController.swift
//  Corona Help
//
//  Created by Botosoft Technologies on 21/03/2020.
//  Copyright © 2020 freetek. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class GroupViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    var refList: DatabaseReference!
    var refLastWash: DatabaseReference!
    
    @IBOutlet weak var back: UIButton!
    @IBOutlet weak var add: UIButton!
    @IBOutlet weak var tableView: UITableView!
    var friendList = [FriendModel]()
    
    var missedInterval: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         fetchFriends()
         setUpView()
         
    }
    
    func setUpView(){
        //remove empty table views
        tableView.tableFooterView = UIView()
        tableView.alpha = 1
        
        
        //reloading the tableview
         self.tableView.reloadData()
        
        //----set up activity indicator-----
        activityIndicator.center = self.view.center;
        activityIndicator.hidesWhenStopped = true;
        
        if #available(iOS 13.0, *) {
            activityIndicator.style = UIActivityIndicatorView.Style.medium
        } else {
            // Fallback on earlier versions
        }
        
        self.navigationController?.navigationBar.barTintColor = UIColor.init(red: 120/255, green: 214/255, blue: 124/255, alpha: 1)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: makeBackButton())
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: makeAddButton())
        
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            friendList.count
        
        }
        
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

            
        let cell = tableView.dequeueReusableCell(withIdentifier: "friendCell", for: indexPath) as! FriendTableViewCell

        let item: FriendModel
        item = friendList[indexPath.row]

        cell.setFriend(friend: item)
            
        print("check here-----------")
        print(item.name)
        print(item.lastWash)
            
            
            
        // Stop and hide indicator
        self.activityIndicator.stopAnimating()
        self.activityIndicator.isHidden = true
        tableView.alpha = 1

        cell.friendName.text = item.name
        getLastWashText(lastWash: item.name) { (result) in
            if( result == 1){
                cell.lastWashTime.text = "Possibly asleep"
                cell.lastWashIcon.image = UIImage(named: "icons8-sleeping_in_bed")
            }else if(result == 2){
                cell.lastWashTime.text = "Possibly asleep"
                cell.lastWashIcon.image = UIImage(named: "icons8-sleeping_in_bed")
            }else if(result == 3){
                cell.lastWashTime.text = "Missed \(Int(self.missedInterval)) washes"
                cell.lastWashIcon.image = UIImage(named: "icons8-error")
            }else if(result == 4){
                cell.lastWashTime.text = "Missed \(Int(self.missedInterval)) washes"
                cell.lastWashIcon.image = UIImage(named: "icons8-error")
            }else if(result == 5){
                cell.lastWashTime.text = "No missed washes"
                cell.lastWashIcon.image = UIImage(named: "icons8-time_machine")
            }else if(result == 6){
                cell.lastWashTime.text = "No missed washes"
                cell.lastWashIcon.image = UIImage(named: "icons8-time_machine")
            }
        }
    
        cell.cellDelegate = self
            
        return cell

    }
        
    
    func getLastWashText(lastWash: String, completion: @escaping (Int) -> Void){
        
        let userID = Auth.auth().currentUser?.uid
            let refUser = Database.database().reference().child("users").child(userID!)
            
            //check if we are in the night
            let currentDate = Date()
            let _calendar = Calendar.current
            let _currentDate = _calendar.date(byAdding: .minute, value: 0, to: currentDate)
            
            let components = _calendar.dateComponents([.year,.month,.day,.hour,.minute,.second], from: currentDate)
            
            
        
            if(components.hour! > 20 && components.hour! <= 24){
                //night
                completion(1)
                
                
            }else if(components.hour! >= 0 && components.hour! <= 6){
                //morning
                completion(2)
            }else{
                //day
                refUser.observeSingleEvent(of: .value, with: { (snapshot) in

                    if snapshot.hasChild("last_wash_date"){
                       
                       //recordWashTime to central user_info db
                       let userID = Auth.auth().currentUser?.uid
                       let refWashTime = Database.database().reference().child("users").child(userID!)
                       refWashTime.observeSingleEvent(of: .value){
                       (snapshot) in
                                                      
                           let data = snapshot.value as? [String:Any]
                           let last_wash = (data?["last_wash_date"])
                           
                           //last wash time + 45 min
                           
                           let dateFormatter = DateFormatter()
                           dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                           let date = dateFormatter.date(from:last_wash as! String)!
                           
                           let _componentsLastWash = _calendar.dateComponents([.year, .month, .day, .hour], from: date)
                        
                        
                           let calendar = Calendar.current
                           let _lastWashDate = calendar.date(byAdding: .minute, value: 60, to: date)
                           let _lastWashDate2 = calendar.date(byAdding: .minute, value: 105, to: date)
                           //check if he has a missing wash
                           
                       
                           var timeInterval = _currentDate!.timeIntervalSince(_lastWashDate!)

                        
                        
                        
                        
                        //current day and last wash day differ
                        if ((components.day as! Int != _componentsLastWash.day as! Int && components.month as! Int != _componentsLastWash.month as! Int) || components.day as! Int != _componentsLastWash.day as! Int ){
                            
                            if (components.hour as! Int >= 7){
                                //past 7am today, last wash was yesterday or later
                                
                                
                                
                                
                                let dateFormatter = DateFormatter()
                                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                                let date = dateFormatter.date(from: "\((components.year) as! Int)-\((components.month) as! Int)-\((components.day) as! Int) 7:00:00")!
                                
                                let _componentsLastWash = _calendar.dateComponents([.year, .month, .day, .hour], from: date)
                                
                                 
                                let year = _componentsLastWash.year
                                let month = _componentsLastWash.month
                                let day = _componentsLastWash.day
                                let hour = _componentsLastWash.hour
                                let minute = _componentsLastWash.minute
                                let second = _componentsLastWash.second

                                let today_string = String(year!) + "-" + String(month!) + "-" + String(day!) + " " + String(hour!)  + ":00:00"
                                
                                
                                let userID = Auth.auth().currentUser?.uid
                                let refWashTime = Database.database().reference().child("users").child(userID!)
                                refWashTime.child("last_wash_date").setValue(today_string)
                                
                                let calendar = Calendar.current
                                let new_lastWashDate = calendar.date(byAdding: .minute, value: 0, to: date)
                                
                                timeInterval = _currentDate!.timeIntervalSince(new_lastWashDate!)
                                print(timeInterval)
                                
                            }
                            
                            
                            }
                        
                           //user has missed some wash
                           if(timeInterval > 2700){
                               
                               if (Int(timeInterval / 2700) > 1){
                                   self.missedInterval = Int(timeInterval / 2700)
                                   completion(3)
                                
                
                               }else{
                                   self.missedInterval = Int(timeInterval / 2700)
                                   completion(4)
                                   
                               }

                           }//user has not missed any
                           
                           else{
                               let components = _calendar.dateComponents([.year,.month,.day,.hour,.minute,.second], from: _lastWashDate2!)
                               self.missedInterval = Int(timeInterval / 2700)
                               completion(5)
                           }
                           
                       }
                       

                    }else{
                        
                       completion(6)
                    }


                })
            }
            
            
            
        
        
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
        

    //get clicked item
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            

    }
    
    
    func makeBackButton() -> UIButton {
        let backButtonImage = UIImage(named: "back.png")?.withRenderingMode(.alwaysTemplate)
        let backButton = UIButton(type: .custom)
        backButton.setImage(backButtonImage, for: .normal)
        backButton.tintColor = .white
        backButton.setTitle("  Back", for: .normal)
        backButton.setTitleColor(.white, for: .normal)
        backButton.addTarget(self, action: #selector(self.backButtonPressed), for: .touchUpInside)
        return backButton
    }
    
    
    func makeAddButton() -> UIButton {
        let backButtonImage = UIImage(named: "icons8-add_new.png")?.withRenderingMode(.alwaysTemplate)
        let backButton = UIButton(type: .custom)
        backButton.setImage(backButtonImage, for: .normal)
        backButton.tintColor = .white
        backButton.setTitle("  Add Contact", for: .normal)
        backButton.setTitleColor(.white, for: .normal)
        backButton.addTarget(self, action: #selector(self.addButtonPressed), for: .touchUpInside)
        return backButton
    }

    @objc func backButtonPressed() {
        self.performSegue(withIdentifier: "backFromFriends", sender: nil)
        
        
    }
    
    @objc func addButtonPressed() {
        self.performSegue(withIdentifier: "addContactsMove", sender: nil)
        
        
    }
    
    func fetchFriends(){
        //fetch all friend itmes
        let userID = Auth.auth().currentUser?.uid
        
        refList = Database.database().reference().child("users").child(userID!).child("friends");
        refList.observe(.value, with: {
            (snapshot) in
            //clearing the list
            self.friendList.removeAll()
            //iterating through all the values
            for item in snapshot.children.allObjects as! [DataSnapshot] {
                //getting values
                let itemObject = item.value as? [String: AnyObject]
                let _name  = itemObject?["name"]
                let _phone  = itemObject?["phone"]
               
                //get last wash time
                let phoneKey = _phone as! String
                

                let ref = Database.database().reference().child("user_info").child(phoneKey.replacingOccurrences(of: " ", with: "") )

                ref.observeSingleEvent(of: .value){
                    (snapshot) in
                                                   
                    let data = snapshot.value as? [String:Any]
                    let lastWash = (data?["last_wash_date"])
                    
                    //creating itemGotten object with model and fetched values
                    let itemGotten = FriendModel(name: _name as! String, number: _phone as! String, lastWash: lastWash as! String)
                    
                    //appending it to list
                    //print(itemGotten)
                    self.friendList.append(itemGotten)
                    self.tableView.reloadData()
                }
                
            }
           
        })
        
    }
    
    
    @IBAction func back(_ sender: Any) {
        self.performSegue(withIdentifier: "backFromFriends", sender: nil)
    }
    
    
    @IBAction func addFriend(_ sender: Any) {
        self.performSegue(withIdentifier: "addContactsMove", sender: nil)
    }
    
    
}



extension GroupViewController: FriendCellDelegate {

    func onClickWhatsapp(name: String,phone: String, lastWash: String) {
        let urlWhats = "whatsapp://send?phone=\(phone)&text=Hi \(name) your last wash was \(lastWash) you should wash your hands, stay safe"

        var characterSet = CharacterSet.urlQueryAllowed
         characterSet.insert(charactersIn: "?&")

         if let urlString = urlWhats.addingPercentEncoding(withAllowedCharacters: characterSet){

         if let whatsappURL = NSURL(string: urlString) {
                           if UIApplication.shared.canOpenURL(whatsappURL as URL){
                               UIApplication.shared.openURL(whatsappURL as URL)
                           }
                           else {
                               createAlert2(title: "Ooops", message: "You dont have whatsapp installed")

                           }
                       }
                   }
        
    }
    
    
    func onClickCall(name: String, phone: String, lastWash: String) {
        guard let number = URL(string: "tel://" + phone) else { return }
        UIApplication.shared.open(number)
        
    }
    
    
    func onClickMessage(name: String,phone: String, lastWash: String) {
        let sms: String = "sms:\(phone)&body=Hi \(name) your last wash was \(lastWash) you should wash your hands, stay safe"
        let strURL: String = sms.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        UIApplication.shared.open(URL.init(string: strURL)!, options: [:], completionHandler: nil)
        
    }
    
    
    func createAlert2(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: { (cancel) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
        
    }
}
