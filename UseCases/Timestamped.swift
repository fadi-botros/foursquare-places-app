//
//  Timestamped.swift
//  UseCases
//
//  Created by fadi on 11/29/19.
//  Copyright © 2019 Experiments. All rights reserved.
//

import Foundation
import RxSwift

public struct Timestamped<T> {
    public let timeStamp: Date
    public let value: T

    public init(value: T) {
        self.timeStamp = Date()
        self.value = value
    }
}
