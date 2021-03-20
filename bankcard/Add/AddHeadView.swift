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
//        let view :AddHeadView = initFromNib()
//        return view
        let view = UINib(nibName: "AddHeadView", bundle: .main).instantiate(withOwner: nil, options: nil).first as! AddHeadView
//        view.frame = CGRect(x: 0,y: 0,width: screenWidth, height: 120)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
}


//extension UIView {
//    class func initFromNib<T: UIView>() -> T {
//        return Bundle.main.loadNibNamed(String(describing: self), owner: nil, options: nil)?[0] as! T
//    }
//}
