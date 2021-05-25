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
    
    var currentUser : User?
    
    private var firestore : Firestore
    
    
    private let networkMonitor : NWPathMonitor
    private let queue = DispatchQueue(label: "Monitor")
    
    private var isNetworkConnected : NetworkStatus = .connected
    
    private init() {
        
        self.firestore = Firestore.firestore()
        
        self.networkMonitor = NWPathMonitor()
        
        networkMonitor.pathUpdateHandler = { (path) in
            if let statusConnected: NetworkStatus = path.status == .satisfied ? .connected : .disconnected
            {
                if self.isNetworkConnected != statusConnected
                {
                    self.isNetworkConnected = statusConnected
                }
            }
        }

        
        networkMonitor.start(queue: queue)
        
    }
    

}



//MARK: User Actions

extension DBHelper
{
    
    //MARK: Public Methods
    
    func addUser(user : User, completion : @escaping (Result) -> Void)
    {
        
        
        if checkNetworkConnection()
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
    
    
    func getUser(email : String, completion: @escaping (User?, Result) -> Void)
    {
        if checkNetworkConnection()
        {
            //Connected to Internet
            
            self.checkIfUserPresentinFireStore(mail: email) { user, result in
                completion(user, result)
            }
            
        }
        else
        {
            let result = Result(type: .noConnection, message: "no Internet Connection. Try Again after reconnecting.")
            
            completion(nil,result)
        }
    }
    
    func validateUser(mail : String, pwd : String, completion : @escaping (User?,Result) -> ())
    {
        
        if checkNetworkConnection()
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
    
    func addVehicle(car : Car, completion : @escaping (Result) -> Void)
    {
        
        if checkNetworkConnection()
        {
            
            //Connected to Internet
            self.addVehicleinFirestore(car: car, user: currentUser!) { tResult in
                
                completion(tResult)
            }
            
        }
        else
        {
            let result = Result(type: .noConnection, message: "no Internet Connection. Try Again after reconnecting.")
            
            completion(result)
        }
        
        

        
    }
    
    func getParkings(completion: @escaping([Parking]?, Result) -> Void)
    {
        
        if checkNetworkConnection()
        {
            //Connected to Internet
            
            self.getParkingsFromFireStore(forUser: currentUser!) { tParkings, result in
                
                completion(tParkings,result)
                
            }
            
        }
        else
        {
            let result = Result(type: .noConnection, message: "no Internet Connection. Try Again after reconnecting.")
            
            completion(nil,result)
        }
        
    }
    
    
    func getParking(id: String, completion: @escaping(Parking?, Result) -> Void)
    {
        
        if checkNetworkConnection()
        {
            //Connected to Internet
            
            self.getParkingFromFireStore(id: id, forUser: currentUser!) { tParkings, result in
                
                completion(tParkings,result)
                
            }
            
        }
        else
        {
            let result = Result(type: .noConnection, message: "no Internet Connection. Try Again after reconnecting.")
            
            completion(nil,result)
        }
        
    }
    
    
    func addParking(parking: Parking) -> Result
    {
        if checkNetworkConnection()
        {
            return self.addParkingToFireStore(parking: parking)
        }
        else
        {
            let result = Result(type: .noConnection, message: "no Internet Connection. Try Again after reconnecting.")
            
            return result
        }
    }
    
    
    func deleteParking(parkingId : String, completion: @escaping (Result) -> Void)
    {
        if checkNetworkConnection()
        {
            return self.deleteParkingFromFirestore(id: parkingId) { res in
                completion(res)
            }
        }
        else
        {
            let result = Result(type: .noConnection, message: "no Internet Connection. Try Again after reconnecting.")
            
            completion(result)
        }
    }
    
    func deleteUser(completion: @escaping (Result) -> Void)
    {
        if checkNetworkConnection()
        {
            return self.deleteUserFromFirestore(email: currentUser!.email, completion: { res in
                completion(res)
            })
        }
        else
        {
            let result = Result(type: .noConnection, message: "no Internet Connection. Try Again after reconnecting.")
            
            completion(result)
        }
    }
    
    //MARK: Network Mehods
    private func checkNetworkConnection() -> Bool
    {
        return isNetworkConnected == .connected
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
                self.currentUser = user

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
                    let result = Result(type: .success, message: "User Exists")

                    completion(user, result)
                }
                catch let err
                {
                    let result = Result(type: .failure, message: "Error: \(err.localizedDescription)")
                    completion(nil, result)
                }
            }
            else
            {
                let result = Result(type: .failure, message: "No Such User")
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
    
    
    private func addVehicleinFirestore(car : Car, user: User, completion : @escaping (Result) -> Void)
    {
        
        checkLicensePlateNumberExistsInFirestore(plateNumber: car.licensePlateNumber) { tResult in
            
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
        
        
        tUser.cars.append(car)
        

            firestore.collection(USER_ENTITY).whereField("email", isEqualTo: user.email).getDocuments(completion: { queries, err in
                
                
                guard err == nil else
                {
                    completion(Result(type: .failure, message: "Error: \(err?.localizedDescription ?? "")"))
                    return
                }
                
                guard let document = queries?.documents.first else
                {
                    completion(Result(type: .failure, message: "Error: \(err?.localizedDescription ?? "")"))
                    return
                }
                
                do
                {
                    try document.reference.setData(from: tUser)
                }
                catch let err
                {
                    let result = Result(type: .success, message: "Error : \(err.localizedDescription)")
                    
                    completion(result)
                    return
                }
                
                
                completion(Result(type: .success, message: "Updated Successfully"))
                
            })
            

        
    }
    
    
    private func getParkingsFromFireStore(forUser user : User, completion: @escaping([Parking]?, Result) -> Void)
    {
        
        let platenumbers = user.cars.map({ $0.licensePlateNumber })
        
        firestore.collection(PARKING_ENTITY).whereField("licensePlateNumber", in: platenumbers).order(by: "dateOfParking", descending: true).getDocuments { queryResults, err in
            
            
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
                
                
            })
            
            completion(parkings, Result(type: .success, message: "Parkings are retrieved Succesfully"))
            
        }
    }
    
    private func getParkingFromFireStore(id: String, forUser user : User, completion: @escaping(Parking?, Result) -> Void)
    {
        
        let platenumbers = user.cars.map({ $0.licensePlateNumber })
        
        firestore.collection(PARKING_ENTITY).whereField("licensePlateNumber", in: platenumbers).whereField("id", isEqualTo: id).getDocuments { queryResults, err in
            
            
            guard err == nil else
            {
                completion(nil, Result(type: .failure, message: "Error: \(err!.localizedDescription)"))
                return
            }
            
            
            guard queryResults?.documents.count == 1, let document = queryResults?.documents.first else
            {
                completion(nil, Result(type: .failure, message: "Error Getting Parking"))
                return
            }
            

            do
            {
                let parking = try document.data(as: Parking.self)
                completion(parking, Result(type: .success, message: "Parking retrieved Succesfully"))
                
            }
            catch let err
            {
                print(err.localizedDescription)
                
                completion(nil, Result(type: .failure, message: "Error Getting Parking \(err.localizedDescription)"))
                return
            }
            
        }
    }
    
    
    private func addParkingToFireStore(parking: Parking) -> Result
    {
        var result : Result
        //Sign up
        do
        {
            let _ = try self.firestore.collection(self.PARKING_ENTITY).addDocument(from: parking)
            
            result = Result(type: .success, message: "Parking added Successfully")
        }
        catch let err
        {
            print(err)
            result = Result(type: .failure, message: "Error While adding Parking")
        }
        
        return result

    }
    
    private func deleteParkingFromFirestore(id: String, completion : @escaping (Result) -> Void)
    {
        firestore.collection(PARKING_ENTITY).document(id).delete { err in
            
            if err != nil
            {
                let result = Result(type: .failure, message: "Error: \(err?.localizedDescription)")
                completion(result)
            }
            else
            {
                completion(Result(type: .success, message: "Parking Deleted Succesfully"))
            }
            
        }
    }
    
    private func deleteAllParkingsFromFirestore(for plateNumbers: [String], completion : @escaping (Result) -> Void)
      {
        firestore.collection(PARKING_ENTITY).whereField("licensePlateNumber", in: plateNumbers).getDocuments { queries, err in
          guard err == nil else
          {
            completion(Result(type: .failure, message: "Error: \(err?.localizedDescription ?? "")"))
            return
          }
          guard let documents = queries?.documents else
          {
            completion(Result(type: .failure, message: "Error: No Entry Available"))
            return
          }
          for document in documents
          {
            document.reference.delete()
          }
          completion(Result(type: .success, message: "Parkings Deleted Successfully"))
        }
      }
    
      private func deleteUserFromFirestore(email: String, completion : @escaping (Result) -> Void)
        {
          firestore.collection(USER_ENTITY).whereField("email", isEqualTo: currentUser!.email).getDocuments(completion: { queries, err in
            guard err == nil else
            {
              completion(Result(type: .failure, message: "Error: \(err?.localizedDescription ?? "")"))
              return
            }
            guard let document = queries?.documents.first else
            {
              completion(Result(type: .failure, message: "Error: \(err?.localizedDescription ?? "")"))
              return
            }
            do
            {
              //Delete all the Parkings for the user
            let user = try document.data(as: User.self)
            self.deleteAllParkingsFromFirestore(for: user!.cars.map({$0.licensePlateNumber})) { result in
              if result.type == .success
              {
                document.reference.delete()
                completion(Result(type: .success, message: "Deleted Successfully"))
              }
              else
              {
                completion(result)
              }
            }
            }
            catch let err
            {
              let result = Result(type: .success, message: "Error : \(err.localizedDescription)")
              completion(result)
              return
            }
          })
        }
    
}



enum NetworkStatus
{
    case connected
    case disconnected
}
