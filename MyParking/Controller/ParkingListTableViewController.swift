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
    
    let dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.tableView.rowHeight = 100
        
        self.navigationItem.setHidesBackButton(true, animated: true)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add Parking", style: .plain, target: self, action: #selector(navigateToAddParkingScreen))
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(btnLogoutPressed))
        
        dateFormatter.dateFormat = "HH:mm E, d MMM y"
        getAllParkings()
        print(listOfAllParkings.count)
    
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

        print(#function, "LOGGED OUT from Parking List Screen")
        
    }
    
    private func getAllParkings() {
        
        DBHelper.getInstance().getParkings(forUser: currentUser) { parkingList, result in
            
            if(result.type == .success){
                
                self.listOfAllParkings = parkingList!    // here listOfAllParkings and parkingList both are arrays of a Parking.class object
                
                self.tableView.reloadData()
            }
           
            else if (result.type == .failure) {
                
                print(#function, "Unable to get parkings.")
                
            }
            
        }
        
    }


    override func numberOfSections(in tableView: UITableView) -> Int {
       
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.listOfAllParkings.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "parkingListCell", for: indexPath) as! ParkingListCell
        
        cell.tfCarPlateNumber.text = self.listOfAllParkings[indexPath.row].licensePlateNumber
        cell.tfDate.text = dateFormatter.string(from: (self.listOfAllParkings[indexPath.row].dateOfParking))
        cell.tfAddress.text = self.listOfAllParkings[indexPath.row].location.address
        cell.tfParkingHours.text = self.listOfAllParkings[indexPath.row].parkingHours.stringValue()
        
        if(indexPath.row % 2 == 0 ) {

            cell.backgroundColor = .white
        }
        else {

            cell.backgroundColor = UIColor(red: 216/255.0, green: 230/255.0, blue: 230/255.0, alpha: 1.0)
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let parkingDetails_VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "parkingDetails_VC") as! ParkingDetailsVC
        
        parkingDetails_VC.parking = self.listOfAllParkings[indexPath.row]
        
        self.navigationController?.pushViewController(parkingDetails_VC, animated: true)
        
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {

        if(editingStyle == UITableViewCell.EditingStyle.delete) {
            
            let alertController = UIAlertController(title: "DELETE PARKING", message: "Are you sure you want to delete this parking record?", preferredStyle: .alert)
            
            alertController.addAction(UIAlertAction(title: "Delete", style: .default, handler: {
                action in
                
                // delete the parking record
            }))
            
            alertController.addAction(UIAlertAction(title: "Cancel", style: .default, handler: {
                action in
                
                self.dismiss(animated: true, completion: nil)
            }))
            
            self.present(alertController, animated: true, completion: nil)
        }
    }

}
