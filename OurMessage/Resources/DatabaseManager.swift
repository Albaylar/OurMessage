//
//  DatabaseManager.swift
//  OurMessage
//
//  Created by Furkan Deniz Albaylar on 10.07.2022.
//

import Foundation
import FirebaseDatabase

final class DataBaseManager{
    
    static let shared = DataBaseManager()
    
    private let database = Database.database().reference()
    

}

// MARK --- ACCOUNT MANANGEMENT
extension DataBaseManager{
    public func userExists(with email: String,
                           completion: @escaping((Bool) -> Void)){
        
        var safeEmail = email.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        
        database.child(safeEmail).observeSingleEvent(of: .value, with: { snapshot in
            guard snapshot.value as? String != nil    else {
                completion(false)
                return
            }
            completion(true)
        })
        
    }
    
    /// İNSERTS NEW USER TO DATABASE
    public func insertUser (with user : ChatAppUser){
        database.child(user.safeEmail).setValue(["First_name " :user.firstName,
                                               "Last Name" :user.lastName,
            ])
    }
}
struct ChatAppUser {
    let firstName : String
    let lastName : String
    let emailAdress : String
    //let profilePictureUrl : String
    
    var safeEmail: String {
        var safeEmail = emailAdress.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        return safeEmail
    }
    
    }

