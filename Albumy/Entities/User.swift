//
//  User.swift
//  Albumy
//
//  Created by Ali on 03/03/2023.
//

import Foundation

// MARK: - UserModel
struct User: Codable {
    let id: Int
    let name, username, email: String
    let address: Address
    let phone, website: String
    let company: Company
}

// MARK: - Address
struct Address: Codable, CustomStringConvertible {
    var description: String {
        return street+", "+suite+", "+city+", "+zipcode
    }
    
    let street, suite, city, zipcode: String
    let geo: Location
}

// MARK: - Location
struct Location: Codable {
    let lat, lng: String
}

// MARK: - Company
struct Company: Codable {
    let name, catchPhrase, bs: String
}
