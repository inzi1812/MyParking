//
//  ParkingListTableViewController2.swift
//  MyParking
//
//  Created by RD on 20/05/21.
//

import UIKit

class ParkingListTableViewController: UITableViewController {

    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.setHidesBackButton(true, animated: true)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(btnLogoutPressed))

    }
    
    @objc func btnLogoutPressed(){
        
//        defaults.set("", forKey: "email")
//        defaults.set("", forKey: "password")
//
//        self.navigationController?.popViewController(animated: true)
//
//        self.dismiss(animated: true, completion: nil)
//
//        print("LOGGED OUT from Parking List Screen")
        
        
        
        let vc = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "AddParkingVC") as! AddParkingVC
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
       
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 0
    }

}
