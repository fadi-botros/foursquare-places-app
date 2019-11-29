//
//  GatewayInterfaces.swift
//  UseCases
//
//  Created by fadi on 11/29/19.
//  Copyright © 2019 Experiments. All rights reserved.
//

import UIKit
import RxSwift
import Entities

public protocol PlacesRepository {
    func getPlaces(for latitude: Double,
                   and longitude: Double,
                   paginatedFrom: Int,
                   to: Int) -> Observable<[Place]>
}

public protocol PlacesCacheing: PlacesRepository {
    func cache(places: [Place],
               for latitude: Double,
               and longitude: Double,
               paginatedFrom: Int,
               to: Int)
}
