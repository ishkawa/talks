//
//  Injectable.swift
//  Demo
//
//  Created by Yosuke Ishikawa on 2017/02/19.
//  Copyright © 2017 Yosuke Ishikawa. All rights reserved.
//

import Foundation

protocol Injectable {
    associatedtype Dependency = Void

    static func makeInstance(dependency: Dependency) -> Self
}
