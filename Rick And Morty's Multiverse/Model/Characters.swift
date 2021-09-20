//
//  Characters.swift
//  Rick And Morty's Multiverse
//
//  Created by Roman Rakhlin on 13.09.2021.
//

import Foundation

struct Characters: Codable, Hashable {
    let results: [Character]
}

struct Character: Codable, Hashable {
    let id: Int
    let name: String
    let status: String
    let location: Location
    let image: String
    let episode: [String]
}

struct Location: Codable, Hashable {
    let localName: String
    let localUrl: String
    
    enum CodingKeys: String, CodingKey {
        case localName = "name"
        case localUrl  = "url"
    }
}

struct Episode: Codable, Hashable {
    let id: Int
    let name: String
}
