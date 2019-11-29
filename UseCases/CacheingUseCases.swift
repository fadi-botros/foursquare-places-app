//
//  CacheingUseCases.swift
//  UseCases
//
//  Created by fadi on 11/29/19.
//  Copyright © 2019 Experiments. All rights reserved.
//

import Foundation
import Entities
import RxSwift

enum NoValidData: Error {
    case noValidData
}

struct CacheingUseCases {
    func cachedThenReal(cached: Observable<Timestamped<[Place]>>,
                        real: Observable<Timestamped<[Place]>>) -> Observable<Timestamped<[Place]>> {
        return Observable<Timestamped<[Place]>>.zip([cached, real], resultSelector: { arrayToChooseFrom in
            let optionalResult =
                arrayToChooseFrom.compactMap { elem in return elem }
                                 .max { a, b in return a.timeStamp < b.timeStamp }
            if let result = optionalResult {
                return result
            } else {
                throw NoValidData.noValidData
            }
        })
    }

}
