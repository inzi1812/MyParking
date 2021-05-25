//
//  ParkingHours.swift
//  MyParking
//
//  Created by Inzi Hussain on 2021-05-16.
//

import Foundation

enum ParkingHour: Int, Codable, CaseIterable
{
    case oneHourOrLess       = 1
    case fourHoursOrLess     = 4
    case twelveHoursOrLess   = 12
    case twentyFourHours     = 24
    
    func stringValue() -> String
    {
        switch self {
        case .oneHourOrLess:
            return "Less than an hour"
        case .fourHoursOrLess:
            return "Less than 4 hours"
        case .twelveHoursOrLess:
            return "Less than 12 hours"
        default:
            return "24 hours"
        }
    }
    
    func shortString() -> String
    {
        switch self {
        case .oneHourOrLess:
            return "1 Hr"
        case .fourHoursOrLess:
            return "4 Hrs"
        case .twelveHoursOrLess:
            return "12 Hrs"
        default:
            return "24 Hrs"
        }
    }
}
