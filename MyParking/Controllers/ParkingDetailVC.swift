//
//  ParkingDetailVC.swift
//  MyParking
//
//  Created by Inzi Hussain on 2021-05-22.
//

import UIKit
import MapKit

class ParkingDetailVC: UIViewController {

    @IBOutlet weak var lblCarNumber: UILabel!
    
    @IBOutlet weak var lblBuildingCode: UILabel!
    
    @IBOutlet weak var lblSuiteNum: UILabel!
    
    @IBOutlet weak var lblParkingDate: UILabel!
    
    
    @IBOutlet weak var lblParkingHours: UILabel!
    
    @IBOutlet weak var mapView: MKMapView!
    
    
    @IBOutlet weak var showDirectionsBtn: UIButton!
    
    
    
    var parking : Parking!
    
    let locationManager = CLLocationManager()

    
    private let dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        setUpLocationManager()
        setUI()
        showDirectionsBtn.addTarget(self, action: #selector(launchNavigation), for: .touchUpInside)
        
        
    }
    
    func setUpLocationManager()
    {
        
        
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled()
        {
//            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
        }
        else
        {
            
            let actionSheet = UIAlertController(title: "Permission not Accesible", message: "Enable location Permission in Settings to use your location", preferredStyle: .alert)
                   

            self.present(actionSheet, animated: true, completion: nil)
        }
    }
    
    private func setUI()
    {
        self.lblCarNumber.text = parking.licensePlateNumber
        self.lblBuildingCode.text = parking.buildingCode
        self.lblSuiteNum.text = parking.hostSuitNum
        self.lblParkingHours.text = parking.parkingHours.stringValue()
        
        
        dateFormatter.dateFormat = "MMM dd YYYY hh:mm a"
        self.lblParkingDate.text = dateFormatter.string(from: self.parking.dateOfParking)
        
        self.displayLocationOnMap(location: parking.location)
    }
    
    
    func displayLocationOnMap(location : Location)
    {
        mapView.removeAnnotations(mapView.annotations)

        
        let clLocation = CLLocationCoordinate2D(latitude: location.latitude!, longitude: location.longitude!)
        
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: clLocation, span: span)
        
        self.mapView.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = clLocation
        annotation.title = "your Vehicle is here"
        
        self.mapView.addAnnotation(annotation)
    }

    @objc private func launchNavigation()
    {
        let lat = parking.location.latitude!
        let long = parking.location.longitude!
        let coOrdinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        
        
        let distance = CLLocationDistance(1000)
        
        let regionspan = MKCoordinateRegion(center: coOrdinate, latitudinalMeters: distance, longitudinalMeters: distance)
        
        
        let options = [MKLaunchOptionsMapCenterKey : regionspan.center, MKLaunchOptionsMapSpanKey: regionspan.span] as [String : Any]
        
        let placemark = MKPlacemark(coordinate: coOrdinate)
        
        let mapitem = MKMapItem(placemark: placemark)
        
        mapitem.name = "Parking is here"
        
        mapitem.openInMaps(launchOptions: options)
        
        
        
    }
    
    
    private func showAlert(title : String, message : String){
        
        let alert = UIAlertController(title: title.uppercased(), message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
    

}


//extension ParkingDetailVC : CLLocationManagerDelegate
//{
//
//}
