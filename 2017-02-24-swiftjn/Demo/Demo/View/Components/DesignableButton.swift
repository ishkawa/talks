//
//  DesignableButton.swift
//  Demo
//
//  Created by Yosuke Ishikawa on 2017/02/10.
//  Copyright © 2017 Yosuke Ishikawa. All rights reserved.
//

import UIKit

@IBDesignable
class DesignableButton: UIButton {
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }

        set {
            layer.cornerRadius = newValue
        }
    }
}
