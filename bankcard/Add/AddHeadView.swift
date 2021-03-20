//
//  AddHeadView.swift
//  bankcard
//
//  Created by rosua le on 2021/3/20.
//

import UIKit

class AddHeadView: UIView {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    static  func loadFromNIB() -> AddHeadView {
        let view = UINib(nibName: "AddHeadView", bundle: .main).instantiate(withOwner: nil, options: nil).first as! AddHeadView
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
}

