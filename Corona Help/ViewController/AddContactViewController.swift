//
//  AddContactViewController.swift
//  Corona Help
//
//  Created by Botosoft Technologies on 21/03/2020.
//  Copyright © 2020 freetek. All rights reserved.
//

import UIKit
import Contacts
import Firebase
import FirebaseDatabase
import Lottie

class AddContactViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    
    @IBOutlet weak var sendMessageView: UIView!
    @IBOutlet weak var contact1: UIImageView!
    @IBOutlet weak var contact2: UIImageView!
    @IBOutlet weak var contact3: UIImageView!
    @IBOutlet weak var whatsapp: UIButton!
    
    
    @IBOutlet weak var back: UIButton!
    
    @IBOutlet weak var cancelAdittion: UIButton!
    @IBOutlet weak var Literal1: UILabel!
    @IBOutlet weak var Literal2: UILabel!
    @IBOutlet weak var Literal3: UILabel!
    @IBOutlet weak var addButton: UIButton!
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    @IBOutlet weak var tableView: UITableView!
    var contactStore = CNContactStore()
    var contacts = [ContactsModel]()
    var contactDictionary = [String: String]()
    
    var count = 0
    var notExist = [String: String]()
    var added = [String: String]()
    var _phone = ""
    var _name = ""
    
    
    var invitePhone = ""
    var inviteName = ""
    
    let animationView2 = AnimationView()
    
    
     override func viewDidLoad() {
         super.viewDidLoad()

        setUpView()
        
        fetchContacts()
         
         
     }
    
    func setUpView(){
        contact1.alpha = 0
        contact2.alpha = 0
        contact3.alpha = 0
        
        Literal1.alpha = 0
        Literal2.alpha = 0
        Literal3.alpha = 0
        
        cancelAdittion.alpha = 0
        
        //check if user has washed his hands before
        let userID = Auth.auth().currentUser?.uid
        let refUser = Database.database().reference().child("users").child(userID!)
        
    
        sendMessageView.alpha = 0
        whatsapp.alpha = 0
        
        Utilities.styleFilledButton2(addButton)
        
         // Do any additional setup after loading the view.
         contactStore.requestAccess(for: .contacts) { (success, error ) in
             if success{
                 
             }else{
                 self.createAlert(title: "Ooops", message: "We need this access your contacts, we want to link you up with your friends so that you can always remind each other to wash your hands. We believe together we can fight this")
             }
         }
         
        
        
        self.tableView.reloadData()
        
        tableView.alpha = 0
        //----set up activity indicator-----
        activityIndicator.center = self.view.center;
        activityIndicator.hidesWhenStopped = true;
        if #available(iOS 13.0, *) {
            activityIndicator.style = UIActivityIndicatorView.Style.medium
        } else {
            // Fallback on earlier versions
        }
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.tableFooterView = UIView()
    }
     
    func createAlert(title: String, message: String){
         let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
         alert.addAction(UIAlertAction(title: "Agree", style: UIAlertAction.Style.default, handler: { (agree) in
             //self.registerLocal()
             
         }))
         alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: { (cancel) in
             alert.dismiss(animated: true, completion: nil)
         }))
         self.present(alert, animated: true, completion: nil)
         
     }
    
    
    func createAlert2(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: { (cancel) in
            
            self.contact1.alpha = 0
            self.contactDictionary = [String: String]()
            self.count = 0
            self.cancelAdittion.alpha = 0
            self.Literal1.alpha = 0
            
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    func createAlert3(title: String, message: String, name: String, phone: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: { (cancel) in
            alert.dismiss(animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "Invite", style: UIAlertAction.Style.default, handler: { (cancel) in
            self.inviteFriend(name: name, phone: phone)
            
        }))
        
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func additionDoneAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Finish", style: UIAlertAction.Style.default, handler: { (cancel) in
            self.performSegue(withIdentifier: "backToAddContacts2", sender: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "Add another", style: UIAlertAction.Style.default, handler: { (cancel) in
            self.contact1.alpha = 0
            self.Literal1.alpha = 0
            self.notExist = [String: String]()
            self.added = [String: String]()
            self.contactDictionary = [String: String]()
            self.count = 0
            
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func inviteFriend(name: String, phone: String){
        
        self.contact1.alpha = 0
        self.contact2.alpha = 0
        self.contact3.alpha = 0
        
        self.Literal1.alpha = 0
        self.Literal2.alpha = 0
        self.Literal3.alpha = 0
        self.cancelAdittion.alpha = 0
        
        whatsapp.alpha = 1
        sendMessageView.alpha = 1
        
        self.view.bringSubviewToFront(whatsapp)
        self.view.bringSubviewToFront(sendMessageView)
        
        
        self.invitePhone = phone
        self.inviteName = name
        
        
        
    }
     
     
     func fetchContacts(){
         
         let key = [CNContactGivenNameKey, CNContactPhoneNumbersKey] as [CNKeyDescriptor]
         let request = CNContactFetchRequest(keysToFetch: key)
         try! contactStore.enumerateContacts(with: request){
             (contact, stoppingPointer) in
             
             let name = contact.givenName
             let number = contact.phoneNumbers.first?.value.stringValue
             
             let contactToAppend = ContactsModel(name: name, number: number! )
             
             self.contacts.append(contactToAppend)
         }
        
        self.contacts = self.contacts.sorted(by: { $0.name.lowercased() < $1.name.lowercased() })
         //= self.contacts.sorted(by: { $0.name > $1.name })
        print("sorted contacts")
        print()
        tableView.reloadData()
         
     }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "contactCell", for: indexPath) as! ContactCellTableViewCell

        let item: ContactsModel
        item = contacts[indexPath.row]

        // Stop and hide indicator
        self.activityIndicator.stopAnimating()
        self.activityIndicator.isHidden = true
        tableView.alpha = 1

        cell.name.text = item.name
        cell.number.text = item.number

        return cell

    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    

//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == UITableViewCell.EditingStyle.delete{
//            contacts.remove(at: indexPath.row)
//            tableView.reloadData()
//        }
//    }
    
    
    //get clicked item
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let item: ContactsModel
        item = contacts[indexPath.row]
        
        if count == 0{
            count = count + 1
            contact1.alpha = 1
            contactDictionary[item.name] = item.number
            Literal1.alpha = 1
            Literal1.text? = String(item.name.prefix(2))
            cancelAdittion.alpha = 1
            
//        }else if count == 1{
//            count = count + 1
//            contact2.alpha = 1
//            contactDictionary[item.name] = item.number
//            Literal2.alpha = 1
//            Literal2.text? = String(item.name.prefix(2))
//        }else if count == 2{
//            count = count + 1
//            contact3.alpha = 1
//            contactDictionary[item.name] = item.number
//            Literal3.alpha = 1
//            Literal3.text? = String(item.name.prefix(2))
//        }
        }else{
            self.createAlert2(title: "Ooops", message: "You can only add 1 contacts at a time")
        }
        
        //contacts.remove(at: indexPath.row)
        //tableView.reloadData()

    }

    
    @IBAction func addFunction(_ sender: Any) {
        
        self.animationView2.alpha = 1
        self.tableView.alpha = 0
        self.animationView2.animation = Animation.named("17686-wash-your-hands-regularly")
        self.animationView2.frame = CGRect(x:0, y:0, width: 200, height: 200)
        self.animationView2.center = self.view.center
        self.animationView2.contentMode = .scaleAspectFit
        self.animationView2.loopMode = .loop
        self.animationView2.play()
        self.view.addSubview(self.animationView2)
        
        if contactDictionary.isEmpty == false{
            for (key, value) in contactDictionary{

                let userID = Auth.auth().currentUser?.uid
                let ref = Database.database().reference().child("users").child(userID!).child("friends")

                var exist = false
                ref.observeSingleEvent(of: .value) { snapshot in
                    for case let child as DataSnapshot in snapshot.children {
                        guard let dict = child.value as? [String:Any] else {
                            print("Error")
                            return
                        }
                        
                        
                        
                        self._phone = (dict["phone"]  as? String)!
                        self._name = (dict["name"]  as? String)!
                        let value2 = value.replacingOccurrences(of: " ", with: "")
                        
                        let lastDb = self._phone.suffix(6)
                        let lastPhoneValue = value2.suffix(6)
                        
                        print("Your debug check---\(value2)---\(self._phone)---\(lastDb)---\(lastPhoneValue)")
                        
                        
                        if value2 == self._phone{
                            // app user has them on their list already
                            exist = true
                            self.added[self._name] = self._phone
                            
                            //remove loader
                            self.animationView2.stop()
                            self.animationView2.alpha = 0
                            self.tableView.alpha = 1
                            
                            self.createAlert2(title: "Ooops", message: "\(key) is already on your contact list")
                            break
                            
                            
                        }else if lastDb == lastPhoneValue{
                            // app user has them on their list already
                            exist = true
                            self.added[self._name] = self._phone
                            
                            //remove loader
                            self.animationView2.stop()
                            self.animationView2.alpha = 0
                            self.tableView.alpha = 1
                            
                            
                            self.createAlert2(title: "Ooops", message: "\(key) is already on your contact list")
                            break
                            
                        }


                    }

                    print("Got here 4")
                    //check if phone number is using the app already
                    if exist == false{
                        
                        let ref1 = Database.database().reference().child("user_info")
                        

                        ref1.observeSingleEvent(of: .value, with: { (snapshot) in
                            print(snapshot.key)
                            if snapshot.hasChild(value.replacingOccurrences(of: " ", with: "")){
                                //friend to be added uses the app
                                let refUser = Database.database().reference().child("users").child(userID!).child("friends").child(self.nodeKey())
                                
                                 refUser.child("name").setValue(key)
                                 refUser.child("phone").setValue(value.replacingOccurrences(of: " ", with: ""))
                                
                                //remove loader
                                self.animationView2.stop()
                                self.animationView2.alpha = 0
                                self.tableView.alpha = 1
                                
                                
                                self.additionDoneAlert(title: "Done", message: "Successfully added \(key), Add another friend?")
                             }else{
                                self.notExist[key] = value.replacingOccurrences(of: " ", with: "")
                             }


                         })
                        
                    }





                }




            }



            //show error messages
            if notExist.isEmpty == false{
                for (name, phone) in notExist{
                    
                    
                    //remove loader
                    self.animationView2.stop()
                    self.animationView2.alpha = 0
                    self.tableView.alpha = 1
                    
                    
                    self.createAlert3(title: "Ooops", message: "We could'nt add \(name), they don't use the app yet", name: name, phone: phone)
                }

            }

        }else{
            
            //remove loader
            self.animationView2.stop()
            self.animationView2.alpha = 0
            self.tableView.alpha = 1
            
            
            self.createAlert(title: "Ooops", message: "Select a contact to add first")
        }
        
        //remove loader
        self.animationView2.stop()
        self.animationView2.alpha = 0
        self.tableView.alpha = 1


    }
    
    func nodeKey() -> String{
        let one = arc4random_uniform(10)
        let two = arc4random_uniform(10)
        let three = arc4random_uniform(10)
        let letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        let A = String((0..<1).map{ _ in letters.randomElement()! })
        let B = String((0..<1).map{ _ in letters.randomElement()! })
        let C = String((0..<1).map{ _ in letters.randomElement()! })
            
        let code = "\(A)\(one)\(B)\(two)\(C)\(three)"
        return code
    }
    @IBAction func sendWhatsappInvite(_ sender: Any) {
        let urlWhats = "whatsapp://send?phone=\(invitePhone)&text=Hi \(inviteName)your hands covid-help is an app that reminds you to wash your hands against corona virus every 45mins,you get recent corona virus news and health tips,plus as friends we can always remind yourself to wash our hand. Lets help keep ourselves safe,download this app on www.freetek.com.ng available on android and iOS"

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
    
    @IBAction func sendSMSInvite(_ sender: Any) {
        let sms: String = "sms:\(invitePhone)&body=Hi \(inviteName) join me on covid-help app to get frequent reminders to wash your hands against corona virus and live updates from around the world. Download from www.freetek.com.ng"
        let strURL: String = sms.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        UIApplication.shared.open(URL.init(string: strURL)!, options: [:], completionHandler: nil)
    }
    
    @IBAction func cancelAddition(_ sender: Any) {
        contact1.alpha = 0
        self.contactDictionary = [String: String]()
        count = 0
        cancelAdittion.alpha = 0
        Literal1.alpha = 0
    }

    
    @IBAction func backFunction(_ sender: Any) {
        self.performSegue(withIdentifier: "toNews", sender: nil)
    }
    
    
}
