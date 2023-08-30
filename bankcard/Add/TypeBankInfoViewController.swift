//
//  TypeBankInfoViewController.swift
//  bankcard
//
//  Created by rosua le on 2021/3/20.
//

import UIKit

class TypeBankInfoViewController: UIViewController {
    
    var bodyView:InputBankCardView!
    var editMode:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupNavbar()

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        bodyView.firstTextField.becomeFirstResponder()
        
    }
    func setupUI(){
        bodyView = InputBankCardView.loadFromNIB()
        bodyView.frame = CGRect(x: 0, y: 64, width: screenWidth, height: 500)
        self.view.addSubview(bodyView)
        self.view.backgroundColor = UIColor.white
        
    }

    
    func setupNavbar() {
        self.title = "Add".l10n()
        let button = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(doneButtonItemClicked(sender:)))
        button.tintColor = .red
        self.navigationItem.rightBarButtonItem = button
    }
    
    @objc func doneButtonItemClicked(sender:UIBarButtonItem){
        let result =  saveData()
        if result == "success" {
            self.dismiss(animated: true, completion: nil)
        }else if result == "cardNumber" {
            print("需要弹出警告--没填写号码")
            showNormalAlert(title: "Alert".l10n(), message: "less bank number".l10n())
        }else if result == "password"{
            print("需要弹出警告--没填写密码")
            showNormalAlert(title: "Alert".l10n(), message: "less password".l10n())
        }
        
        
    }
    
    func saveData() -> String{
        guard let cardNumber = bodyView.firstTextField.text else { return "cardNumber" }
        guard let password = bodyView.secoundTextField.text  else { return "password" }
        guard let comment = bodyView.commentTextView.text  else { return "comment" }
        
        if cardNumber == "" {
            return "cardNumber"
        }else if password == "" {
            return "password"
        }
        
        let obj =   CardPassObj(type: 0, name: "", cardNumber: cardNumber, password: password, remark: comment)
        //将更新数据发送出去
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateObj"), object: obj)
        
        return "success"
        
    }
    
}
