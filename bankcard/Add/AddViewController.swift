//
//  File.swift
//  bankcard
//
//  Created by rosua le on 2021/3/20.
//

import UIKit
import L10n_swift

class AddViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTableView()
        self.setupNavbar()
    }

    func setupTableView(){
        self.view.backgroundColor = .white
        self.tableView.register(UINib(nibName: "AddCell", bundle: nil), forCellReuseIdentifier: "AddCell")
//        self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        self.tableView.tableFooterView = UIView()
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
        return 3
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddCell", for: indexPath) as! AddCell

//        if(indexPath.row < self.albumList.count){
//            let name = self.albumList[indexPath.row]
//            cell.nameLabel?.text = name
//            cell.coverImageView?.image = self.getCoverImage(name: name)
//        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let vc = AddBankCardViewController()
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
