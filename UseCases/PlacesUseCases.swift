//
//  PlacesUseCases.swift
//  UseCases
//
//  Created by fadi on 11/29/19.
//  Copyright © 2019 Experiments. All rights reserved.
//

import Foundation
import RxSwift
import Entities

public struct LatLng {
    public let lat: Double
    public let lng: Double

    public init(lat: Double, lng: Double) {
        self.lat = lat
        self.lng = lng
    }

}

public protocol LocationService {
    var locationObservable: Observable<LatLng> { get }
    func disableLocation()
    func enableLocation()
}

public class PlacesUseCases {
    public let locationService: LocationService
    public let mainGateway: PlacesRepository
    public let cacheingGateway: PlacesCacheing

    public let currentData = BehaviorSubject<[Place]>(value: [])
    private var disposableBag = DisposeBag()

    public init(locationService: LocationService,
                mainGateway: PlacesRepository,
                cacheingGateway: PlacesCacheing) {
        self.locationService = locationService
        self.mainGateway = mainGateway
        self.cacheingGateway = cacheingGateway
    }

    private func observable(paged from: Int, to: Int) -> Observable<Timestamped<[Place]>> {
        self.locationService.locationObservable.flatMap { [weak self] (location: LatLng) -> Observable<Timestamped<[Place]>> in
            guard let self = self else { return Observable.empty() }
            let main = self.mainGateway.getPlaces(for: location.lat, and: location.lng,
                                             paginatedFrom: from, to: to)
            let cache = self.mainGateway.getPlaces(for: location.lat, and: location.lng,
                                              paginatedFrom: from, to: to)
            return CacheingUseCases().cachedThenReal(cached: cache.map { Timestamped(value: $0) },
                                                     real: main.map { Timestamped(value: $0) })
        }
    }

    public func singleRequest(paged from: Int, to: Int) {
        // TODO: Make this takeUntil data is not from the cache
        observable(paged: from, to: to).take(1).subscribe { [weak self] result in
            self?.currentData.on(result.map { $0.value })
        }.disposed(by: disposableBag)
    }

    public func beginRealtime(paged from: Int, to: Int) {
        locationService.enableLocation()
        // TODO: DRY
        observable(paged: from, to: to).subscribe { [weak self] result in
            self?.currentData.on(result.map { $0.value })
        }.disposed(by: disposableBag)
    }

    public func endRealtime() {
        locationService.disableLocation()
        // Dispose the old ones, TODO: Try to make something more immutable, or at least automatic
        disposableBag = DisposeBag()
    }

}
