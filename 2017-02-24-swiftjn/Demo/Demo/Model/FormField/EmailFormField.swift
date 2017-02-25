//
//  EmailFormField.swift
//  Demo
//
//  Created by Yosuke Ishikawa on 2017/02/13.
//  Copyright © 2017 Yosuke Ishikawa. All rights reserved.
//

import Foundation
import Result

struct EmailFormField<FieldID>: FormField {
    let id: FieldID
    let name: String
    let value: String
    
    private let maxCharactersCount = 254

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

        guard value.contains("@") else {
            return .failure(FormFieldError(
                fieldID: id,
                title: "メールアドレスの形式が正しくありません",
                message: "正しい形式で入力してください"))
        }

        return .success(value)
    }
}
