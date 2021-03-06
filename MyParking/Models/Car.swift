//
//  Car.swift
//  MyParking
//
//  Created by Inzi Hussain on 2021-05-18.
//

import Foundation


struct Car: Codable {
    
    var carName : String = ""
    var licensePlateNumber : String
    
    
    func carString() -> String
    {
        if carName != ""
        {
            return carName + "(\(licensePlateNumber))"
        }
        return licensePlateNumber
    }
}
