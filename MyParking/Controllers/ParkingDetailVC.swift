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

    var sourceLocation : CLLocationCoordinate2D!
    
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
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            
            locationManager.startUpdatingLocation()
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
        
    }
    
    
    func displayLocationOnMap(location : Location)
    {
        mapView.removeAnnotations(mapView.annotations)

        let destinationLocation = CLLocationCoordinate2D(latitude: location.latitude!, longitude: location.longitude!)
        
        
        let destinationAnnotation = MKPointAnnotation()
        destinationAnnotation.coordinate = destinationLocation
        destinationAnnotation.title = "your Vehicle is here"
        
        let sourceAnnotation = MKPointAnnotation()
        sourceAnnotation.coordinate = sourceLocation
        sourceAnnotation.title = "you are here"
        
        self.mapView.addAnnotation(sourceAnnotation)
        self.mapView.addAnnotation(destinationAnnotation)
        
        
        let sourcePlacemark = MKPlacemark(coordinate: sourceLocation)
        let destPlacemark = MKPlacemark(coordinate: destinationLocation)

        
        let directionRequest = MKDirections.Request()
        directionRequest.source = MKMapItem(placemark: sourcePlacemark)
        directionRequest.destination = MKMapItem(placemark: destPlacemark)
        directionRequest.transportType = .automobile
        
        
        let directions = MKDirections(request: directionRequest)
        
        directions.calculate { (response, error) in
             guard let directionResonse = response else {
                 if let error = error {
                     print("we have error getting directions = \(error.localizedDescription)")
                 }
                 return
             }
             
             //get route and assign to our route variable
             let route = directionResonse.routes[0]
             
            self.mapView.addOverlay(route.polyline, level: .aboveRoads)
             
            let rect = route.polyline.boundingMapRect.insetBy(dx: 100, dy: 100)
            self.mapView.setRegion(MKCoordinateRegion(rect), animated: true)
         }
        
        mapView.delegate = self
        
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


extension ParkingDetailVC : CLLocationManagerDelegate
{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let location = locations.first?.coordinate else
        {
            return
        }
        
        sourceLocation = location
        mapView.removeOverlays(mapView.overlays)
        self.displayLocationOnMap(location: parking.location)

        
//        manager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        print(error.localizedDescription)
//        manager.stopUpdatingLocation()
    }
    
}

extension ParkingDetailVC : MKMapViewDelegate
{
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.blue
        renderer.lineWidth = 4.0
        return renderer
    }
}
