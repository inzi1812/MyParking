//
//  SignUpViewController.swift
//  MyParking
//
//  Created by RD on 15/05/21.
//

import UIKit

class SignUpViewController: UIViewController {

    
    
    @IBOutlet weak var tfName: UITextField!
    
    @IBOutlet weak var tfEmail: UITextField!
    
    @IBOutlet weak var tfPassword: UITextField!
    
    @IBOutlet weak var tfContactNumber: UITextField!
    
    @IBOutlet weak var tfCarplateNumber: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
   
    
    @IBAction func btnSignUpClicked(_ sender: Any) {
        
        if(tfName.text == ""){
            showAlert(title: "Empty Credentials", message: "Please enter correct value for username")
        }
        
        else if(tfEmail.text == ""){
            showAlert(title: "Empty Credentials", message: "Please enter correct value for email")
        }
        
        else if(tfPassword.text == ""){
            showAlert(title: "Empty Credentials", message: "Please enter correct value for password")
        }
        
        else if(tfContactNumber.text == ""){
            showAlert(title: "Empty Credentials", message: "Please enter correct value for contact number")
        }
        
        else if(tfCarplateNumber.text == ""){
            showAlert(title: "Empty Credentials", message: "Please enter correct value for Car plate number")
        }
        
        else {
            
            let email = tfEmail.text!
            
            let newUser = User(id: nil, name: tfName.text!, licensePlateNum: tfCarplateNumber.text!)
            
            let isSignUpSuccessful = DBHelper.getInstance().addUser(user: newUser)
            
            if(isSignUpSuccessful){
                
//                showAlert(title: "Sign Up Successful", message: "You have been registered. You will now be re-directed to the login screen.")
                
               
                let alert = UIAlertController(title: "Sign Up Successful", message: "You have been registered. You will now be re-directed to the login screen.", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Login", style: .default, handler: { action in
                    
                    if let presenter = self.presentingViewController as? SignInViewController {
                        presenter.email = self.tfEmail.text!
                        print("returned back the value")
                        }
                    
                    self.navigationController?.popViewController(animated: true)

                    self.dismiss(animated: true, completion: nil)
                    
                    }))
                
                self.present(alert, animated: true, completion: nil)
                
                
            }
            
            else {
                
                showAlert(title: "Sign Up Error", message: "An error occured")
            }
        }
    
    }
    
    func navigateToSignInScreen(){
        
        
    }
    
    
    func showAlert(title : String, message : String){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }

}
