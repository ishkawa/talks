//
//  SignUpRequest.swift
//  Demo
//
//  Created by Yosuke Ishikawa on 2017/02/13.
//  Copyright © 2017 Yosuke Ishikawa. All rights reserved.
//

import Foundation

struct SignUpRequest {
    let name: String
    let email: String
    let prefecture: Prefecture

    var description: String {
        return "お名前: \(name)\nEメール: \(email)\n都道府県: \(prefecture.name)"
    }
}
