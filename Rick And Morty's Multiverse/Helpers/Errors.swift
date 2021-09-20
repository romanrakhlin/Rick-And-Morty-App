//
//  Errors.swift
//  Rick And Morty's Multiverse
//
//  Created by Roman Rakhlin on 15.09.2021.
//

import Foundation

enum Errors: String, Error {
    case invalidUsername = "This username created an invalid request. Please try again"
    case unableToComplete = "Unable to complete your request"
    case invalidResponse = "Invalid Response from the server"
    case invalidData = "Data invalid from server"
    case unableToFavorito = "There was an error in favorites"
    case existsInFavorite = "The data already exist in favorites"
}
