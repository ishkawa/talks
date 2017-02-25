//
//  SelectionFormField.swift
//  Demo
//
//  Created by Yosuke Ishikawa on 2017/02/13.
//  Copyright © 2017 Yosuke Ishikawa. All rights reserved.
//

import Foundation
import Result

struct SelectionFormField<FieldID, Value>: FormField {
    let id: FieldID
    let name: String
    let value: Value?

    func buildProduct() -> Result<Value, FormFieldError<FieldID>> {
        guard let product = value else {
            return .failure(FormFieldError(
                fieldID: id,
                title: "未選択の必須項目があります",
                message: "\(name)を選択してください"))
        }

        return .success(product)
    }
}
