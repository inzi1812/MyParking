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
    
    
    var user : User!

    
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
            return
        }
        
        else if(password == ""){
            showAlert(title: "Empty Credentials", message: "Please enter your password")
            return
        }
        
        else if(contactNumber == ""){
            showAlert(title: "Empty Credentials", message: "Please enter your contact number")
            return
        }
    
        
        else {
            
            // update values in Firebase, go back to profile page and update the values there also
            
            if var tUser = user
            {
                
                tUser.name = name
                tUser.contactNumber = contactNumber
                tUser.pwd = password
                
                DBHelper.getInstance().updateUser(for: tUser) { result in
                    
                    if result.type == .success
                    {
                        let alert = UIAlertController(title: "Success", message: "User Updated Successfully", preferredStyle: .alert)
                        
                        alert.addAction(UIAlertAction(title: "Ok", style: .default) { _ in
                            self.navigationController?.popViewController(animated: true)

                        })
                        
                        
                        self.present(alert, animated: true, completion: nil)
                        
                    }
                    else
                    {
                        self.showAlert(title: "Error", message: result.message)
                    }
                    
                }
            }
            
            
            
        }
        
    }
    
    private func updateUserInfo()
    {
        DBHelper.getInstance().getUser { user, result in
            
            if result.type == .success
            {
                
                self.user = user!
                
                self.tfName.text = user!.name
                self.tfPassword.text = user!.pwd
                self.tfContactNumber.text = user!.contactNumber
            }
            else
            {
                self.showAlert(title: "Error", message: result.message)
            }
            
        }
        
    }
    
    func showAlert(title : String, message : String){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
}
