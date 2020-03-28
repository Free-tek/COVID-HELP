//
//  HomeGroupViewController.swift
//  Corona Help
//
//  Created by Botosoft Technologies on 21/03/2020.
//  Copyright © 2020 freetek. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class HomeGroupViewController: UIViewController {

    @IBOutlet weak var friends: UILabel!
    @IBOutlet weak var groupIcon: UIImageView!
    @IBOutlet weak var noFriends: UILabel!
    @IBOutlet weak var importContacts: UIButton!
    @IBOutlet weak var help: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        friends.alpha = 0
        groupIcon.alpha = 0
        noFriends.alpha = 0
        importContacts.alpha = 0
        help.alpha = 0

        // Do any additional setup after loading the view.
        let userID = Auth.auth().currentUser?.uid
        let refUser = Database.database().reference().child("users").child(userID!)
        
        refUser.observeSingleEvent(of: .value, with: { (snapshot) in

             if snapshot.hasChild("friends"){
                 self.performSegue(withIdentifier: "contactList", sender: nil)
                
                print("got here1234565789")
             }else{
                self.friends.alpha = 1
                self.groupIcon.alpha = 1
                self.noFriends.alpha = 0.65
                self.importContacts.alpha = 1
                self.help.alpha = 1
             }


         })
        
    }
    

    @IBAction func funcImportContact(_ sender: Any) {
        self.performSegue(withIdentifier: "toAddContact", sender: nil)
        
    }
    
}
