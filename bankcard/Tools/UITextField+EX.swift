//
//  UITextField+EX.swift
//  bankcard
//
//  Created by rosua le on 2023/9/4.
//

import UIKit

extension UITextField {

  var maxLength: Int {
    get {
      guard let l = objc_getAssociatedObject(self, &maxLengthKey) as? Int else {
        return Int.max
      }
      return l
    }
    set {
      objc_setAssociatedObject(self, &maxLengthKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
  }

}

private var maxLengthKey: Int = 0
