//
//  InputBankCardView.swift
//  bankcard
//
//  Created by rosua le on 2021/3/20.
//

import UIKit

class InputBankCardView: UIView {
    
    @IBOutlet var firstTextField:UITextField!
    @IBOutlet var secoundTextField:UITextField!
    @IBOutlet var commentTextView:UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    static  func loadFromNIB() -> InputBankCardView {
        let view = UINib(nibName: "InputBankCardView", bundle: .main).instantiate(withOwner: nil, options: nil).first as! InputBankCardView
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
}
