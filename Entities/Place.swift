//
//  Place.swift
//  Entities
//
//  Created by fadi on 11/29/19.
//  Copyright © 2019 Experiments. All rights reserved.
//

import Foundation

public struct Location: Codable {
    public let formattedAddress: [String]
}

public struct Place: Codable {
    public let id: String
    public let name: String
    public let location: Location

    public init(id: String, name: String, location: Location) {
        self.id = id
        self.name = name
        self.location = location
    }
}
