//
//  ParkingListViewController.swift
//  MyParking
//
//  Created by RD on 17/05/21.
//

import UIKit

class ParkingListViewController: UIViewController {
    
    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.setHidesBackButton(true, animated: true)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(btnLogoutPressed))
        
    }
    
    @objc func btnLogoutPressed(){
        
        defaults.set("", forKey: "email")
        defaults.set("", forKey: "password")
        
        self.navigationController?.popViewController(animated: true)

        self.dismiss(animated: true, completion: nil)
        
        
        
        print("LOGGED OUT from Parking List Screen")
        
        
    }

}
