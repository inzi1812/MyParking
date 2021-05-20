//
//  DBHelper.swift
//  MyParking
//
//  Created by Inzi Hussain on 2021-05-16.
//

import Foundation
import FirebaseFirestore
import Network

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
    
    
    private let networkMonitor : NWPathMonitor
    private let queue = DispatchQueue(label: "Monitor")
    
    private init() {
        
        self.firestore = Firestore.firestore()
        
        self.networkMonitor = NWPathMonitor()
        
        networkMonitor.start(queue: queue)
        
    }
    

}



//MARK: User Actions

extension DBHelper
{
    
    //MARK: Public Methods
    
    func addUser(user : User, completion : @escaping (Result) -> Void)
    {
        
        checkNetworkConnection { isConnected in
            
            if isConnected
            {
                //Connected to Internet
                self.addUserToFireStore(user: user) { tResult in
                    completion(tResult)
                    
                }
            }
            else
            {
                let result = Result(type: .noConnection, message: "no Internet Connection. Try Again after reconnecting.")
                
                completion(result)
            }
            
        }
       
    }
    
    func validateUser(mail : String, pwd : String, completion : @escaping (User?,Result) -> ())
    {
        checkNetworkConnection { isConnected in
            
            if isConnected
            {
                //Connected to Internet
                self.validateUserWithFireStore(mail: mail, pwd: pwd) { tUser, tResult in
                    
                    completion(tUser, tResult)
                    
                }
            }
            else
            {
                let result = Result(type: .noConnection, message: "no Internet Connection. Try Again after reconnecting.")
                
                completion(nil,result)
            }
            
        }
    }
    
    func addVehicle(plateNumber : String, user: User, completion : @escaping (Result) -> Void)
    {
        
        checkNetworkConnection { isConnected in
            
            if isConnected
            {
                //Connected to Internet
                self.addVehicleinFirestore(plateNumber: plateNumber, user: user) { tResult in
                    
                    completion(tResult)
                }
                
            }
            else
            {
                let result = Result(type: .noConnection, message: "no Internet Connection. Try Again after reconnecting.")
                
                completion(result)
            }
            
        }

        
    }
    
    func getParkings(forUser user : User, completion: @escaping([Parking]?, Result) -> Void)
    {
        checkNetworkConnection { isConnected in
            
            if isConnected
            {
                //Connected to Internet
              
                
            }
            else
            {
                let result = Result(type: .noConnection, message: "no Internet Connection. Try Again after reconnecting.")
                
                completion(nil,result)
            }
            
        }
    }
    
    
    
    //MARK: Network Mehods
    private func checkNetworkConnection(completion: @escaping (Bool) -> Void)
    {
        if networkMonitor.currentPath.status == .satisfied
        {
            completion(true)
        }
        else
        {
            completion(false)
        }
    }
    
}


//MARK: FiresStore Private Methods

extension DBHelper
{
    //MARK: Private Methods

    
    private func addUserToFireStore(user : User, completion : @escaping (Result) -> Void)
    {
        
        checkIfUserPresentinFireStore(mail: user.email) { _, tResult in
            
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
    

    
    private func validateUserWithFireStore(mail : String, pwd : String, completion : @escaping (User?,Result) -> ())
    {
        checkIfUserPresentinFireStore(mail: mail) { user, tResult in
        
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
    
    

    
    private func checkIfUserPresentinFireStore(mail : String, completion : @escaping (User?,Result) -> ())
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
    
    private func checkLicensePlateNumberExistsInFirestore(plateNumber : String, completion : @escaping (Result ) -> Void)
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
    
    
    private func addVehicleinFirestore(plateNumber : String, user: User, completion : @escaping (Result) -> Void)
    {
        
        checkLicensePlateNumberExistsInFirestore(plateNumber: plateNumber) { tResult in
            
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
    
    
    private func getParkingsFromFireStore(forUser user : User, completion: @escaping([Parking]?, Result) -> Void)
    {
        
        let platenumbers = user.cars.map({ $0.licensePlateNumber })
        
        firestore.collection(USER_ENTITY).whereField("licensePlateNumber", arrayContains: platenumbers).order(by: "dateOfParking",descending: true).getDocuments { queryResults, err in
            
            
            guard err == nil else
            {
                completion(nil, Result(type: .failure, message: "Error: \(err!.localizedDescription)"))
                return
            }
            
            var parkings = [Parking]()
            
            queryResults?.documents.forEach({ document in
                
                do
                {
                   let parking = try document.data(as: Parking.self)
                    parkings.append(parking!)
                }
                catch let err
                {
                    print(err.localizedDescription)
                    
                    completion(nil, Result(type: .failure, message: "Error Getting Parking \(err.localizedDescription)"))
                    return
                }
                
                completion(parkings, Result(type: .success, message: "Parkings are retrieved Succesfully"))
            })
            
        }
    }
    
}
