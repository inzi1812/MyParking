//
//  SplashViewController.swift
//  MyParking
//
//  Created by Inzi Hussain on 2021-05-24.
//

import UIKit

class SplashViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        // Do any additional setup after loading the view.
        checkForUser()
    }
    

    func checkForUser()
    {
        if let userEmail = checkUserDefaultStatus() {
            
            DBHelper.getInstance().getUser(email: userEmail) { user, result in
                
                if result.type == .noConnection{
                    
                    self.showAlert(title: "No Connection", message: "You do not seem connected to the internet. Please connect and try again.")
                }
                
                else if(result.type == .success){
                    
                    DBHelper.getInstance().currentUser = user
                    self.SceneRootController.switchToMainScreen()
                }
                else
                {
                    //SignedInUser no longer there
                    self.SceneRootController.switchToLoginPage()
                }
                
            }
            
        }
        else {
            //No user Signed In
            self.SceneRootController.resetUserDefaults()
            self.SceneRootController.switchToLoginPage()

        }
        
        
    }
    
    
    private func checkUserDefaultStatus() -> String? {
        // checks whether the user is saved or not in User Defaults..
        
        if let email = UserDefaults.standard.string(forKey: "email") { // there exists a user who selected Remember Me
            
            
            return email
        }
        
        else {
            
            return nil
        }
    }
    
    
    private func showAlert(title : String, message : String){
        
        let alert = UIAlertController(title: title.uppercased(), message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
}
