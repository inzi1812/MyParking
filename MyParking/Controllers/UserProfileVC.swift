//
//  UserProfileVC.swift
//  MyParking
//
//  Created by Inzi Hussain on 2021-05-25.
//

import UIKit

class UserProfileVC: UIViewController {
    
    @IBOutlet weak var lblName: UILabel!
    
    @IBOutlet weak var lblEmail: UILabel!
    
    
    @IBOutlet weak var carsTableView: UITableView!
    
    
    private var cars: [Car] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Do any additional setup after loading the view.
        
        self.title = "Profile"
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "power"), style: .plain, target: self, action: #selector(signOutButtonPressed))
        
        
        self.getCars()
        
        
    }
    
    
    @IBAction func addCarButtonPressed(_ sender: Any) {
        
        let alert = UIAlertController(title: "Add Car", message: "Enter Car Details", preferredStyle: .alert)

        //2. Add the text field. You can configure it however you need.
        alert.addTextField { (textField) in
            textField.placeholder = "Enter Car Name(Optonal)"
        }

        alert.addTextField { (textField) in
            textField.placeholder = "Enter PlateNumber(2-8 alphanumerics)"
        }

        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let name = alert!.textFields![0].text ?? "" // Force unwrapping because we know it exists.
            let licensePlatenumber = alert!.textFields![1].text ?? ""
            
            
            guard licensePlatenumber.isValidCarPlateNumber() else
            {
                self.showAlert(title: "Error", message: "Invalid License Platenumber")
                return
            }
            
            
            self.addCar(name: name, plateNumber: licensePlatenumber)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {
            action in
            
            
        }))

        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    @objc func signOutButtonPressed() {
        
        SceneRootController.signOut()
        
    }
    
    @IBAction func DeleteButtonPressed(_ sender: Any) {
        
        let alertController = UIAlertController(title: "DELETE Profile", message: "Are you sure you want to delete this user account?", preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: {
            action in
            
            
            DBHelper.getInstance().deleteUser { result in
                
                if result.type == .success
                {
                    self.SceneRootController.signOut()
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
    
    
    func getCars()
    {
        let user = DBHelper.getInstance().currentUser!
        
        
        self.lblName.text = user.name
        self.lblEmail.text = user.email
        
        DBHelper.getInstance().getUser(email: user.email) { user, result in
            
            guard let user = user else
            {
                
                return
            }
            
            self.cars = user.cars
            self.carsTableView.reloadData()
            
        }
    }
    
    
    private func addCar(name: String, plateNumber: String)
    {
        
        let car = Car(carName: name, licensePlateNumber: plateNumber)
        
        DBHelper.getInstance().addVehicle(car: car) { result in
            
            if result.type == .success
            {
                self.getCars()
            }
            else
            {
                self.showAlert(title: "Error", message: result.message)
            }
            
        }
    }
    
    private func showAlert(title : String, message : String){
        
        let alert = UIAlertController(title: title.uppercased(), message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }


}

extension UserProfileVC : UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cars.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.textLabel?.text = cars[indexPath.row].carString()
        
        return cell
    }
    
    
}
