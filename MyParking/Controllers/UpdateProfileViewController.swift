//
//  UpdateProfileViewController.swift
//  MyParking
//
//  Created by RD on 25/05/21.
//

import UIKit

class UpdateProfileViewController: UIViewController {

    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var tfContactNumber: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        updateUserInfo()
    }
    

    @IBAction func btnUpdateClicked(_ sender: Any) {
        
        guard let name = tfName.text, let password = tfPassword.text, let contactNumber = tfContactNumber.text else {
            
            print("invalid values for name, email, password, contact number, car plate number fields")
            return
        }
        
        if(name == ""){
            showAlert(title: "Empty Credentials", message: "Please enter your name")
        }
        
        else if(password == ""){
            showAlert(title: "Empty Credentials", message: "Please enter your password")
        }
        
        else if(contactNumber == ""){
            showAlert(title: "Empty Credentials", message: "Please enter your contact number")
        }
    
        
        else {
            
            // update values in Firebase, go back to profile page and update the values there also
            
        }
        
    }
    
    private func updateUserInfo(){
        
        let currentUser = DBHelper.getInstance().currentUser!
        
        tfName.text = currentUser.name
        tfPassword.text = currentUser.pwd
        tfContactNumber.text = currentUser.contactNumber
        
    }
    
    func showAlert(title : String, message : String){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
}
