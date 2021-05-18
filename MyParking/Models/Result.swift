//
//  Result.swift
//  MyParking
//
//  Created by Inzi Hussain on 2021-05-18.
//

import Foundation


enum ResultType
{
    case success
    case failure
    case noConnection
}

struct Result {
    var type : ResultType
    var message : String
}
