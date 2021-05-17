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
    
    var email : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if(email != ""){
            tfEmail.text = email
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
            
            let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            
            let parking_list_ViewController = storyboard.instantiateViewController(identifier: "parking_list_ViewController") as! ParkingListViewController
            
            self.navigationController?.pushViewController(parking_list_ViewController, animated: true)
            
        }
    }
    
    func showAlert(title : String, message : String){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }

}
