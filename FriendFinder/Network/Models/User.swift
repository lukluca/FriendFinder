// See LICENSE.txt for licensing information

import Foundation

struct User {
    let id: Int
    let name: String
    let username: String
    let email: String
    let address: Address
    let phone: String
    let website: String
    let company: Company
}

extension User: Decodable {}

struct Address {
    let street: String
    let suite: String
    let city: String
    let zipcode: String
    let geo: Geo
}

extension Address: Decodable {}

struct Geo {
    let lat: String
    let lng: String
}

extension Geo: Decodable {}

struct Company {
    let name: String
    let catchPhrase: String
    let bs: String
}

extension Company: Decodable {}
