//
//  SessionManager.swift
//  Firebase
//
//  Created by Tardes on 22/1/25.
//

import Foundation
import FirebaseAuth

class SessionManager
{
    static let shared = SessionManager()
    
    private let isLoggedKey = "isLogged"
    private let userTokkenKey = "userToken"
    
    func saveSession (user: FirebaseAuth.User)
    {
        UserDefaults.standard.set(true, forKey: isLoggedKey)
        UserDefaults.standard.set(user.uid, forKey: userTokkenKey)
    }
    
    func getSession () -> FirebaseAuth.User?
    {
        guard let UserID = UserDefaults.standard.string(forKey: userTokkenKey) else
        {
            return nil
        }
        
        guard let currentUser = Auth.auth().currentUser else{ return nil }
        
        
        if currentUser.uid == UserID
        {
            return currentUser
        }
        
        return nil
        
        
    }
    
    func clearSession ()
    {
        UserDefaults.standard.removeObject(forKey: isLoggedKey)
        UserDefaults.standard.removeObject(forKey: userTokkenKey)
        
    }
    
    func isAuthenticated () -> Bool
    {
        
        return UserDefaults.standard.bool(forKey: isLoggedKey)
    }
    
}
