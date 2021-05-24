//
//  ParkingListTableViewController2.swift
//  MyParking
//
//  Created by RD on 20/05/21.
//

import UIKit

class ParkingListTableViewController: UITableViewController {

    let defaults = UserDefaults.standard
    
    private var listOfAllParkings : [Parking] = [Parking]()
    
    var currentUser = User(email: "", name: "", cars: [], pwd: "", contactNumber: "")
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.navigationItem.setHidesBackButton(true, animated: true)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add Parking", style: .plain, target: self, action: #selector(navigateToAddParkingScreen))
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(btnLogoutPressed))
        
        getAllParkings()
        
        self.tableView.rowHeight = 100

    }
    
    @objc func navigateToAddParkingScreen(){
        
        let vc = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "AddParkingVC") as! AddParkingVC
        
        vc.user = currentUser
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func btnLogoutPressed(){
        
        defaults.removeObject(forKey: "email")
        
        self.navigationController?.popViewController(animated: true)

        self.dismiss(animated: true, completion: nil)

        print("LOGGED OUT from Parking List Screen")
        
    }
    
    private func getAllParkings(){
        
        print(currentUser)
        print("-----------`")
        
        DBHelper.getInstance().getParkings(forUser: currentUser) { parkingList, result in
            
            self.listOfAllParkings = parkingList!
        
            
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
       
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.listOfAllParkings.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "parkingListCell", for: indexPath) as! ParkingListCell
        
        cell.tfCarPlateNumber.text = self.listOfAllParkings[indexPath.row].licensePlateNumber
        cell.tfBuildingCode.text = self.listOfAllParkings[indexPath.row].buildingCode
        cell.tfHostSuitNo.text = self.listOfAllParkings[indexPath.row].hostSuitNum
        cell.tfParkingHours.text = self.listOfAllParkings[indexPath.row].parkingHours.stringValue()
        
        if(indexPath.row % 2 == 0 ) {
            
            cell.backgroundColor = .white
        }
        else {
            
            cell.backgroundColor = UIColor(red: 216/255.0, green: 230/255.0, blue: 230/255.0, alpha: 1.0)
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {

        if(editingStyle == UITableViewCell.EditingStyle.delete) {


        }
    }

}
