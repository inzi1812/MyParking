//
//  Car.swift
//  MyParking
//
//  Created by Inzi Hussain on 2021-05-18.
//

import Foundation


struct Car: Codable {
    
    var licensePlateNumber : String
    var parkings : [Parking]
}