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
    
    @IBOutlet weak var tfCarName: UITextField!
    
    @IBOutlet weak var tfCarplateNumber: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tfPassword.isSecureTextEntry = true // sets ***** for password input
        
    }
    
    @IBAction func btnSignUpClicked(_ sender: Any) {
        
        guard let name = tfName.text, let email = tfEmail.text, let password = tfPassword.text, let contactNumber = tfContactNumber.text, let carPlateNUmber = tfCarplateNumber.text else {
            
            print("invalid values for name, email, password, contact number, car plate number fields")
            return
        }
        
        let carName = tfCarName.text ?? ""
        
        if(name == ""){
            showAlert(title: "Empty Credentials", message: "Please enter your name")
        }
        
        else if(email == ""){
            showAlert(title: "Empty Credentials", message: "Please enter your email address")
        }
        
//        else if(!email.isValidEmail()){
//            showAlert(title: "Invalid Email", message: "Please enter a valid email address")
//        }
        
        else if(password == ""){
            showAlert(title: "Empty Credentials", message: "Please enter your password")
        }
        
        else if(contactNumber == ""){
            showAlert(title: "Empty Credentials", message: "Please enter your contact number")
        }
        
        else if(carPlateNUmber == ""){
            showAlert(title: "Empty Credentials", message: "Please enter your car plate number / license plate number")
        }
        
        else if(!carPlateNUmber.isValidCarPlateNumber()){
            showAlert(title: "Invalid Car Plate Number", message: "Car Plate Numbers are 2 to 8 letters long")
        }
        
        else {
            
            let email = tfEmail.text!
            
            let car = Car(carName: carName,licensePlateNumber: carPlateNUmber)
            
            let newUser = User(email: email, name: tfName.text!, cars: [car], pwd: tfPassword.text!, contactNumber: tfContactNumber.text!)
            
            DBHelper.getInstance().addUser(user: newUser) { result in
                
                if result.type == .success {
                    
                    let alert = UIAlertController(title: "Sign Up Successful", message: "You have been registered. You will now be re-directed to the login screen.", preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: "Login", style: .default, handler: { action in
                        
                        self.navigationController?.popViewController(animated: true)
                        
                        //                                       self.dismiss(animated: true, completion: nil)
                        
                    }))
                    
                    self.present(alert, animated: true, completion: nil)
                    
                }
                
                else{
                    
                    self.showAlert(title: "Error", message: result.message)
                }
                
            }
            
            
        }
        
    }
    
    
    func showAlert(title : String, message : String){
        
        let alert = UIAlertController(title: title.uppercased(), message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
    
}
