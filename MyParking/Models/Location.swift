//
//  Location.swift
//  MyParking
//
//  Created by Inzi Hussain on 2021-05-16.
//

import Foundation

struct Location : Codable
{
    var latitude : Double?
    {
        didSet
        {
            setAddressFromCoOrdinates()
        }
    }
    var longitude : Double?
    {
        didSet
        {
            setAddressFromCoOrdinates()
        }
    }
    
    var address : String?
    {
        didSet
        {
            setLatAndLongFromAddress()
        }
    }
    
    
    
    func setLatAndLongFromAddress()
    {
        guard let address = self.address else {
            // Address is nil
            return
        }
        
        //Get Lat And Long co-ordinates from Address and set them
    }
    
    func setAddressFromCoOrdinates() {
        
        guard let lat = latitude, let long = longitude else {
            //One of (OR) both Lat and Long are nil
            return
        }
        //Set Address
    }
    
}
