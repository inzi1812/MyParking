//
//  DBHelper.swift
//  MyParking
//
//  Created by Inzi Hussain on 2021-05-16.
//

import Foundation
import FirebaseFirestore

class DBHelper
{
    private static var shared : DBHelper?
    
    
    private let USER_ENTITY = "Users"
    private let PARKING_ENTITY = "Parkings"
    
    static func getInstance() -> DBHelper
    {
        if shared == nil
        {
            shared = DBHelper()
        }
        
        return shared!
    }
    
    private var firestore : Firestore
    
    private init() {
        
        self.firestore = Firestore.firestore()
    }
    

}

//MARK:- Methods to perform FireStore Actions



//MARK: User Actions

extension DBHelper
{
    //TODO:- Constraint Checks should be done within these Functions
    
    //MARK: Public Methods
    
    func addUser(user : User, completion : @escaping (Result) -> Void)
    {
        
        checkIfUserPresent(mail: user.email) { _, tResult in
            
            if tResult.type != .failure
            {
                //Means User Exists
                var temp = tResult
                temp.type = .failure
                completion(temp)
                return
            }
            
            
            var result : Result
            //Sign up
            do
            {
                let _ = try self.firestore.collection(self.USER_ENTITY).addDocument(from: user)
                
                result = Result(type: .success, message: "User added Successfully")
            }
            catch let err
            {
                print(err)
                result = Result(type: .failure, message: "Error While adding User")
            }
            
            completion(result)
            
        }
        
        
        
    }
    
    func validateUser(mail : String, pwd : String, completion : @escaping (User?,Result) -> ())
    {
        checkIfUserPresent(mail: mail) { user, tResult in
        
            if tResult.type != .success
            {
                //Means User does not exist or error Occured
                var temp = tResult
                temp.type = .failure
                completion(nil, temp)
                return
            }
            
            
            if user?.pwd == pwd
            {
                //Success
                let result = Result(type: .success, message: "User Validation Success")
                completion(user, result)
            }
            else
            {
                //Mismatch
                let result = Result(type: .failure, message: "Error: Username - Password mismatch")

                completion(nil, result)
            }
        }
    }
    
    
    func addVehicle(plateNumber : String, user: User, completion : @escaping (Result) -> Void)
    {
        
        checkLicensePlateNumberExistsInSystem(plateNumber: plateNumber) { tResult in
            
            if tResult.type != .failure
            {
                var temp = tResult
                temp.type = .failure
                //License Plate is already in the system
                completion(temp)
                return
            }
            
        }
        
        var tUser = user
        
        let car = Car(licensePlateNumber: plateNumber, parkings: [])
        
        tUser.cars.append(car)
        
        do
        {
            try firestore.collection("Users").document(user.email).setData(from: tUser)
            let result = Result(type: .success, message: "Vehicle Added Successfully")
            
            completion(result)
            
        }
        catch let err
        {
            let result = Result(type: .success, message: "Error : \(err.localizedDescription)")
            
            completion(result)
        }
        
        
    }
    
    //MARK: Private Methods
    private func checkIfUserPresent(mail : String, completion : @escaping (User?,Result) -> ())
    {
        firestore.collection(USER_ENTITY).whereField("email", isEqualTo: mail).getDocuments { queryResults, err in
            
            
            if let doc = queryResults?.documents.first
            {
                do
                {
                    
                    let user = try doc.data(as: User.self)
                    let result = Result(type: .success, message: "User Already Exists")

                    completion(user, result)
                }
                catch let err
                {
                    let result = Result(type: .noConnection, message: "Error: \(err.localizedDescription)")
                    completion(nil, result)
                }
            }
            else
            {
                let result = Result(type: .failure, message: "User is Not There")
                completion(nil, result)
            }
            
        }
    }
    
    private func checkLicensePlateNumberExistsInSystem(plateNumber : String, completion : @escaping (Result ) -> Void)
    {
        firestore.collection(USER_ENTITY).whereField("licensePlateNum", arrayContains: plateNumber).getDocuments { queryResults, err in
            
            if let _ = queryResults?.documents.first
            {
                let result = Result(type: .success, message: "License Plate Number Already Exists in the System")
                completion(result)
                
            }
            else
            {
                let result = Result(type: .failure, message: "License Plate Number is Not in Database")
                
                completion(result)
            }
            
        }
    }
    
}

//MARK: Parking Actions

extension DBHelper
{
    
}
