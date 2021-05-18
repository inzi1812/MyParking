//
//  User.swift
//  MyParking
//
//  Created by Inzi Hussain on 2021-05-16.
//

import Foundation
import FirebaseFirestoreSwift

struct User: Codable {
    
    @DocumentID var id: String?
    var name : String
    var licensePlateNums : [String]
    
    var email : String
    var pwd : String
    
    var contactNumber : String
}
