//
//  SettingViewController.swift
//  bankcard
//
//  Created by rosua le on 2023/8/30.
//

import UIKit
import MessageUI

class SettingViewController: UITableViewController, MFMailComposeViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTableView()
        self.setupNavbar()
    }

    func setupTableView(){
        self.view.backgroundColor = UIColor.secondarySystemBackground
        self.tableView.register(UINib(nibName: "SwitchCell", bundle: nil), forCellReuseIdentifier: "SwitchCell")
        self.tableView.register(UITableViewCell.self,forCellReuseIdentifier: "NormalCell")
        self.tableView.tableFooterView = UIView()
        self.tableView.separatorStyle = .singleLine
        
    }
    
    func setupNavbar() {
        self.title = "Setting".l10n()
        let button = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(leftButtonItemClicked(sender:)))
        button.tintColor = .systemTeal
        self.navigationItem.rightBarButtonItem = button
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            return 3
        }else if section == 2 {
                return 2
        }else{
            return 1
        }
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 2 {
            return "About".l10n()
        }else if section == 1{
            return "Privacy".l10n()
        }
        return ""
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         if indexPath.section == 0 {
             let  cell = tableView.dequeueReusableCell(withIdentifier: "SwitchCell", for: indexPath) as! SwitchCell
            cell.titleLabel.text = "Lock the password".l10n()
             return cell

         }else if indexPath.section == 1 {
            let  cell = tableView.dequeueReusableCell(withIdentifier: "NormalCell", for: indexPath)
             cell.selectionStyle = .none
 
            switch indexPath.item {
            case 0 :
                cell.textLabel?.text = "No Login".l10n()
            case 1:
                cell.textLabel?.text = "No data theft".l10n()
            case 2:
                cell.textLabel?.text = "Your data is yours".l10n()
            default:
                 cell.textLabel?.text = "".l10n()
            }
            
            return cell

         }else{
             if indexPath.item == 0 {
                 let  cell = tableView.dequeueReusableCell(withIdentifier: "NormalCell", for: indexPath)
                 cell.selectionStyle = .none
                 cell.textLabel?.text = "BankCard v1.0(2023-08)".l10n()
                 return cell
             }else{
                 let  cell = tableView.dequeueReusableCell(withIdentifier: "NormalCell", for: indexPath)
                 cell.selectionStyle = .none
                 cell.textLabel?.text = "contact me".l10n()
                 return cell
             }
         }
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 48
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 2 && indexPath.item == 1 {
            // 1. 创建邮件内容
            let mailComposeViewController = configuredMailComposeViewController()
            // 2. 显示邮件界面
            if MFMailComposeViewController.canSendMail() {
              self.present(mailComposeViewController, animated: true, completion: nil)
            } else {
              print("设备未设置邮件账号")
                showNormalAlert(title: "Alert".l10n(), message: "Please email me at lerosua+bankcard@gmail.com".l10n())
            }
        }
    }
    


    @objc func leftButtonItemClicked(sender:UIBarButtonItem){
        
        self.dismiss(animated: true, completion: nil)
    }
    func configuredMailComposeViewController() -> MFMailComposeViewController {
      
      let mailComposerVC = MFMailComposeViewController()
      mailComposerVC.mailComposeDelegate = self // 遵循 MFMailComposeViewControllerDelegate 协议
      
      mailComposerVC.setToRecipients(["lerosua+bankcard@gmail.com"])
      mailComposerVC.setSubject("关于BankCard的反馈")
      mailComposerVC.setMessageBody("Hey, I have some problem with you ....", isHTML: false)

      return mailComposerVC
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        self.dismiss(animated: true)
    }
}