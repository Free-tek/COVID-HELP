//
//  LoginViewController.swift
//  Corona Help
//
//  Created by Botosoft Technologies on 19/03/2020.
//  Copyright © 2020 freetek. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseDatabase
import Lottie

class LoginViewController: UIViewController {
    
    
    @IBOutlet weak var signUp: UIButton!
    @IBOutlet weak var signUpLabel: UILabel!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var forgotPassword: UIButton!
    @IBOutlet weak var login: UIButton!
    @IBOutlet weak var visitUs: UIButton!
    @IBOutlet weak var errorImage: UIImageView!
    @IBOutlet weak var errorMessage: UILabel!
    

    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    let animationView2 = AnimationView()
    
    override func viewDidLoad() {
       
        super.viewDidLoad()
        
        
        let userID = Auth.auth().currentUser?.uid
        
        if userID != nil{
            self.transitionToHome()
        }
        
        
        
        setUpElements()
        
        

        // Do any additional setup after loading the view.
    }
    

    func setUpElements(){
        
    
        self.animationView2.alpha = 0
        //----set up activity indicator-----
        activityIndicator.center = self.view.center;
        activityIndicator.hidesWhenStopped = true;
        if #available(iOS 13.0, *) {
            activityIndicator.style = UIActivityIndicatorView.Style.medium
        } else {
            // Fallback on earlier versions
        }
        view.addSubview(activityIndicator)
        
        errorMessage.alpha = 0
        errorImage.alpha = 0
        signUpLabel.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2)
        
            
    }

    @IBAction func forgotPassword(_ sender: Any) {
        self.performSegue(withIdentifier: "launchForgotPassword", sender: nil)
    }
    
    
    @IBAction func loginFunc(_ sender: Any) {
        
        //login loader animation
        forgotPassword.alpha = 0
        login.alpha = 0
        self.animationView2.alpha = 1
        self.animationView2.animation = Animation.named("lf30_editor_WqPUUE")
        self.animationView2.frame = CGRect(x:-50, y:0, width: 200, height: 200)
        self.animationView2.center = self.view.center
        self.animationView2.contentMode = .scaleAspectFit
        self.animationView2.loopMode = .loop
        self.animationView2.play()
        self.view.addSubview(self.animationView2)
        
        
        if validateFields() ==  nil{
             //sign in the user
            let _email = email.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let _password = password.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            Auth.auth().signIn(withEmail: _email, password: _password) { [weak self] authResult, error in
                guard self != nil else { return }
              
                if error == nil{
                    self!.animationView2.stop()
                    self!.animationView2.alpha = 0
                    self!.forgotPassword.alpha = 1
                    self!.login.alpha = 1
                    
                    self!.activityIndicator.startAnimating()
                    self?.transitionToHome()
                    
                    
                }else{
                    // user sign in sucessfully
                    self?.showErrorMessage(error!.localizedDescription)
                    self!.animationView2.stop()
                    self!.animationView2.alpha = 0
                    self!.forgotPassword.alpha = 1
                    self!.login.alpha = 1
                    self!.createAlert(title: "Ooops", message: "We couldnt sign you in, check your details again or your mobile connection")
                }
            }
            
            
            
            
        }else{
            self.animationView2.stop()
            self.animationView2.alpha = 0
            self.forgotPassword.alpha = 1
            self.login.alpha = 1
            showErrorMessage(validateFields()!)
            
        }
    }
    
    
    @IBAction func visitUs(_ sender: Any) {
        if let url = URL(string: "http://www.freetek.com.ng") {
            UIApplication.shared.open(url)
        }
        
    }
    
    func validateFields() -> String?{
        //check that all fields are filled in
        if self.email.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""
        {
            return "Please enter your email."
        }else if self.password.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "Please enter your password."
        }
        
        return nil
    }
    
    func showErrorMessage(_ message: String){
        errorMessage.text = "Error:  " + message
        errorMessage.alpha = 1
        errorImage.alpha = 1
    }
    
    func transitionToHome(){
        // Stop and hide indicator
        
        self.activityIndicator.stopAnimating()
        self.activityIndicator.isHidden = true
        self.performSegue(withIdentifier: "launchHome", sender: nil)
    }
    
    
    func createAlert(title: String, message: String){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: { (agree) in
            alert.dismiss(animated: true, completion: nil)
            
        }))
        
        
    }
}
