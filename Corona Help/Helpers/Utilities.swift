//
//  Utilities.swift
//  Corona Help
//
//  Created by Botosoft Technologies on 19/03/2020.
//  Copyright © 2020 freetek. All rights reserved.
//

import Foundation
import UIKit

class Utilities {
    
    static func styleTextField(_ textField:UITextField){
        
        //create the bottom line
        let bottomLine = CALayer()
        
        bottomLine.frame = CGRect(x: 0, y: textField.frame.height, width: textField.frame.width, height: 2)
        
        bottomLine.backgroundColor = UIColor.init(red: 6/255, green: 3/255, blue: 110/255, alpha: 1).cgColor
        
        textField.borderStyle = .none
        
        textField.layer.addSublayer(bottomLine)
    }
    
    static func styleFilledButton(_ button: UIButton){
        
        //Filled rounded corner Style
        button.backgroundColor = UIColor.init(red: 120/255, green: 214/255, blue: 124/255, alpha: 1)
        button.layer.cornerRadius = 15.0
        button.tintColor = UIColor.white
    }
    
    static func styleFilledButton2(_ button: UIButton){
        
        //Filled rounded corner Style
        button.backgroundColor = UIColor.init(red: 120/255, green: 214/255, blue: 124/255, alpha: 1)
        button.layer.cornerRadius = 0
        button.tintColor = UIColor.white
    }
    
    static func styleFilledButton3(_ button: UIButton){
        
        //Filled rounded corner Style
        button.backgroundColor = UIColor.init(red: 120/255, green: 214/255, blue: 124/255, alpha: 1)
        button.layer.cornerRadius = 0
        button.tintColor = UIColor.white
    }
    
    static func styleFilledLabel(_ label: UILabel){
        
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 15.0
        label.tintColor = UIColor.white
    }
    
    static func styleFilledTextView(_ textView: UITextView){
        
        
        textView.layer.cornerRadius = 15.0
        textView.tintColor = UIColor.white
    }
    
    static func styleHollowButton(_ button:UIButton){
        
        //Hollow rounded corner style
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.cornerRadius = 25.0
        button.tintColor = UIColor.black
    }

    static func isPasswordValid(_ password : String) -> Bool{
        
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "ˆ(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
        return passwordTest.evaluate(with: password)
    }
    
}

