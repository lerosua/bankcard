//
//  SettingViewController.swift
//  bankcard
//
//  Created by rosua le on 2023/8/30.
//

import UIKit
import MessageUI
import SafariServices
import LocalAuthentication

let kSettingKey = "settings_key"
let kUseLockKey = "using_lock_key"
let kChangeAppIconKey = "change_appicon_key"

private let appName = ["订阅伽","GameTron","天气.时光"]
private let appLink = ["https://itunes.apple.com/app/id6467340270","https://itunes.apple.com/app/id6471490323","https://itunes.apple.com/app/id6470151198"]
class SettingViewController: UITableViewController, MFMailComposeViewControllerDelegate {

    // 配置信息字典
    var settings = [String: Any]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadSetting()
        setupTableView()
        setupNavbar()
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

    func loadSetting(){
        // 读取配置信息
        if let savedSettings = UserDefaults.standard.object(forKey: kSettingKey) as? [String: Any] {
          settings = savedSettings
        }
    }
    func saveSetting(){
        // 保存到UserDefaults
        UserDefaults.standard.set(settings, forKey: kSettingKey)
        UserDefaults.standard.synchronize()
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 4
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            return 1
        }else if section == 2 {
            return 2
        }else if section == 3 {
            return appName.count
        }else{
            return 2
        }
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 2 {
            return "About".l10n()
        }else if section == 1{
            return "Privacy".l10n()
        }else if section == 3 {
            return "App"
        }
        return ""
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         if indexPath.section == 0 {
             if indexPath.item == 0 {
                 let  cell = tableView.dequeueReusableCell(withIdentifier: "SwitchCell", for: indexPath) as! SwitchCell
                 cell.titleLabel.text = "Use System Authentication".l10n()
                 if let lock = settings[kUseLockKey] as? Bool {
                     cell.switchBtn.isOn = lock
                 }
                 // 绑定 switchChanged 事件
                 cell.switchChanged = { [weak self] changedSwitch in
                     print("Switch changed: \(changedSwitch.isOn)")
                     self?.updateSwitchState(changeSwitch:changedSwitch)
                 }
                 
                 return cell
             }else{
                 let  cell = tableView.dequeueReusableCell(withIdentifier: "SwitchCell", for: indexPath) as! SwitchCell
                 cell.titleLabel.text = "Change App Icon".l10n()
                 if let lock = settings[kChangeAppIconKey] as? Bool {
                     cell.switchBtn.isOn = lock
                 }
                 // 绑定 switchChanged 事件
                 cell.switchChanged = { [weak self] changedSwitch in
                     print("Switch changed: \(changedSwitch.isOn)")
                     self?.updateAppIconState(changeSwitch:changedSwitch)
                 }
                 
                 return cell
             }
         }else if indexPath.section == 1 {
             let  cell = tableView.dequeueReusableCell(withIdentifier: "NormalCell", for: indexPath)
             cell.selectionStyle = .none
             cell.backgroundColor = .systemBackground
             switch indexPath.item {
             case 0 :
                 cell.textLabel?.text = "Privacy policy".l10n()
             default:
                 cell.textLabel?.text = ""
             }
             
             return cell
         }else if indexPath.section == 3 {
             let  cell = tableView.dequeueReusableCell(withIdentifier: "NormalCell", for: indexPath)
             cell.selectionStyle = .none
             cell.backgroundColor = .systemBackground
             cell.textLabel?.text = appName[indexPath.item]
             return cell
         }else{
             if indexPath.item == 0 {
                 let  cell = tableView.dequeueReusableCell(withIdentifier: "NormalCell", for: indexPath)
                 cell.selectionStyle = .none
                 cell.backgroundColor = .systemBackground
                 cell.textLabel?.text = "VipCard v1.3.1(2023-12)"
                 return cell
             }else{
                 let  cell = tableView.dequeueReusableCell(withIdentifier: "NormalCell", for: indexPath)
                 cell.selectionStyle = .none
                 cell.backgroundColor = .systemBackground
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
        }else if indexPath.section == 1 {
            guard let url = URL(string: "https://lerosua.montaigne.io/privacy-policy-bank-card-english") else {
              return
            }

            let webVC = SFSafariViewController(url: url)
            present(webVC, animated: true)
        }else if indexPath.section == 3 {
            guard let url = URL(string: appLink[indexPath.item]) else {
              return
            }

            let webVC = SFSafariViewController(url: url)
            present(webVC, animated: true)
        }
    }
    


    @objc func leftButtonItemClicked(sender:UIBarButtonItem){
        
        self.dismiss(animated: true, completion: nil)
    }
    func configuredMailComposeViewController() -> MFMailComposeViewController {
      
      let mailComposerVC = MFMailComposeViewController()
      mailComposerVC.mailComposeDelegate = self // 遵循 MFMailComposeViewControllerDelegate 协议
      
      mailComposerVC.setToRecipients(["lerosua+bankcard@gmail.com"])
      mailComposerVC.setSubject("Feedback for BankCard")
      mailComposerVC.setMessageBody("Hey, I have some problem with you ....", isHTML: false)

      return mailComposerVC
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        self.dismiss(animated: true)
    }
    
    func updateSwitchState(changeSwitch:UISwitch){
        
        if changeSwitch.isOn {
            let alertController = UIAlertController(title: "Info".l10n(), message: "Enabling biometric authentication to view your saved bank passwords helps better protect your information".l10n(), preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Confirm".l10n(), style: .default) { (_) in
                let currentType = BCLAContext.shareInstance.biometricType
                if currentType == .none {
                    print("Not support")
                    self.showNormalAlert(title: "Alert".l10n(), message: "No FaceID/TouchID support".l10n())
                    changeSwitch.isOn = false
                    return
                }
                self.settings[kUseLockKey] = changeSwitch.isOn
                self.saveSetting()
            }
            let cancelAction = UIAlertAction(title:"Cancel".l10n(),style: .cancel){(_) in
                changeSwitch.isOn = false
                return
            }
            alertController.addAction(cancelAction)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }

    }
    func updateAppIconState(changeSwitch:UISwitch){
        if changeSwitch.isOn {
            UIApplication.shared.setAlternateIconName("AppIcon-two")
        }else{
            UIApplication.shared.setAlternateIconName(nil,completionHandler: nil)
        }
        settings[kChangeAppIconKey] = changeSwitch.isOn
        saveSetting()
    }
    
}
