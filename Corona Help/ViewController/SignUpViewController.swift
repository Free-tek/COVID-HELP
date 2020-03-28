//
//  SignUpViewController.swift
//  Corona Help
//
//  Created by Botosoft Technologies on 19/03/2020.
//  Copyright © 2020 freetek. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseDatabase

class SignUpViewController: UIViewController {

    @IBOutlet weak var fullName: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var maleButton: UIButton!
    @IBOutlet weak var dateOfBirth: UITextField!
    @IBOutlet weak var femaleButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var loginText: UILabel!
    @IBOutlet weak var errorImage: UIImageView!
    @IBOutlet weak var errorText: UILabel!
    
    var male = false
    var female = false
    
    
    var _fullname = ""
    var _email = ""
    var _phone = ""
    var _password = ""
    var _dob = ""
    var gender = ""
    
    
    
    lazy var datePicker: UIDatePicker = {

        let picker = UIDatePicker()

        picker.datePickerMode = .date

        picker.addTarget(self, action: #selector(datePickerChanged(_:)), for: .valueChanged)

        return picker
    }()

    lazy var dateFormatter: DateFormatter = {

        let formatter = DateFormatter()

        formatter.dateFormat = "dd/MM/yyyy"
        return formatter
    }()
    
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        setUpElements()
        
        
        
        // Do any additional setup after loading the view.
    }
    
    func setUpElements(){
        
        Utilities.styleFilledButton3(loginButton)
        loginText.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2)

        
        errorText.alpha = 0
        errorImage.alpha = 0
        
        dateOfBirth.inputView = datePicker
        
    }
    
    
    @objc func datePickerChanged(_ sender: UIDatePicker) {
        dateOfBirth.text = dateFormatter.string(from: sender.date)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        view.endEditing(true)
    }
    
    @objc func DoneButton() {
        dateOfBirth.resignFirstResponder()
        
    }
    
    func validateFields() -> String?{
        //check that all fields are filled in
        self.errorImage.alpha = 0
        self.errorText.alpha = 0
        _dob = dateOfBirth.text!
        
        
        if fullName.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""
        {
            return "Please enter your full name."
        }else if email.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "Please enter your email."
        }else if password.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "Please enter your password."
        }else if _dob.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "Please enter your date of birth."
        }else if phone.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            return "Please enter your phone no."
        }else if male == false && female == false{
            return "Please select your gender."
        }
        
        return nil
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func maleClicked(_ sender: Any) {
        male  = true
        female = false
        
        femaleButton.setImage(UIImage(named: "icons8-female_user.png"), for: .normal)
        maleButton.setImage(UIImage(named: "icons8-user_male-1.png"), for: .normal)
        gender = "male"
        
    }
    
    
    @IBAction func femaleClicked(_ sender: Any) {
        male  = false
        female = true
        
        maleButton.setImage(UIImage(named: "icons8-user_male.png"), for: .normal)
        femaleButton.setImage(UIImage(named: "icons8-female_user-1.png"), for: .normal)
        
        gender = "female"

    }
    
    @IBAction func signUpButtonFunc(_ sender: Any) {
        let _error = validateFields()
        
        if validateFields() == nil{
            _email = email.text!
            _password = password.text!
            createAlert(title: Constants.StringAssets.headerTC, message: Constants.StringAssets.bodyTC)
            
            
        }else{
            showErrorMessage(_error!)
        }
    }
    
    @IBAction func loginButtonFunc(_ sender: Any) {
        
    
    }
    
    func createAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Agree", style: UIAlertAction.Style.default, handler: { (agree) in
            self.createAccount()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: { (cancel) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    
    func createAccount(){
        Auth.auth().createUser(withEmail: _email, password: _password) { (result, err) in

            //check for errors
            if err != nil{
                //there was an error
                self.showErrorMessage("Please try again, we could not create your account")
            }else{
                //user was created successfully
                //now store data

                let post: [String : Any] = ["name" : self.fullName.text!,
                                            "gender" : self.gender,
                                            "phone" : self.phone.text!,
                                            "age": self._dob,
                                            "email": self._email,
                                            "dateOfBirth": self._dob,
                                            "password": self.password.text!,
                                            "version": "iOS"]
                
            
                let userId = result!.user.uid
                let ref = Database.database().reference().child("users").child(userId)
                let ref3 = Database.database().reference().child("user_info").child(self.phone.text!)

                //save user's data
                ref.setValue(post) { (err, resp) in
                            guard err == nil else {
                                print("Posting failed : ")
                                //print(err)

                                return
                            }
                            print("No errors while posting, :")
                            print(resp)
                        }
                
                
            
                Database.database().reference().child("user_info").observeSingleEvent(of: DataEventType.value, with:{ (snapshot) in
                    var childrenCount = snapshot.childrenCount
                    let id : [String : Any] = ["name" : self.fullName.text!,
                                               "userId" : userId]
                    childrenCount = childrenCount+1
                    //save userPhone
                    ref3.setValue(id) { (err, resp) in
                        guard err == nil else {
                        return
                        }
                    }
                })
                
                
                
                
                
                


                //TODO: Transition to home screen
                self.transitionToHome()

            }
        }

    }
    
    func showErrorMessage(_ message: String){
        self.errorText.text = "Error:  " + message
        self.errorText.alpha = 1
        self.errorImage.alpha = 1
    }
    
    
    func transitionToHome(){
        self.performSegue(withIdentifier: "launchHomeSignUp", sender: nil)
    }
    
}
