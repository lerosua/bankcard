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
    // 在cell类中定义textField数组
    var textFields = [UITextField]()

    
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
        
        nameTxtField.delegate = self
        remarkTxtField.delegate = self
        numberTxtField.delegate = self
        passwordTxtField.delegate = self


        // 添加textField到数组
        textFields.append(nameTxtField)
        textFields.append(remarkTxtField)
        textFields.append(numberTxtField)
        textFields.append(passwordTxtField)

        // 监听第一个textField的回车
        nameTxtField.addTarget(self, action: #selector(textFieldDidReturn), for: .editingDidEndOnExit)
        remarkTxtField.addTarget(self, action: #selector(textFieldDidReturn), for: .editingDidEndOnExit)
        numberTxtField.addTarget(self, action: #selector(textFieldDidReturn), for: .editingDidEndOnExit)

        
        
        self.selectionStyle = .none
        
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
    
    // 回车事件处理
    @objc func textFieldDidReturn(_ textField: UITextField) {
      // 获取下一个textField
     let nextTextField = textFields[textFields.firstIndex(of: textField)!+1]
      nextTextField.becomeFirstResponder()
    }

}


extension BankCardCell:UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)

        if textField == numberTxtField {
            return updatedText.count <= 11 //限制号码最多11个
        }
        
        return updatedText.count <= 40 // 限制最大输入40个字符
    }
}
