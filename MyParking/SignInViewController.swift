//
//  SignInViewController.swift
//  MyParking
//
//  Created by RD on 15/05/21.
//

import UIKit

class SignInViewController: UIViewController {
    
    @IBOutlet weak var tfEmail: UITextField!
    
    @IBOutlet weak var tfPassword: UITextField!
    
    @IBOutlet weak var switchRememberMe: UISwitch!
    
    let defaults = UserDefaults.standard
    
    var email : String = ""
    
    override func viewDidLoad() {
        
    let isUserDefaultsSavedInSystem = checkUserDefaultStatus()
        if(isUserDefaultsSavedInSystem){
            
            navigateToParkingListScreen()
        }
        
        else{
            super.viewDidLoad()
        }
    }
    
    @IBAction func btnLoginClicked(_ sender: Any) {
        
        if(tfEmail.text == ""){
            // user did not enter value for username field
            
            showAlert(title: "Empty Credentials", message: "Please enter your username")
        }
        
        else if (tfPassword.text == ""){
        // user did not enter value for password field
            
            showAlert(title: "Empty Credentials", message: "Please enter your password")
            
        }
        
        else {
            
            guard let email = tfEmail.text, let pwd = tfPassword.text else {
                
                print("invalid values for username and password fields")
                return
            }
            
            if(switchRememberMe.isOn) {
                
                defaults.set(email, forKey: "email")
                defaults.set(pwd, forKey: "password")
                
            }
            
            // clear the fields of the username and the password and reset the switch
            
            tfEmail.text = ""
            tfPassword.text = ""
            switchRememberMe.setOn(false, animated: true)
            
            navigateToParkingListScreen()
            
            
        }
    }
    
    func navigateToParkingListScreen(){
        
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let parking_list_ViewController = storyboard.instantiateViewController(identifier: "parking_list_ViewController") as! ParkingListViewController
        
        self.navigationController?.pushViewController(parking_list_ViewController, animated: true)
        
    }
    
    
    @IBAction func btnSignUpClicked(_ sender: Any) {
        
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let sign_up_ViewController = storyboard.instantiateViewController(identifier: "sign_up_VC") as! SignUpViewController
        
        self.navigationController?.pushViewController(sign_up_ViewController, animated: true)
        
    }
    
    func checkUserDefaultStatus() -> Bool {
        
        // checks whether the user is saved or not in User Defaults ..
        // if the user is saved, then load the saved username and password in the respective fields and set Remember Me switch to on
        
        if(defaults.string(forKey: "email") != ""){ // there exists a user who selected Remember Me
            
//            tfEmail.text = defaults.string(forKey: "email")
//            tfPassword.text = defaults.string(forKey: "password")
//
//            switchRememberMe.setOn(true, animated: true)
            
            return true
        }
        
        else {
            
            
//            tfEmail.text = ""
//            tfEmail.text = ""
//            switchRememberMe.setOn(false, animated: true)
            
            return false
        }
        
    }
    
    
    func showAlert(title : String, message : String){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }

}
