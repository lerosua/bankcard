//
//  UIViewController+ex.swift
//  bankcard
//
//  Created by rosua le on 2023/6/13.
//

import UIKit

//扩展--展示普通信息
extension UIViewController {
    func showNormalAlert(title: String, message: String, onOk: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "确定", style: .default) { (_) in
            onOk?()
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
