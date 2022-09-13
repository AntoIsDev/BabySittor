//
//  User.swift
//  BabySittor
//
//  Created by Antonin De Almeida on 13/09/2022.
//

import Foundation

struct User: Decodable {

    var uuid = UUID()
    let firstname, lastname, defaultPictureUrl: String
    let averageReviewScore: Double?

}
