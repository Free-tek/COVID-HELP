//
//  HelpViewController.swift
//  Corona Help
//
//  Created by Botosoft Technologies on 22/03/2020.
//  Copyright © 2020 freetek. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class HelpViewController: UIViewController {
    
   
    
    @IBOutlet weak var signOut: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func signOutFunc(_ sender: Any) {
        print("clicked")
        try! Auth.auth().signOut()
       }

}
