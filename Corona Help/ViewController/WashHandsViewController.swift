//
//  WashHandsViewController.swift
//  Corona Help
//
//  Created by Botosoft Technologies on 20/03/2020.
//  Copyright © 2020 freetek. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import Lottie

class WashHandsViewController: UIViewController {

    @IBOutlet weak var tapImage: UIButton!
    @IBOutlet weak var sanitizer: UIButton!
    @IBOutlet weak var nextTime: UILabel!
    @IBOutlet weak var missedWashTime: UILabel!
    @IBOutlet weak var washIcon: UIImageView!
    
    @IBOutlet weak var hand: AnimationView!
    
    
    
    let animationView2 = AnimationView()
    
    
    var refList: DatabaseReference!
    
    var center = UNUserNotificationCenter.current()
    var center1 = UNUserNotificationCenter.current()
    var center2 = UNUserNotificationCenter.current()
    var center3 = UNUserNotificationCenter.current()
    var center4 = UNUserNotificationCenter.current()
    var center5 = UNUserNotificationCenter.current()
    var content = UNMutableNotificationContent()
    
    
    var tips = ["Regularly and thoroughly clean your hands with an alcohol-based hand rub or wash them with soap and water. Why? Washing your hands with soap and water or using alcohol-based hand rub kills viruses that may be on your hands.", "Maintain at least 1 metre (3 feet) distance between yourself and anyone who is coughing or sneezing. Why? When someone coughs or sneezes they spray small liquid droplets from their nose or mouth which may contain virus. If you are too close, you can breathe in the droplets, including the COVID-19 virus if the person coughing has the disease.", "Why? Hands touch many surfaces and can pick up viruses. Once contaminated, hands can transfer the virus to your eyes, nose or mouth. From there, the virus can enter your body and can make you sick.", "Make sure you, and the people around you, follow good respiratory hygiene. This means covering your mouth and nose with your bent elbow or tissue when you cough or sneeze. Then dispose of the used tissue immediately. Why? Droplets spread virus. By following good respiratory hygiene you protect the people around you from viruses such as cold, flu and COVID-19.", "Stay home if you feel unwell. If you have a fever, cough and difficulty breathing, seek medical attention and call in advance. Follow the directions of your local health authority. Why? National and local authorities will have the most up to date information on the situation in your area. Calling in advance will allow your health care provider to quickly direct you to the right health facility. This will also protect you and help prevent spread of viruses and other infections.", "Stay informed on the latest developments about COVID-19. Follow advice given by your healthcare provider, your national and local public health authority or your employer on how to protect yourself and others from COVID-19. Why? National and local authorities will have the most up to date information on whether COVID-19 is spreading in your area. They are best placed to advise on what people in your area should be doing to protect themselves."]
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        setUpView()
        animateButtonFunc()
        
        content.title = "Time To Wash Your Hands"
        content.body = "Washing of hands reduces risk of corona virus, its time to wash your hand now, make sure you indicate it on the app, so we can remind you of the next due round"
        content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: "wash-1.mp3"))
        
        
        
    }
    
    func setUpView(){
        
        
        
        self.hand.frame = CGRect(x:0, y:0, width: 220, height: 220)
        self.hand.center = self.view.center
        
        
        let userID = Auth.auth().currentUser?.uid
        let refUser = Database.database().reference().child("users").child(userID!)
        
        //check if we are in the night
        let currentDate = Date()
        let _calendar = Calendar.current
        let _currentDate = _calendar.date(byAdding: .minute, value: 0, to: currentDate)
        
        let components = _calendar.dateComponents([.year,.month,.day,.hour,.minute,.second], from: currentDate)
        
        
    
        if(components.hour! > 20 && components.hour! <= 24){
            //night
            self.washIcon.image = UIImage(named: "icons8-sleeping_in_bed")
            self.nextTime.text? = "Possibly asleep"
            self.missedWashTime.text? = ""
        }else if(components.hour! >= 0 && components.hour! <= 6){
            //morning
            washIcon.image = UIImage(named: "icons8-sleeping_in_bed")
            self.washIcon.image = UIImage(named: "icons8-sleeping_in_bed")
            self.nextTime.text? = "Possibly asleep"
            self.missedWashTime.text? = ""
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
                           self.nextTime.text? = "Your next wash is due NOW"
                           self.missedWashTime.alpha = 1
                           if (Int(timeInterval / 2700) > 1){
                               self.missedWashTime.text? = "You missed \(Int(timeInterval / 2700)) washes"
                               self.washIcon.image = UIImage(named: "icons8-error")
                               self.missedWashTime.textColor = .red
                               
                               
                           }else{
                               self.missedWashTime.text? = "You missed \(Int(timeInterval / 2700)) wash"
                               self.washIcon.image = UIImage(named: "icons8-error")
                               let image: UIImage = UIImage(named: "icons8-error.png")!
                               self.washIcon = UIImageView(image: image)
                               self.missedWashTime.textColor = .red
                           }

                       }//user has not missed any
                       else{
                           let components = _calendar.dateComponents([.year,.month,.day,.hour,.minute,.second], from: _lastWashDate2!)
                           
                        
                           let hour = components.hour! - 1
                           let minute = components.minute!
                           self.washIcon.image = UIImage(named: "icons8-time_machine")
                           self.nextTime.text? = "Your next wash is due by \(hour):\(minute)"
                       }
                       
                   }
                   

                }else{
                    
                   let time = self.getNextWash()
                   let array = time.components(separatedBy: " ")
                   let time2 = array[1].components(separatedBy: ":")
                   
                   let currentDate = Date()
                   let _calendar = Calendar.current
                   let _currentDate = _calendar.date(byAdding: .minute, value: 0, to: currentDate)
                   
                   let components = _calendar.dateComponents([.year,.month,.day,.hour,.minute,.second], from: currentDate)
                   let day = components.day
                   let hour = components.hour
                   let minute = components.minute
                   
                   
                   if Int(minute!) > 12{
                       let today_string = String(hour!) + ":" +  String(minute!)
                       self.nextTime.text? = "\(today_string) PM"
                   }else{
                       let today_string = String(hour!) + ":" +  String(minute!)
                       self.nextTime.text? = "\(today_string) AM"
                   }
                   
                   
                   var image: UIImage = UIImage(named: "icons8-time_machine")!
                   self.washIcon = UIImageView(image: image)
                   self.nextTime.text? = "Your next wash is due \(time2[0]):\(time2[1])"
                   self.missedWashTime.alpha = 0
                   
                }


            })
        }
        
        
        missedWashTime.alpha = 0
        center.requestAuthorization(options: [.alert, .sound, .badge]){ granted, error in
            if granted {
                print("Access granted")
                
            }else{
                self.createAlert(title: "Ooops", message: "We need this permission to send you reminder notifications to wash your hands")
            }
                
        }
        
        
    }
    
    func animateButtonFunc(){
      
        
        tapImage.isUserInteractionEnabled = true
        tapImage.isEnabled = true
        
        sanitizer.isUserInteractionEnabled = true
        sanitizer.isEnabled = true

        let pulse1 = CASpringAnimation(keyPath: "transform.scale")
        pulse1.duration = 1
        pulse1.fromValue = 1.0
        pulse1.toValue = 1.12
        pulse1.autoreverses = true
        pulse1.repeatCount = 1
        pulse1.initialVelocity = 0.5
        pulse1.damping = 0.8

        let animationGroup = CAAnimationGroup()
        animationGroup.duration = 2.7
        animationGroup.repeatCount = 1000
        animationGroup.animations = [pulse1]

        tapImage.layer.add(animationGroup, forKey: "pulse")
        sanitizer.layer.add(animationGroup, forKey: "pulse")
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2){
            self.animateButtonFunc()
        }
        
        
    }
    @IBAction func tapWash(_ sender: Any) {
        
        //new
        self.animationView2.alpha = 1
        self.hand.alpha = 0
        self.animationView2.animation = Animation.named("17686-wash-your-hands-regularly")
        self.animationView2.frame = CGRect(x:0, y:0, width: 200, height: 200)
        self.animationView2.center = self.view.center
        self.animationView2.contentMode = .scaleAspectFit
        self.animationView2.loopMode = .loop
        self.animationView2.play()
        self.view.addSubview(self.animationView2)
        
        
        //Animate washing of hands
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2){
            self.animationView2.stop()
            self.animationView2.alpha = 0
            self.hand.alpha = 1
        }
        
        
        
        
        //recordWashTime and next Wash Time to users db
        let userID = Auth.auth().currentUser?.uid
        let refWashTime = Database.database().reference().child("users").child(userID!)
        refWashTime.child("last_wash_date").setValue(getTodayString())
        refWashTime.child("next_wash_date").setValue(getTodayString())


        //recordWashTime to central user_info db
        refWashTime.observeSingleEvent(of: .value){
        (snapshot) in

            let data = snapshot.value as? [String:Any]
            let phone = (data?["phone"])

            let refWashTimeCentralDb = Database.database().reference().child("user_info").child((phone as? String)!)
            refWashTimeCentralDb.child("last_wash_date").setValue(self.getTodayString())

        }

        //refresh next wash
        setUpView()

        //check if we are in the night
        let currentDate = Date()
        let _calendar = Calendar.current
        let _currentDate = _calendar.date(byAdding: .minute, value: 0, to: currentDate)

        let components = _calendar.dateComponents([.year,.month,.day,.hour,.minute,.second], from: currentDate)

        if(components.hour! > 20 && components.hour! <= 24){
            //night
            //do nothing
        }else if(components.hour! > 0 && components.hour! <= 6){
            //morning
            //do nothing
        }else{
            center1.removeAllPendingNotificationRequests()
            center2.removeAllPendingNotificationRequests()
            center3.removeAllPendingNotificationRequests()
            center4.removeAllPendingNotificationRequests()
            center5.removeAllPendingNotificationRequests()

            let _date = Date().addingTimeInterval(2700)
            let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: _date)
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false )

            let uuid = UUID().uuidString
            let requests = UNNotificationRequest(identifier: uuid, content: content, trigger: trigger)
            center1.add(requests){(error) in}

            let _date2 = Date().addingTimeInterval(2700 * 2)
            let dateComponents2 = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: _date2)
            let trigger2 = UNCalendarNotificationTrigger(dateMatching: dateComponents2, repeats: false )

            let uuid2 = UUID().uuidString
            let requests2 = UNNotificationRequest(identifier: uuid2, content: content, trigger: trigger2)
            center2.add(requests2){(error) in}


            let _date3 = Date().addingTimeInterval(2700 * 3)
            let dateComponents3 = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: _date3)
            let trigger3 = UNCalendarNotificationTrigger(dateMatching: dateComponents3, repeats: false )

            let uuid3 = UUID().uuidString
            let requests3 = UNNotificationRequest(identifier: uuid3, content: content, trigger: trigger3)
            center3.add(requests3){(error) in}


            let _date4 = Date().addingTimeInterval(2700 * 4)
            let dateComponents4 = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: _date4)
            let trigger4 = UNCalendarNotificationTrigger(dateMatching: dateComponents4, repeats: false )

            let uuid4 = UUID().uuidString
            let requests4 = UNNotificationRequest(identifier: uuid4, content: content, trigger: trigger4)
            center4.add(requests4){(error) in}

            //schedule for 7am in the morning
            var dateComponent5 = DateComponents()
            dateComponent5.hour = 7
            dateComponent5.minute = 0
            let trigger5 = UNCalendarNotificationTrigger(dateMatching: dateComponent5, repeats: true )
            let uuid5 = UUID().uuidString
            let requests5 = UNNotificationRequest(identifier: uuid5, content: content, trigger: trigger5)
            center5.add(requests5){(error) in}
        }
        
        
    }

    @IBAction func sanitizerCleanse(_ sender: Any) {
        
        //new
        self.animationView2.alpha = 1
        self.hand.alpha = 0
        self.animationView2.animation = Animation.named("17777-hand-sanitizer")
        self.animationView2.frame = CGRect(x:0, y:0, width: 200, height: 200)
        self.animationView2.center = self.view.center
        //self.animationView2.backgroundColor = .white
        self.animationView2.contentMode = .scaleAspectFit
        self.animationView2.loopMode = .loop
        self.animationView2.play()
        self.view.addSubview(self.animationView2)
        
        
        //Animate washing of hands
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 4){
            self.animationView2.stop()
            self.animationView2.alpha = 0
            self.hand.alpha = 1
        }
                      
        
        //refresh next wash
        setUpView()
        
        
          //recordWashTime to users db
        let userID = Auth.auth().currentUser?.uid
        let refWashTime = Database.database().reference().child("users").child(userID!)
        refWashTime.child("last_wash_date").setValue(getTodayString())


        //recordWashTime to central user_info db
        refWashTime.observeSingleEvent(of: .value){
        (snapshot) in

            let data = snapshot.value as? [String:Any]
            let phone = (data?["phone"])

            let refWashTimeCentralDb = Database.database().reference().child("user_info").child((phone as? String)!)
            refWashTimeCentralDb.child("last_wash_date").setValue(self.getTodayString())

        }


        //check if we are in the night
        let currentDate = Date()
        let _calendar = Calendar.current
        let _currentDate = _calendar.date(byAdding: .minute, value: 0, to: currentDate)

        let components = _calendar.dateComponents([.year,.month,.day,.hour,.minute,.second], from: currentDate)

        if(components.hour! > 20 && components.hour! <= 24){
            //night
            //do nothing
        }else if(components.hour! > 0 && components.hour! <= 6){
            //morning
            //do nothing
        }else{
            center1.removeAllPendingNotificationRequests()
            center2.removeAllPendingNotificationRequests()
            center3.removeAllPendingNotificationRequests()
            center4.removeAllPendingNotificationRequests()
            center5.removeAllPendingNotificationRequests()

            let _date = Date().addingTimeInterval(2700)
            let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: _date)
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false )

            let uuid = UUID().uuidString
            let requests = UNNotificationRequest(identifier: uuid, content: content, trigger: trigger)
            center1.add(requests){(error) in}

            let _date2 = Date().addingTimeInterval(2700 * 2)
            let dateComponents2 = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: _date2)
            let trigger2 = UNCalendarNotificationTrigger(dateMatching: dateComponents2, repeats: false )

            let uuid2 = UUID().uuidString
            let requests2 = UNNotificationRequest(identifier: uuid2, content: content, trigger: trigger2)
            center2.add(requests2){(error) in}


            let _date3 = Date().addingTimeInterval(2700 * 3)
            let dateComponents3 = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: _date3)
            let trigger3 = UNCalendarNotificationTrigger(dateMatching: dateComponents3, repeats: false )

            let uuid3 = UUID().uuidString
            let requests3 = UNNotificationRequest(identifier: uuid3, content: content, trigger: trigger3)
            center3.add(requests3){(error) in}


            let _date4 = Date().addingTimeInterval(2700 * 4)
            let dateComponents4 = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: _date4)
            let trigger4 = UNCalendarNotificationTrigger(dateMatching: dateComponents4, repeats: false )

            let uuid4 = UUID().uuidString
            let requests4 = UNNotificationRequest(identifier: uuid4, content: content, trigger: trigger4)
            center4.add(requests4){(error) in}

            //schedule for 7am in the morning
            var dateComponent5 = DateComponents()
            dateComponent5.hour = 7
            dateComponent5.minute = 0
            let trigger5 = UNCalendarNotificationTrigger(dateMatching: dateComponent5, repeats: true )
            let uuid5 = UUID().uuidString
            let requests5 = UNNotificationRequest(identifier: uuid5, content: content, trigger: trigger5)
            center5.add(requests5){(error) in}
        }
        
        
        
        
    }

    
    
    func createAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Agree", style: UIAlertAction.Style.default, handler: { (agree) in
            
            self.center.requestAuthorization(options: [.alert, .sound, .badge]){ granted, error in
                 if granted {
                     print("Access granted")
                     
                 }
             }
            
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: { (cancel) in
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
    
    func getNextWash() -> String{
        let date = Date()
        let calendar = Calendar.current
        let _date = calendar.date(byAdding: .minute, value: 45, to: date)
        
        let components = calendar.dateComponents([.year,.month,.day,.hour,.minute,.second], from: _date!)
        let year = components.year
        let month = components.month
        let day = components.day
        let hour = components.hour
        let minute = components.minute
        let second = components.second

        let today_string = String(year!) + "-" + String(month!) + "-" + String(day!) + " " + String(hour!)  + ":" + String(minute!) + ":" +  String(second!)

        return today_string
    }

    
    @IBAction func tipsClicked(_ sender: Any) {
        let number = Int (arc4random_uniform(5))
        
        createTip(title: "Quick Tip", message: tips[number])
        
    }
    
    
    func createTip(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: { (agree) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
        
    }
    
}
