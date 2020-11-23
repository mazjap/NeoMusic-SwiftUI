//
//  User.swift
//  NeoMusic-SwiftUI
//
//  Created by Jordan Christensen on 11/21/20.
//

import CoreData

struct User {
    var id: UUID
    var username: String
    var email: String
    var token: String?
    var settings: Settings
    var image: UIImage
}

struct Settings {
    var currentScheme: JCColorScheme
    var savedColorSchemes: [JCColorScheme]
}


