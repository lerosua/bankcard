//
//  File.swift
//  bankcard
//
//  Created by rosua le on 2021/3/20.
//

import UIKit
import L10n_swift

var bankNameList = ["BOC","ABC","CCB","ICBC","OTHER"]


class AddViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTableView()
        self.setupNavbar()
    }

    func setupTableView(){
        self.view.backgroundColor = .white
        self.tableView.register(UINib(nibName: "AddCell", bundle: nil), forCellReuseIdentifier: "AddCell")
        self.tableView.tableFooterView = UIView()
        
        let headView = AddHeadView.loadFromNIB()
        let boxView = UIView(frame: CGRect(x: 0,y: 0,width: screenWidth,height: 120))
        boxView.addSubview(headView)
        self.tableView.tableHeaderView = boxView

        
    }
    
    func setupNavbar() {
        self.title = "Add".l10n()
        let button = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.cancel, target: self, action: #selector(leftButtonItemClicked(sender:)))
        button.tintColor = .red
        self.navigationItem.leftBarButtonItem = button
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0 {
            return bankNameList.count
        }
        return 1
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Bank Card".l10n()
        case 1:
            return "Birth Card".l10n()
        default:
            return "ID Card".l10n()
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddCell", for: indexPath) as! AddCell
        
         let name = bankNameList[indexPath.item]
        cell.setupWithBank(name: name)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let vc = TypeBankInfoViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    @objc func leftButtonItemClicked(sender:UIBarButtonItem){
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func loadData() {
        self.tableView.reloadData()
    }
}
