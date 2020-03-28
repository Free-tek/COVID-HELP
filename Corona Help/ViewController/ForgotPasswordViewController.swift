//
//  ForgotPasswordViewController.swift
//  Corona Help
//
//  Created by Botosoft Technologies on 19/03/2020.
//  Copyright © 2020 freetek. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class ForgotPasswordViewController: UIViewController {

    @IBOutlet weak var recoveryMail: UITextField!
    @IBOutlet weak var loginText: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var sendRecoveryMail: UIButton!
    @IBOutlet weak var errorMessage: UILabel!
    @IBOutlet weak var errorImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        errorImage.alpha = 0
        errorMessage.alpha = 0
        loginText.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2)
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func recoveryMailFunc(_ sender: Any) {
        
        
        if self.validateFields() == nil{
            let email = recoveryMail.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            //let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            Auth.auth().sendPasswordReset(withEmail: email) { error in
                // save users password to db
                
                //send user an alertdialog pop up
                
            }
        }else{
            showErrorMessage(validateFields()!)
        }
    }
    
    
    func validateFields() -> String?{
        //check that all fields are filled in
        if self.recoveryMail.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""
        {
            return "Please enter your email."
        }
        
        return nil
    }
    
    
    func showErrorMessage(_ message: String){
        errorImage.alpha = 1
        errorMessage.alpha = 1
        errorMessage.text = "Error:  " + message
    }
    
}
