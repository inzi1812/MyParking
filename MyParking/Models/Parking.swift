//
//  Parking.swift
//  MyParking
//
//  Created by Inzi Hussain on 2021-05-16.
//

import Foundation
import FirebaseFirestoreSwift


struct Parking: Codable {
    @DocumentID var id: String? = UUID().uuidString
    
    var licensePlateNumber : String
    
    var buildingCode : String
    var hostSuitNum : String
    
    var parkingHours : ParkingHour
    var location : Location
    
    var dateOfParking : Date
}
