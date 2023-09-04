//
//  EditBankCardViewController.swift
//  bankcard
//
//  Created by rosua le on 2023/9/3.
//

import UIKit

class EditBankCardViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTableView()
        self.setupNavbar()
    }

    func setupTableView(){
        self.view.backgroundColor = hexStringToUIColor(hex:"#F1F0F5")
        self.tableView.register(UINib(nibName: "BankCardCell", bundle: nil), forCellReuseIdentifier: "BankCardCell")
        self.tableView.tableFooterView = UIView()
        self.tableView.separatorStyle = .none
    }
    
    func setupNavbar() {
        self.title = "Edit Bank Card".l10n()
        let button = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.cancel, target: self, action: #selector(leftButtonItemClicked(sender:)))
        button.tintColor = .red
        self.navigationItem.leftBarButtonItem = button
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


        return cell
    }
    

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 248
    }
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {

      let footerView = UIView()
      footerView.backgroundColor = .white

      let button = UIButton(type: .system)
      button.setTitle("Done".l10n(), for: .normal)
      button.setTitleColor(.systemPink, for: .normal)
      button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
      button.addTarget(self, action: #selector(finishTapped), for: .touchUpInside)

      footerView.addSubview(button)
      button.translatesAutoresizingMaskIntoConstraints = false
      button.centerXAnchor.constraint(equalTo: footerView.centerXAnchor).isActive = true
      button.centerYAnchor.constraint(equalTo: footerView.centerYAnchor).isActive = true

      return footerView
    }

    // 完成按钮点击回调
    @objc func finishTapped() {
      print("完成按钮被点击")
        
        let obj =   CardPassObj(type: 1000, name: "", cardNumber: "1100", password: "xxoo", remark: "银行卡")
        //将更新数据发送出去
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateObj"), object: obj)
        self.dismiss(animated: true, completion: nil)

    }
    @objc func leftButtonItemClicked(sender:UIBarButtonItem){
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func loadData() {
        self.tableView.reloadData()
    }
    
}