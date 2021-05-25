//
//  AddParkingVC.swift
//  MyParking
//
//  Created by Inzi Hussain on 2021-05-20.
//

import UIKit
import CoreLocation

class AddParkingVC: UIViewController {

    
    @IBOutlet weak var tfBuildingCode: UITextField!
    @IBOutlet weak var tfParkingLocation: UITextField!
    @IBOutlet weak var tfSuiteNum: UITextField!
    
    @IBOutlet weak var lblSelectedCar: UILabel!

    @IBOutlet weak var lblNumOfHours: UILabel!
    
    @IBOutlet var selectCarGesture: UITapGestureRecognizer!
    
    @IBOutlet var numOfHoursGesture: UITapGestureRecognizer!
            
    @IBOutlet weak var parkingtimeDatePicker: UIDatePicker!
    
    
    var existingParking : Parking?
    
    
    private var carNumber : String?
    private var buildingCode : String?
    private var suitNo : String?
    private var numOfHours : ParkingHour?
    private var location: Location?
    private var parkingTime: Date?
    
    let geocoder = CLGeocoder()
    
    private var locationManager : CLLocationManager!

    //MARK:- Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        initialSettings()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(addParking))
        // Do any additional setup after loading the view.
    }
    
    //MARK:- Local Methods
    func initialSettings()
    {
        
        if let parking = existingParking
        {
            //Edit Page
            self.carNumber = parking.licensePlateNumber
            self.buildingCode = parking.buildingCode
            self.suitNo = parking.hostSuitNum
            self.numOfHours = parking.parkingHours
            self.location = parking.location
            self.parkingTime = parking.dateOfParking
            
        }
        else
        {
            //Add Page
            self.parkingTime = Date()
            
        }
        
        setUI()
        
        tfParkingLocation.delegate = self
        tfBuildingCode.delegate = self
        tfSuiteNum.delegate = self
        
        tfBuildingCode.tag = 0
        tfSuiteNum.tag = 1
        tfParkingLocation.tag = 2
        
        selectCarGesture.addTarget(self, action: #selector(selectCarAreaTapped(gesture:)))
        numOfHoursGesture.addTarget(self, action: #selector(numOfHoursAreaTapped(gesture:)))

 
    }
    
    func setUpLocationManager()
    {
        
        locationManager = CLLocationManager()
        
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled()
        {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
        }
        else
        {
            
            let actionSheet = UIAlertController(title: "Permission not Accesible", message: "Enable location Permission in Settings to use your location", preferredStyle: .alert)
                   

            self.present(actionSheet, animated: true, completion: nil)
        }
    }
    
    @objc func addParking()
    {
        self.view.endEditing(true)
        
        guard let licensePlateNumber = carNumber else
        {
            
            let title = "Select Valid Car"
            let message = "Car value should not be empty"
            
            self.showAlert(title: title, message: message)
            return
            
        }
        
        guard let buildingCode = buildingCode, buildingCode.isValidBuildingCode() else
        {
            
            let title = "Invalid Building code"
            let message = "Building code should be exactly 5 alphanumeric characters"
            
            self.showAlert(title: title, message: message)
            return
        }
        
        guard let suiteNum = suitNo, suiteNum.isValidHostSuiteNum() else
        {
            
            let title = "Invalid Suite number"
            let message = "Building code should be min 2 and max 5 alphanumeric characters"
            
            self.showAlert(title: title, message: message)
            return
            
        }

        guard let numOfHours = self.numOfHours else
        {
            
            let title = "Select Valid Parking Hours"
            let message = "Parking hours should not be empty"
            
            self.showAlert(title: title, message: message)
            return
            
        }
        
        guard let location = self.location else
        {
            
            let title = "Location Cannot be empty"
            let message = "Choose a valid Parking Location"
            
            self.showAlert(title: title, message: message)
            return
            
        }
        
        let parkingDate = parkingtimeDatePicker.date
        
        
        let parking = Parking(id: nil, licensePlateNumber: licensePlateNumber, buildingCode: buildingCode, hostSuitNum: suiteNum, parkingHours: numOfHours, location: location, dateOfParking: parkingDate)

        let result = DBHelper.getInstance().addParking(parking: parking)
        
        
        if result.type == .success
        {
            let title = "Success"
            let message = result.message
            
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { _ in
                self.navigationController?.popViewController(animated: true)
            }))
            
            self.present(alert, animated: true, completion: nil)
        }
        else
        {
            let title = result.type.rawValue
            let message = result.message
            
            showAlert(title: title, message: message)
        }
        
    }
    
    func setUI()
    {
        tfBuildingCode.text = self.buildingCode
        tfSuiteNum.text = self.suitNo
        tfParkingLocation.text = self.location?.address
        
        lblSelectedCar.text = self.carNumber ?? "---Select---"

        lblNumOfHours.text = self.numOfHours?.stringValue() ?? "---Select---"
        
        parkingtimeDatePicker.date = self.parkingTime ?? Date()
        
    }
    
    
    
    func showAlert(title : String, message : String?)
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        
//        alert.show(self, sender: nil)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK:- Button and Gesture Actions
    

    
    
    @IBAction func useLocationButtonClicked(_ sender: UIButton) {
        
        self.view.endEditing(true)

        
        if locationManager == nil
        {
            setUpLocationManager()
        }
        
        if CLLocationManager.locationServicesEnabled()
        {
            locationManager.startUpdatingLocation()
        }
        
    }
    
    
    
    @objc func numOfHoursAreaTapped(gesture: UITapGestureRecognizer)
    {
        self.view.endEditing(true)

        let tTitle = "Parking Hours"
        let mes = "Select the number of hours"

        
        let actionSheet = UIAlertController(title: tTitle, message: mes, preferredStyle: .actionSheet)
        
        let hours = ParkingHour.allCases //CupSize.allCases.map ({ $0.rawValue })
        
        for element in hours
        {
            actionSheet.addAction(UIAlertAction(title: element.stringValue(), style: .default, handler: { action in
                
                let hour = ParkingHour(rawValue: element.rawValue)!
                
                self.numOfHours = hour
                
                self.lblNumOfHours.text = element.stringValue().capitalized
                
            }))
        }
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
            
        }))
        
        self.present(actionSheet, animated: true, completion: nil)
        
    }
    
    @objc func selectCarAreaTapped(gesture: UITapGestureRecognizer)
    {
        self.view.endEditing(true)

        let tTitle = "Select Car"
        let mes = "Select the car for parking"
        
        
        
        DBHelper.getInstance().getUser( completion: { user, res in
            
            if res.type == .success, let user = user
            {
                let actionSheet = UIAlertController(title: tTitle, message: mes, preferredStyle: .actionSheet)

                
                let cars = user.cars
                
                for element in cars
                {
                    actionSheet.addAction(UIAlertAction(title: element.carString(), style: .default, handler: { action in
                        

                        self.carNumber = element.licensePlateNumber
                        
                        self.lblSelectedCar.text = element.carString()
                        
                    }))
                }
                
                actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
                    
                }))
                
                self.present(actionSheet, animated: true, completion: nil)
            }
            else
            {
                self.showAlert(title: "Error", message: res.message)
            }
            
        })
        
        

    }
    
}

//MARK:- TextField Delegate
extension AddParkingVC : UITextFieldDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if textField.tag == 0
        {
            //Buildingcode
            self.buildingCode = self.tfBuildingCode.text
        }
        else if textField.tag == 1
        {
            self.suitNo = self.tfSuiteNum.text
        }
        else
        {
            //Parking Location
            guard let address = textField.text, address != "" else
            {
                self.location = nil
                return
            }
            
            getCoordinatesFromAddress(address: address) { lat, long in
                
                guard let latitude = lat, let longitude = long else
                {
                    self.showAlert(title: "Invalid Location", message: "Address you entered is Invalid")
                    self.location = nil
                    self.tfParkingLocation.text = nil
                    return
                }
                
                self.location = Location(latitude: latitude, longitude: longitude, address: address)
                
            }
        }
        
    }
}


//MARK:- CoreLocation Delegate

extension AddParkingVC: CLLocationManagerDelegate
{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let location = locations.first?.coordinate else
        {
            return
        }
        
        self.getAddressForCoordinates(latitude: location.latitude, longitude: location.longitude) { address in
            
            
            guard address != nil else
            {
                self.showAlert(title: "Invalid Location", message: "Unable to get current Location")
                
                self.location = nil
                self.tfParkingLocation.text = nil
                return
            }

            self.tfParkingLocation.text = address
            
            print(address)
            self.location = Location(latitude: location.latitude, longitude: location.longitude, address: address)
            
            
        }
        
        
        manager.stopUpdatingLocation()


    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        print(error.localizedDescription)
        manager.stopUpdatingLocation()
    }
    
    
    //MARK: Location Helper Methods
    func getAddressForCoordinates(latitude : Double, longitude: Double, completion: @escaping (String?) -> Void)
    {
        let clLocation = CLLocation(latitude: latitude, longitude: longitude)

        self.geocoder.reverseGeocodeLocation(clLocation) { placemarks, error in
            
            guard error == nil, let placemarks = placemarks, placemarks.count > 0 else
            {
                completion(nil)
                return
            }
            
            let obtainedLocation = placemarks.first!
            
            var locationStrings = [String]()
            
            
            if let ocean = obtainedLocation.ocean
            {
                locationStrings.append(ocean)
            }
            else
            {
                if let country = obtainedLocation.country
                {
                    locationStrings.append(country)
                }
                
                if let province = obtainedLocation.administrativeArea
                {
                    locationStrings.append(province)

                }
                
                if let city = obtainedLocation.locality
                {
                    locationStrings.append(city)

                }
                
                if let street = obtainedLocation.thoroughfare
                {
                    locationStrings.append(street)

                }
                
                if let inlandWater = obtainedLocation.inlandWater
                {
                    locationStrings.append(inlandWater)

                }
                
            }
            
            
            var tStr: String? = locationStrings.reversed().joined(separator: ",")
            
            if tStr == ""
            {
                tStr = nil
            }
            
            completion(tStr)
        }
    }
    
    
    func getCoordinatesFromAddress(address: String,completion: @escaping (Double?, Double?) -> Void)
    {
        self.geocoder.geocodeAddressString(address) { [self] placemarks, error  in
            
            guard error == nil, let placemarks = placemarks, placemarks.count > 0 else
            {
                completion(nil, nil) //No such Location
                return
            }
            
            guard let locationCoordinates = placemarks.first?.location?.coordinate else
            {
                completion(nil, nil) //No such Location
                return
            }
            
            completion(locationCoordinates.latitude,locationCoordinates.longitude)
            
        }

    }

}
