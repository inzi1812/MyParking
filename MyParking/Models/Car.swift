//
//  Car.swift
//  MyParking
//
//  Created by Inzi Hussain on 2021-05-18.
//

import Foundation
import FirebaseFirestoreSwift



struct Car: Codable {
    
    
    @DocumentID var id : String?
    
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
