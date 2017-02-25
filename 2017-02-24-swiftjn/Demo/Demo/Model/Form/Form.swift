//
//  Form.swift
//  Demo
//
//  Created by Yosuke Ishikawa on 2017/02/10.
//  Copyright © 2017 Yosuke Ishikawa. All rights reserved.
//

import Foundation
import Result

protocol Form {
    associatedtype Product
    associatedtype FieldID

    func buildProduct() -> Result<Product, FormFieldError<FieldID>>
}
