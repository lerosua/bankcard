//
//  EditBankCardViewController.swift
//  bankcard
//
//  Created by rosua le on 2023/9/3.
//

import UIKit

class EditBankCardViewController: UITableViewController {
    var cardItem: CardTableViewCellItem?

      init(item: CardTableViewCellItem) {
         cardItem = item
          super.init(style: .plain)
        // 在此处使用传入的text参数
        print("Table View Controller initialized with text: \(item)")
    }
    required init?(coder: NSCoder) {
      super.init(coder: coder)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTableView()
        self.setupNavbar()
    }

    func setupTableView(){
//        self.view.backgroundColor =  UIColor.hexColor(hex:"#F1F0F5")
        self.view.backgroundColor = .secondarySystemBackground

        self.tableView.register(UINib(nibName: "BankCardCell", bundle: nil), forCellReuseIdentifier: "BankCardCell")
        self.tableView.tableFooterView = UIView()
        self.tableView.separatorStyle = .none
        
    }
    
    func setupNavbar() {
        self.title = "Edit Card".l10n()
        let button = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.cancel, target: self, action: #selector(leftButtonItemClicked(sender:)))
        self.navigationItem.leftBarButtonItem = button
        
        let delButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.trash, target: self, action: #selector(rightButtonItemClicked(sender:)))
        delButton.tintColor = .red
        self.navigationItem.rightBarButtonItem = delButton
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ""
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BankCardCell", for: indexPath) as! BankCardCell
        if let obj = self.cardItem?.data{
            cell.setupCardPassObj(obj:obj)
        }
        return cell
    }
    

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 248
    }
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
      return 120
    }
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let width = screenWidth
        let footerView = UIView()
        footerView.backgroundColor = .clear
        // 创建按钮时设置内边距

        let button = UIButton(frame: CGRect(x: 13, y: 13, width:  width - 26, height: 50))
        button.setTitle("Done".l10n(), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.addTarget(self, action: #selector(finishTapped), for: .touchUpInside)
        button.backgroundColor = .systemBlue
        // 设置圆角
        button.layer.cornerRadius = 8
        footerView.addSubview(button)
        return footerView
    }

    // 完成按钮点击回调
    @objc func finishTapped() {
      print("完成按钮被点击")
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = tableView.cellForRow(at: indexPath) as! BankCardCell
        
        let obj =  cell.getCardPassObj()
        
        if obj.name == "" {
            showNormalAlert(title: "Alert".l10n(), message: "less name".l10n())
            return
        }else if obj.password == "" {
            print("需要弹出警告--没填写号码")
            showNormalAlert(title: "Alert".l10n(), message: "less password".l10n())
            return
        }
        cardItem?.data = obj
        //将更新数据发送出去
        NotificationCenter.default.post(name: .updateCardNotification, object: cardItem)
        self.dismiss(animated: true, completion: nil)

    }
    @objc func leftButtonItemClicked(sender:UIBarButtonItem){
        
        self.dismiss(animated: true, completion: nil)
    }
    @objc func rightButtonItemClicked(sender:UIBarButtonItem){
        
        let alertController = UIAlertController(title: "Warning".l10n(), message: "This action will permanently delete the current card. Are you sure?".l10n(), preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Confirm".l10n(), style: .destructive) { (_) in
            NotificationCenter.default.post(name: .delCardNotification, object: self.cardItem)
            self.dismiss(animated: true, completion: nil)
        }
        let cancelAction = UIAlertAction(title:"Cancel".l10n(),style: .cancel){(_) in
            return
        }
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func loadData() {
        self.tableView.reloadData()
    }
    
}
