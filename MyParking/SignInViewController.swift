//
//  SignInViewController.swift
//  MyParking
//
//  Created by RD on 15/05/21.
//

import UIKit

class SignInViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
   
    @IBOutlet weak var tfUsername: UITextField!
    
    @IBOutlet weak var tfPassword: UITextField!
    
    @IBAction func btnLoginClicked(_ sender: Any) {
        
        if(tfUsername.text == ""){
            // user did not enter value for username field
        }
        
        else if (tfPassword.text == ""){
        // user did not enter value for password field
            
            
            
        }
        
        else {
            
        }
    }

}
