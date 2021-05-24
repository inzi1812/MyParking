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
    var currentUser = User(email: "", name: "", cars: [], pwd: "", contactNumber: "")
    
    override func viewDidLoad() {
        
    tfPassword.isSecureTextEntry = true // sets ***** for password input
        
    let isUserDefaultsSavedInSystem = checkUserDefaultStatus()
        if let userEmail = checkUserDefaultStatus() {
            DBHelper.getInstance().getUser(email: userEmail) { user, result in
                
                if result.type == .noConnection{
                    
                    self.showAlert(title: "No Connection", message: "You do not seem connected to the internet. Please connect and try again.")
                }
                else if(result.type == .success){
                    
                    self.currentUser = user!
                    self.navigateToParkingListScreen()
                }
                
            }
            
        }
        
        else{
            super.viewDidLoad()
            
            tfEmail.text = "test@test.com"
            tfPassword.text = "test"
        }
    }
    
    @IBAction func btnLoginClicked(_ sender: Any) {
        
        guard let email = tfEmail.text, let password = tfPassword.text else{
            
            print("invalid values for email and password fields")
            return
        }
        
        if(email == ""){
            // user did not enter value for username field
            
            showAlert(title: "Empty Credentials", message: "Please enter your email")
        }
        
        else if (password == ""){
        // user did not enter value for password field
            
            showAlert(title: "Empty Credentials", message: "Please enter your password")
            
        }
        
        else {
                    
            DBHelper.getInstance().validateUser(mail: email, pwd: password) { user, result in
                    
                if result.type == .success{
                    
                    self.currentUser = user!
                    
                    if(self.switchRememberMe.isOn) {
                        
                        self.defaults.set(email, forKey: "email")
                        
                    }
                    
                    // clear the fields of the username and the password and reset the switch
                    
                    self.tfEmail.text = ""
                    self.tfPassword.text = ""
                    self.switchRememberMe.setOn(false, animated: true)
                    
                    self.navigateToParkingListScreen()
                    
                }
                
                else {
                    
                    self.showAlert(title: "Error", message: result.message)
                }
            }
            
            
        }
    }
    
    func navigateToParkingListScreen(){
        
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let parking_list_ViewController = storyboard.instantiateViewController(identifier: "parkingList_VC") as! ParkingListTableViewController
        
        parking_list_ViewController.currentUser = currentUser
        self.navigationController?.pushViewController(parking_list_ViewController, animated: true)
        
    }
    
    
    @IBAction func btnSignUpClicked(_ sender: Any) {
        
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let sign_up_ViewController = storyboard.instantiateViewController(identifier: "sign_up_VC") as! SignUpViewController
        
        self.navigationController?.pushViewController(sign_up_ViewController, animated: true)
        
    }
    
    func checkUserDefaultStatus() -> String? {
        // checks whether the user is saved or not in User Defaults..
        
        if let email = defaults.string(forKey: "email") { // there exists a user who selected Remember Me
            
            
            return email
        }
        
        else {
            
            return nil
        }
    }
    
    
    func showAlert(title : String, message : String){
        
        let alert = UIAlertController(title: title.uppercased(), message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }

}
