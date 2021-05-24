//
//  UpdateProfileViewController.swift
//  MyParking
//
//  Created by RD on 23/05/21.
//

import UIKit

class UpdateProfileViewController: UIViewController {
    
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var tfContactNumber: UITextField!
    @IBOutlet weak var tfCarplateNumber: UITextField!
    
    var currentUser = User(email: "", name: "", cars: [], pwd: "", contactNumber: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadUserDetails()
    }
    
    private func loadUserDetails(){
        
        tfName.text = self.currentUser.name
        tfEmail.text = self.currentUser.email
        tfPassword.text = self.currentUser.pwd
        tfContactNumber.text = self.currentUser.contactNumber
        tfCarplateNumber.text = self.currentUser.cars[0].licensePlateNumber
    }
    

    @IBAction func btnUpdateProfileClicked(_ sender: Any) {
        
        guard let name = tfName.text, let email = tfEmail.text, let password = tfPassword.text, let contactNumber = tfContactNumber.text, let carPlateNUmber = tfCarplateNumber.text else {
            
            print("invalid values for name, email, password, contact number, car plate number fields")
            return
        }
        
        if(name == ""){
            showAlert(title: "Empty Credentials", message: "Please enter your name")
        }
        
        else if(email == ""){
            showAlert(title: "Empty Credentials", message: "Please enter your email address")
        }
        
        else if(!email.isValidEmail()){
            showAlert(title: "Invalid Email", message: "Please enter a valid email address")
        }
        
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
            
            // perform action to update the user details in Firebase
        }
    }
    
    @IBAction func btnDeleteAccountClicked(_ sender: Any) {
   
        let alertController = UIAlertController(title: "Delete Account", message: "Deleting your account will delete all the information related to your account, cars and parking locations. Are you sure you want to continue?", preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "Delete", style: .default, handler: { action in
            // delete user from Firebase
            
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { action in
            
            self.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showAlert(title : String, message : String){
        
        let alert = UIAlertController(title: title.uppercased(), message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
}
