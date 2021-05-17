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
    
    
    let USER_ENTITY = "Users"
    let PARKING_ENTITY = "Parkings"
    
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
    
    //MARK:- Methods to perform FireStore Actions
    
    //TODO:- Constraint Checks should be done within these Functions
    
    func addUser(user : User) -> Bool
    {
        var isAddSuccess = false
        //Sign up
        do
        {
            let _ = try firestore.collection(USER_ENTITY).addDocument(from: user)
            isAddSuccess = true
        }
        catch let err
        {
            print(err)
        }
        
        return isAddSuccess
    }
    
    func getUsers(completion: @escaping (([User]?) -> () ))
    {
        
        //Return Users Array if perform Succesfully or return nil
        firestore.collection(USER_ENTITY).getDocuments { results, err in
            
            guard err == nil else
            {
                print(err.debugDescription)
                
                completion(nil)
                return
            }
            
            var users = [User]()
            
            results?.documents.forEach({ result in
                
                do
                {
                    let user = try result.data(as: User.self)
                    users.append(user!)
                }
                catch let err
                {
                    print(err)
                }
                
            })
         
            completion(users)
        }
    }
    
    
    
    
}
