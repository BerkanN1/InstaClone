//
//  UserModel.swift
//  Flexigram
//
//  Created by BERKAN NALBANT on 7.08.2021.
//

import Foundation

struct User: Encodable, Decodable{
    var uid: String
    var email: String
    var profileImageUrl: String
    var username: String
    var searchName: [String]
    var bio: String
}
