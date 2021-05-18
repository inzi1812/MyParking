//
//  User.swift
//  MyParking
//
//  Created by Inzi Hussain on 2021-05-16.
//

import Foundation
import FirebaseFirestoreSwift

struct User: Codable {
        
    var email : String

    var name : String
    var cars : [Car]
    
    var pwd : String
    
    var contactNumber : String? //Optional
}
