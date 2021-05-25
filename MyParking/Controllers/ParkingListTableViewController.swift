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
    
    let dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(navigateToAddParkingScreen))
        
        
        dateFormatter.dateFormat = "MMM d y, HH:mm"
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getAllParkings()

    }
    
    @objc func navigateToAddParkingScreen(){
        
        let vc = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "AddParkingVC") as! AddParkingVC
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    private func getAllParkings() {
        
        DBHelper.getInstance().getParkings() { parkingList, result in
            
            if(result.type == .success){
                
                self.listOfAllParkings = parkingList!
                
                self.tableView.reloadData()
               
            }
           
            else if (result.type == .failure) {
                
                print(#function, "Unable to get parkings.")
                
            }
        }
        
    }
    
    private func showAlert(title : String, message : String){
        
        let alert = UIAlertController(title: title.uppercased(), message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }


    //MARK:- TableView Methods
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
        
        cell.tfParkingHours.text = self.listOfAllParkings[indexPath.row].parkingHours.shortString()
        


        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {

        if(editingStyle == UITableViewCell.EditingStyle.delete) {
            
            let alertController = UIAlertController(title: "DELETE PARKING", message: "Are you sure you want to delete this parking record?", preferredStyle: .alert)
            
            alertController.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: {
                action in
                
                // delete the parking record
                
                let id = self.listOfAllParkings[indexPath.row].id!
                DBHelper.getInstance().deleteParking(parkingId: id) { result in
                    
                    
                    if result.type == .success
                    {
                        self.listOfAllParkings.remove(at: indexPath.row)
                        
                        tableView.deleteRows(at: [indexPath], with: .fade)
                    }
                    else
                    {
                        self.showAlert(title: "Error", message: result.message)
                    }
                    
                }
            }))
            
            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {
                action in
                
            }))
            
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        let vc = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "ParkingDetailVC") as! ParkingDetailVC
        
        vc.hidesBottomBarWhenPushed = true
        
        self.navigationController?.view.backgroundColor = .white
        vc.parking = listOfAllParkings[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}