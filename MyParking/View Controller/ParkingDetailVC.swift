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
        
        
        
//        setUI()
        
        
    }
    
    private func setUI()
    {
        self.lblCarNumber.text = parking.licensePlateNumber
        self.lblBuildingCode.text = parking.buildingCode
        self.lblSuiteNum.text = parking.hostSuitNum
        self.lblParkingHours.text = parking.parkingHours.stringValue()
        
        
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

    
    
    

}
