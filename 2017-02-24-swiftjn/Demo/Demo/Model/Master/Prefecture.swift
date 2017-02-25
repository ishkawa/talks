//
//  Prefecture.swift
//  Demo
//
//  Created by Yosuke Ishikawa on 2017/02/19.
//  Copyright © 2017 Yosuke Ishikawa. All rights reserved.
//

import Foundation

struct Prefecture {
    let id: Int64
    let name: String

    static var all: [Prefecture] {
        return [
            Prefecture(id: 1, name: "北海道"),
            Prefecture(id: 2, name: "青森県"),
            Prefecture(id: 3, name: "岩手県"),
            Prefecture(id: 4, name: "宮城県"),
            Prefecture(id: 5, name: "秋田県"),
            Prefecture(id: 6, name: "山形県"),
            Prefecture(id: 7, name: "福島県"),
            Prefecture(id: 8, name: "茨城県"),
            Prefecture(id: 9, name: "栃木県"),
            Prefecture(id: 10, name: "群馬県"),
            Prefecture(id: 11, name: "埼玉県"),
            Prefecture(id: 12, name: "千葉県"),
            Prefecture(id: 13, name: "東京都"),
            Prefecture(id: 14, name: "神奈川県"),
            Prefecture(id: 15, name: "新潟県"),
            Prefecture(id: 16, name: "富山県"),
            Prefecture(id: 17, name: "石川県"),
            Prefecture(id: 18, name: "福井県"),
            Prefecture(id: 19, name: "山梨県"),
            Prefecture(id: 20, name: "長野県"),
            Prefecture(id: 21, name: "岐阜県"),
            Prefecture(id: 22, name: "静岡県"),
            Prefecture(id: 23, name: "愛知県"),
            Prefecture(id: 24, name: "三重県"),
            Prefecture(id: 25, name: "滋賀県"),
            Prefecture(id: 26, name: "京都府"),
            Prefecture(id: 27, name: "大阪府"),
            Prefecture(id: 28, name: "兵庫県"),
            Prefecture(id: 29, name: "奈良県"),
            Prefecture(id: 30, name: "和歌山県"),
            Prefecture(id: 31, name: "鳥取県"),
            Prefecture(id: 32, name: "島根県"),
            Prefecture(id: 33, name: "岡山県"),
            Prefecture(id: 34, name: "広島県"),
            Prefecture(id: 35, name: "山口県"),
            Prefecture(id: 36, name: "徳島県"),
            Prefecture(id: 37, name: "香川県"),
            Prefecture(id: 38, name: "愛媛県"),
            Prefecture(id: 39, name: "高知県"),
            Prefecture(id: 40, name: "福岡県"),
            Prefecture(id: 41, name: "佐賀県"),
            Prefecture(id: 42, name: "長崎県"),
            Prefecture(id: 43, name: "熊本県"),
            Prefecture(id: 44, name: "大分県"),
            Prefecture(id: 45, name: "宮崎県"),
            Prefecture(id: 46, name: "鹿児島県"),
            Prefecture(id: 47, name: "沖縄県"),
        ]
    }
}

extension Prefecture: Equatable {
    static func ==(_ lhs: Prefecture, _ rhs: Prefecture) -> Bool {
        return lhs.id == rhs.id && lhs.name == rhs.name
    }
}
