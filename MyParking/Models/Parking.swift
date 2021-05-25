//
//  Parking.swift
//  MyParking
//
//  Created by Inzi Hussain on 2021-05-16.
//

import Foundation
import FirebaseFirestoreSwift


struct Parking: Codable {
    
    var id: String?
    
    var userId : String //Foreign Key

    var licensePlateNumber : String
    
    var buildingCode : String
    var hostSuitNum : String
    
    var parkingHours : ParkingHour
    var location : Location
    
    var dateOfParking : Date
}
