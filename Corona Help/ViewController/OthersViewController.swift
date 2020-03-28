//
//  OthersViewController.swift
//  Corona Help
//
//  Created by Botosoft Technologies on 24/03/2020.
//  Copyright © 2020 freetek. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class OthersViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    

    @IBOutlet weak var fundUs: UIButton!
    @IBOutlet weak var callCDC: UIButton!
    @IBOutlet weak var signOut: UIButton!
    
    var selectedCountry = "Afghanistan"
    
    var toolBar = UIToolbar()
    var picker = UIPickerView()
    
    var countries = [String]()
    var refList: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        preloadCDC()
        Utilities.styleFilledButton(callCDC)
        Utilities.styleFilledButton(fundUs)
        
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

    @IBAction func signOut(_ sender: Any) {
        createAlert(title: "Proceed?", message: "Do you want to signout")
    }
    
    @IBAction func fundUsFunc(_ sender: Any) {
    }
    @IBAction func callCDCHelp(_ sender: Any) {
        
        //TODO: Show spinner till you fetch teh data
        self.fetchPickerViewItems()
        
        
        
    }
    
    @objc func onDoneButtonTapped() {
        toolBar.removeFromSuperview()
        picker.removeFromSuperview()
        
        //launch call intent
        guard let number = URL(string: "tel://" + selectedCountry) else { return }
        UIApplication.shared.open(number)
    }
    
    func createAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.default, handler: { (agree) in
            alert.dismiss(animated: true, completion: nil)
            
        }))
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: { (cancel) in
            do {
                try Auth.auth().signOut()
                self.dismiss(animated: true, completion: nil)
                self.performSegue(withIdentifier: "signOut", sender: nil)
                } catch let err {
                    print(err)
            }
            
            
        }))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        countries.count
    }
    func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.countries[row]
    }

    func pickerView( _ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedCountry = countries[row]
        
    }
    
    
    func fetchPickerViewItems(){
        refList = Database.database().reference().child("cdc_help");
        
        refList.observe(.value, with: {
            (snapshot) in
            for item in snapshot.children.allObjects as! [DataSnapshot] {
                //getting values
                self.countries.append(item.key)
            }
           
            //done fetching data
            self.picker = UIPickerView.init()
            self.picker.delegate = self
            self.picker.backgroundColor = UIColor.white
            self.picker.setValue(UIColor.black, forKey: "textColor")
            self.picker.autoresizingMask = .flexibleWidth
            self.picker.contentMode = .center
            self.picker.frame = CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 300)
            self.view.addSubview(self.picker)

            
            
            
            self.toolBar = UIToolbar.init(frame: CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 50))
            self.toolBar.barStyle = .blackTranslucent
            self.toolBar.items = [UIBarButtonItem.init(title: "Done", style: .done, target: self, action: #selector(self.onDoneButtonTapped))]
            self.view.addSubview(self.toolBar)
            
            
            
            })
        
    }
    
    func preloadCDC(){
        refList = Database.database().reference().child("cdc_help");
        
        refList.observe(.value, with: {
            (snapshot) in
            for item in snapshot.children.allObjects as! [DataSnapshot] {
                //getting values
                self.countries.append(item.key)
            }
           
            })
    }
    
    @IBAction func payPalPayment(_ sender: Any) {
        if let url = URL(string: "https://www.paypal.com/ng/webapps/mpp/send-money-online") {
            UIApplication.shared.open(url)
        }
    }
    @IBAction func payPalMail(_ sender: Any) {
        if let url = URL(string: "https://www.paypal.com/ng/webapps/mpp/send-money-online") {
            UIApplication.shared.open(url)
        }
    }
    @IBAction func contactUs(_ sender: Any) {
        if let url = URL(string: "https://www.freetek.com.ng") {
            UIApplication.shared.open(url)
        }
    }
    
}
