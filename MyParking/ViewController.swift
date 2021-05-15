//
//  ViewController.swift
//  MyParking
//
//  Created by Inzi Hussain on 2021-05-12.
// checking

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //Welcome to Application
    }

    
    
    @IBAction func btnSignInClicked(_ sender: Any) {
        
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let sign_in_ViewController = storyboard.instantiateViewController(identifier: "sign_in_VC") as! SignInViewController
        
        self.navigationController?.pushViewController(sign_in_ViewController, animated: true)
        
    }
    
    
    
    @IBAction func btnSignUpClicked(_ sender: Any) {
        
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let sign_up_ViewController = storyboard.instantiateViewController(identifier: "sign_up_VC") as! SignUpViewController
        
        self.navigationController?.pushViewController(sign_up_ViewController, animated: true)
    
    }
    
}

