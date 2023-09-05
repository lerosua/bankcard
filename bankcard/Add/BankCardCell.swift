//
//  BankCardCell.swift
//  bankcard
//
//  Created by rosua le on 2023/9/4.
//

import UIKit

class BankCardCell: UITableViewCell {

    @IBOutlet var cardView: UIView!
    @IBOutlet var cardImg: UIImageView!
    
    @IBOutlet var nameTxtField: UITextField!
    @IBOutlet var numberTxtField: UITextField!
    @IBOutlet var remarkTxtField: UITextField!
    @IBOutlet var passwordTxtField: UITextField!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let radius: CGFloat = 15
        cardView.layer.cornerRadius = radius
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOpacity = 0.5
        cardView.layer.shadowOffset = CGSize(width: 0.5, height: 0.5)
        cardView.layer.shadowRadius = radius
        cardImg.layer.cornerRadius = radius
        cardImg.clipsToBounds = true
        
        cardView.backgroundColor = UIColor.hexColor(hex: "#B2BFCA")
        
        //设置最大长度
        nameTxtField.maxLength = 20
        numberTxtField.maxLength = 4
        remarkTxtField.maxLength = 80
        passwordTxtField.maxLength = 20
        
        nameTxtField.placeholder = "Card name".l10n()
        remarkTxtField.placeholder = "Remark".l10n()
        numberTxtField.placeholder = "last 4 number".l10n()
        passwordTxtField.placeholder = "password".l10n()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func getCardPassObj()->CardPassObj {
        let cardName = nameTxtField.text ?? ""
        let password = passwordTxtField.text ?? ""
        let comment = remarkTxtField.text ?? ""
        let cardNumber = numberTxtField.text ?? ""
        
        let obj =   CardPassObj(type: 0, name: cardName, cardNumber: cardNumber, password: password, remark: comment)
        return obj
    }
    
    func setupCardPassObj(obj:CardPassObj){
        nameTxtField.text = obj.name
        remarkTxtField.text = obj.remark
        numberTxtField.text = obj.cardNumber
        passwordTxtField.text = obj.password
    }
    
}
