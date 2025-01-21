//
//  User.swift
//  Firebase
//
//  Created by Tardes on 17/1/25.
//

import Foundation

struct User: Codable
{
    
    var id : String
    var username : String
    var firstName: String
    var lastName: String
    var gender: Gender
    var birthday: Date
    var provider: LoginProvider
    var profileImageUrl: String
}
