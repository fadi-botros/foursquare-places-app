//
//  UseCasesTests.swift
//  UseCasesTests
//
//  Created by fadi on 11/29/19.
//  Copyright © 2019 Experiments. All rights reserved.
//

import XCTest
import RxSwift
import Entities
@testable import UseCases

class MockLocationSource: LocationSource {
    let locationObservable: Observable<Location> = PublishSubject<Location>()
    var locationEnabled: Bool = false

    func disableLocation() {
        locationEnabled = false
    }

    func enableLocation() {
        locationEnabled = true
    }

    func emit(location: Location) {
        locationObservable.onNext(location)
    }

}

class MockDatabaseRepo: PlacesRepository, PlacesCache {
    let timeToTrigger: TimeInterval

    init(timeToTrigger: TimeInterval) {
        self.timeToTrigger = timeToTrigger
    }

    func getPlaces(for longitude: Double, and latitude: Double, paginatedFrom: Int, to: Int) -> Observable<[Place]> {
        return PublishSubject<Int>().onNext([
            Place(id: "1234", name: "First", location: Location(formattedStrings: ["A", "B", "C"]))])
        
    }
}

class UseCasesTests: XCTestCase {

    func testLocationChange() {
        let locationSource = MockLocationSource()
        let expectation = XCTestExpectation(description: "Location observed correctly")
        DispatchQueue.global().async {
            locationSource.locationObservable.subscribe {
                expectation.fulfill()
            }
        }
    }

    func testWhenLocationDisabledNoChange() {
        let locationSource = MockLocationSource()
        let expectation = XCTestExpectation(description: "Location shouldn't be observed")
        expectation.isInverted = true
        DispatchQueue.global().async {
            locationSource.disableLocation()
            locationSource.locationObservable.subscribe {
                expectation.fulfill()
            }
        }
    }

    func testDifferentRepositories() {

    }

}
