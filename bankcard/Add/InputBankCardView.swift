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
        
        commentTextView.layer.cornerRadius = 8 //设置圆角
        commentTextView.layer.borderWidth = 0.5 //设置边框宽度
        commentTextView.layer.borderColor = UIColor.lightGray.cgColor //设置边框颜色
        commentTextView.backgroundColor = .white //设置背景颜色
        
    }
    static  func loadFromNIB() -> InputBankCardView {
        let view = UINib(nibName: "InputBankCardView", bundle: .main).instantiate(withOwner: nil, options: nil).first as! InputBankCardView
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
}
