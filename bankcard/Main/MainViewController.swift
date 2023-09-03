//
//  ViewController.swift
//  bankcard
//
//  Created by rosua le on 2021/3/19.
//

import UIKit
import L10n_swift
import EmptyDataSet_Swift

let DataListKey :String = "bankListKey"

class MainViewController: UIViewController {

    var tableView: UITableView!
    var manager: ZJTableViewManager!
    var dataSection: ZJTableViewSection!
    var lastOpenItem: CardTableViewCellItem?

    var dataList = [CardPassObj]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavbar()
        self.setupTableView()
        self.setupNotification()
        self.loadData()
    }

    func cellTapEvent(item: CardTableViewCellItem) {
        item.isOpen = !item.isOpen
        if item.isOpen {
            item.openCard()
            if lastOpenItem != item { // 关闭上一次打开的cell/ close the cell that was last opened
                lastOpenItem?.closeCard()
                lastOpenItem = item
            }
        } else {
            item.closeCard()
        }
        manager.updateHeight()
        //解决动画闪烁问题
        tableView.fixCellBounds()
    }
    
    func setupTableView(){
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.separatorStyle = .none
        view.addSubview(tableView)
        
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        
        manager = ZJTableViewManager(tableView: tableView)
        manager.register(CardTableViewCell.self, CardTableViewCellItem.self)
        dataSection = ZJTableViewSection()
        manager.add(section: dataSection)
        
    }
    func setupNavbar() {
        title = "Bank Card".l10n()
                let addBtn = UIBarButtonItem(image: UIImage(named: "sys_add")!.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(addButtonTapped))
        let sysBtn = UIBarButtonItem(image: UIImage(named: "sys_setting")!.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(sysButtonTapped))
        // 设置间距
        let space = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        space.width = 10

        navigationItem.rightBarButtonItems = [space,addBtn,sysBtn]
 //        navigationItem.leftBarButtonItems = [sysBtn]

    }
    
    @objc func addButtonTapped(){
        let vc = AddBankCardViewController(style: .insetGrouped)
//        let vc = AddViewController()
        let nav = UINavigationController(rootViewController:vc)
        present(nav,animated:true,completion:nil)
    }
    @objc func sysButtonTapped(){
        print("configure tapped")
        let vc = SettingViewController(style: .insetGrouped)
        let nav = UINavigationController(rootViewController:vc)
        present(nav,animated:true,completion:nil)
    }
    
    func setupNotification(){
        NotificationCenter.default.addObserver(self, selector: #selector(handleUpdateObj(notification:)), name: NSNotification.Name(rawValue: "updateObj"), object: nil)
    }
    
    func loadData(){
        
        if let rawList = UserDefaults.standard.data(forKey: DataListKey) {
            guard let array = try? JSONDecoder().decode([CardPassObj].self, from: rawList) else { return }
            
            self.dataList = array
            var index = 0
            for obj in array {
                let item = CardTableViewCellItem(obj: obj)
                dataSection.add(item: item)
                item.zPosition = CGFloat(index)
                // cell tap event
                item.setSelectionHandler { [unowned self] (selectItem: CardTableViewCellItem) in
                    self.cellTapEvent(item: selectItem)
                }
                index += 1
            }
        }
        
        
//        let obj = CardPassObj(type: BankType.Other.rawValue, name: "普通银行", cardNumber: "00481123", password: "passwordxxx", remark: "工资卡")
//
//        for index in 0 ..< 5 {
//            let item = CardTableViewCellItem(obj: obj)
//            dataSection.add(item: item)
//            item.zPosition = CGFloat(index)
//            // cell tap event
//            item.setSelectionHandler { [unowned self] (selectItem: CardTableViewCellItem) in
//                self.cellTapEvent(item: selectItem)
//            }
//        }
        if let lastItem = dataSection.items.last as? CardTableViewCellItem {
            // Last cell keep open and don't respond to the tap event
            lastItem.openCard()
            lastItem.selectionHandler = nil
        }
        manager.reload()

    }
    
    @objc func handleUpdateObj(notification:Notification){
    //添加多一个银行卡数据
        let obj = notification.object as! CardPassObj
        
        self.dataList.append(obj)
        
        let item = CardTableViewCellItem(obj: obj)
        dataSection.add(item: item)
        
        let index = dataSection.items.count
        item.zPosition = CGFloat(index)
        // cell tap event
        item.setSelectionHandler { [unowned self] (selectItem: CardTableViewCellItem) in
            self.cellTapEvent(item: selectItem)
        }
        manager.reload()
        
        //保存数据
        UserDefaults.standard.set(classArray: self.dataList, key: DataListKey)
        
    }

}




extension MainViewController:EmptyDataSetSource,EmptyDataSetDelegate {
    
    func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
                return UIImage(named: "empty_bank_list")
    }
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let title = "Record local bank card password".l10n()
        return NSAttributedString(string: title)
    }
    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView) -> Bool {
        return self.dataList.count == 0
    }
    func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView) -> Bool {
        return true
    }
    func verticalOffset(forEmptyDataSet scrollView: UIScrollView) -> CGFloat {
        return -180;
    }
}

// https://stackoverflow.com/questions/62899815/shadow-cell-flickers-when-animating-the-height
extension UITableView {
    func fixCellBounds() {
        DispatchQueue.main.async { [weak self] in
            for cell in self?.visibleCells ?? [] {
                cell.layer.masksToBounds = false
                cell.contentView.layer.masksToBounds = false
            }
        }
    }
}
