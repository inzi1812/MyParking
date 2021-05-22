//
//  Result.swift
//  MyParking
//
//  Created by Inzi Hussain on 2021-05-18.
//

import Foundation


enum ResultType : String
{
    case success = "Success"
    case failure = "Failure"
    case noConnection = "No Internet Connection"
}

struct Result {
    var type : ResultType
    var message : String
}
