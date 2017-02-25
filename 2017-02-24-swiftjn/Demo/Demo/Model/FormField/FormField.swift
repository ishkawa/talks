//
//  FormField.swift
//  Demo
//
//  Created by Yosuke Ishikawa on 2017/02/12.
//  Copyright © 2017 Yosuke Ishikawa. All rights reserved.
//

import Foundation
import Result

protocol FormField {
    associatedtype FieldID
    associatedtype Value
    associatedtype Product = Value

    var id: FieldID { get }
    var name: String { get }
    var value: Value { get }

    func buildProduct() -> Result<Product, FormFieldError<FieldID>>
}

struct FormFieldError<FieldID>: Error {
    let fieldID: FieldID
    let title: String
    let message: String
}
