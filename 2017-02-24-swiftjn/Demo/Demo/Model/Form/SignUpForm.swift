//
//  SignUpForm.swift
//  Demo
//
//  Created by Yosuke Ishikawa on 2017/02/10.
//  Copyright © 2017 Yosuke Ishikawa. All rights reserved.
//

import Foundation
import Curry
import Runes
import Result

struct SignUpForm: Form {
    enum FieldID {
        case name
        case email
        case prefecture
    }
    
    let nameField: StringFormField<FieldID>
    let emailField: EmailFormField<FieldID>
    let prefectureField: SelectionFormField<FieldID, Prefecture>

    init(name: String, email: String, prefecture: Prefecture?) {
        nameField = StringFormField(
            id: .name,
            name: "ユーザー名",
            value: name,
            maxCharactersCount: 20)

        emailField = EmailFormField(
            id: .email,
            name: "メールアドレス",
            value: email)

        prefectureField = SelectionFormField(
            id: .prefecture,
            name: "お住まいの都道府県",
            value: prefecture)
    }

    func buildProduct() -> Result<SignUpRequest, FormFieldError<SignUpForm.FieldID>> {
        return curry(SignUpRequest.init)
            <^> nameField.buildProduct()
            <*> emailField.buildProduct()
            <*> prefectureField.buildProduct()
    }
}
