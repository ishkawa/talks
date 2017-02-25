//
//  StringFormIField.swift
//  Demo
//
//  Created by Yosuke Ishikawa on 2017/02/12.
//  Copyright © 2017 Yosuke Ishikawa. All rights reserved.
//

import Foundation
import Result

struct StringFormField<FieldID>: FormField {
    let id: FieldID
    let name: String
    let value: String
    let maxCharactersCount: Int

    func buildProduct() -> Result<String, FormFieldError<FieldID>> {
        guard !value.isEmpty else {
            return .failure(FormFieldError(
                fieldID: id,
                title: "未入力の必須項目があります",
                message: "\(name)を入力してください"))
        }

        guard value.characters.count <= maxCharactersCount else {
            return .failure(FormFieldError(
                fieldID: id,
                title: "文字数がオーバーしています",
                message: "\(name)は\(maxCharactersCount)文字以内で入力してください"))
        }

        return .success(value)
    }
}
