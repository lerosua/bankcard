//
//  TypeBankInfoViewController.swift
//  bankcard
//
//  Created by rosua le on 2021/3/20.
//

import UIKit

class TypeBankInfoViewController: UIViewController {
    
    var bodyView:InputBankCardView!
    
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
        
        self.view.addSubview(bodyView)
        
    }

    
    func setupNavbar() {
        self.title = "Add".l10n()
        let button = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(doneButtonItemClicked(sender:)))
        button.tintColor = .red
        self.navigationItem.rightBarButtonItem = button
    }
    
    @objc func doneButtonItemClicked(sender:UIBarButtonItem){
        
        self.dismiss(animated: true, completion: nil)
    }
}
