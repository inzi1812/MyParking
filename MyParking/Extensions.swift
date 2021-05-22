//
//  Extensions.swift
//  MyParking
//
//  Created by RD on 18/05/21.
//

import Foundation

extension String {
    
    
    var isAlphanumeric: Bool {
            return !isEmpty && range(of: "[^a-zA-Z0-9]", options: .regularExpression) == nil
        }
    
    func isValidEmail() -> Bool {
        // here, `try!` will always succeed because the pattern is valid
        
        let regex = try! NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", options: .caseInsensitive)
        return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
    }
    
    func isValidCarPlateNumber() -> Bool {
       
        if !isAlphanumeric
        {
            return false
        }
        
        if(self.count >= 2 && self.count <= 8){
            
            return true
        }
        
        else {
            return false
        }
    }
    
    func isValidBuildingCode() -> Bool
    {
        return (isAlphanumeric && self.count == 5)
    }
    
    func isValidHostSuiteNum() -> Bool
    {
        if !isAlphanumeric
        {
            return false
        }
        
        if(self.count >= 2 && self.count <= 5){
            
            return true
        }
        
        else {
            return false
        }
    }
}
