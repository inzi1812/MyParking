//
//  ParkingDetailsVC.swift
//  MyParking
//
//  Created by RD on 2021-05-23.
//

import UIKit
import MapKit

class ParkingDetailsVC: UIViewController {

    @IBOutlet weak var lblCarplateNumber: UILabel!
    @IBOutlet weak var lblBuildingCode: UILabel!
    @IBOutlet weak var lblSuiteNum: UILabel!
    @IBOutlet weak var lblParkingDate: UILabel!
    @IBOutlet weak var lblParkingHours: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var showDirectionsBtn: UIButton!
    
    var parking : Parking!
    let locationManager = CLLocationManager()

    private let dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        dateFormatter.dateFormat = "HH:mm E, d MMM y"
        // Do any additional setup after loading the view.
        loadParkingDetails()
        
    }
    
    private func loadParkingDetails(){
        
        lblCarplateNumber.text = self.parking.licensePlateNumber
        lblBuildingCode.text = self.parking.buildingCode
        lblSuiteNum.text = self.parking.hostSuitNum
        lblParkingDate.text = dateFormatter.string(from: (self.parking.dateOfParking) )
        lblAddress.text = self.parking.location.address
        
        showDirectionsBtn.isHidden = true
        
        self.displayLocationOnMap(location: self.parking.location)
        
    }
    
    private func displayLocationOnMap(location : Location){
        
        let locationCoordinates : CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: location.latitude!, longitude: location.longitude!)
        
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: locationCoordinates, span: span)
        self.mapView.setRegion(region, animated: true)
        
        // add annotation
        let annotation = MKPointAnnotation()
        annotation.coordinate = locationCoordinates
        annotation.title = "Your car is here"
        self.mapView.addAnnotation(annotation)
    }
    
//    private func setUI()
//    {
//        self.lblCarNumber.text = parking.licensePlateNumber
//        self.lblBuildingCode.text = parking.buildingCode
//        self.lblSuiteNum.text = parking.hostSuitNum
//        self.lblParkingHours.text = parking.parkingHours.stringValue()
//
//        self.lblParkingDate.text = dateFormatter.string(from: self.parking.dateOfParking)
//
//        self.displayLocationOnMap(location: parking.location)
//    }
//
//
//    func displayLocationOnMap(location : Location)
//    {
//        mapView.removeAnnotations(mapView.annotations)
//
//
//        let clLocation = CLLocationCoordinate2D(latitude: location.latitude!, longitude: location.longitude!)
//
//        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
//        let region = MKCoordinateRegion(center: clLocation, span: span)
//
//        self.mapView.setRegion(region, animated: true)
//
//        let annotation = MKPointAnnotation()
//        annotation.coordinate = clLocation
//        annotation.title = "Your Vehicle is here"
//
//        self.mapView.addAnnotation(annotation)
//    }

    
    
    @IBAction func btnDirectionsClicked(_ sender: Any) {
        
        
    }
    

}
