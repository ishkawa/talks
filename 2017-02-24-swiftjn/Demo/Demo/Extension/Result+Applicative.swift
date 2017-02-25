//
//  Result+Applicative.swift
//  Demo
//
//  Created by Yosuke Ishikawa on 2017/02/13.
//  Copyright © 2017 Yosuke Ishikawa. All rights reserved.
//

import Foundation
import Result
import Runes

public func <^> <T, U, Error> (transform: (T) -> U, result: Result<T, Error>) -> Result<U, Error> {
    return result.map(transform)
}

public func <*> <T, U, Error> (transform: Result<(T) -> U, Error>, result: @autoclosure () -> Result<T, Error>) -> Result<U, Error> {
    return transform.flatMap { f in result().map(f) }
}
