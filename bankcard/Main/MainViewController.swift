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
//        let space = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
//        space.width = 10

        navigationItem.rightBarButtonItems = [addBtn,sysBtn]

    }
    
    @objc func addButtonTapped(){
        let vc = AddBankCardViewController()
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
        NotificationCenter.default.addObserver(self, selector: #selector(handleUpdateObj(notification:)), name: .updateCardNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector:#selector(handleDeleteObj(notification:)) , name: .delCardNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleAddObj(notification:)), name: .addCardNotification, object: nil)
    }
    
    func loadData(){
        
//        if let rawList = UserDefaults.standard.data(forKey: DataListKey) {
//            guard let array = try? JSONDecoder().decode([CardPassObj].self, from: rawList) else { return }
//        if let array = CardPassObj.GetCardPassList(){

            self.dataList = CardPassObj.GetCardPassList()
            var index = 0
        for obj in self.dataList {
                let item = CardTableViewCellItem(obj: obj)
                dataSection.add(item: item)
                item.zPosition = CGFloat(index)
                // cell tap event
                item.setSelectionHandler { [unowned self] (selectItem: CardTableViewCellItem) in
                    self.cellTapEvent(item: selectItem)
                }
                item.setEditHandler{ [unowned self] (selectItem: CardTableViewCellItem) in
                    self.cellEditEvent(item: selectItem)
                }
                item.setLockHandler{ [unowned self] (selectItem: CardTableViewCellItem) in
                    self.cellunLockEvent(item: selectItem)
                }
                index += 1
            }
//        }
        
        manager.reload()

    }
    @objc func handleAddObj(notification:Notification){
    //添加多一个银行卡数据
        let obj = notification.object as! CardPassObj
        
        self.dataList.append(obj)
        
        let item = CardTableViewCellItem(obj: obj)
        dataSection.add(item: item)
        item.openCard()
        let index = dataSection.items.count
        item.zPosition = CGFloat(index)
        // cell tap event
        item.setSelectionHandler { [unowned self] (selectItem: CardTableViewCellItem) in
            self.cellTapEvent(item: selectItem)
        }
        item.setEditHandler{ [unowned self] (selectItem: CardTableViewCellItem) in
            self.cellEditEvent(item: selectItem)
        }
        item.setLockHandler{ [unowned self] (selectItem: CardTableViewCellItem) in
            self.cellunLockEvent(item: selectItem)
        }
        manager.reload()
        
        //保存数据
//        UserDefaults.standard.set(classArray: self.dataList, key: DataListKey)
        CardPassObj.SaveCardPassList(dataList: self.dataList)

    }
    @objc func handleUpdateObj(notification:Notification){
    //应该是数据更新
        let item = notification.object as! CardTableViewCellItem
        let cell = tableView.cellForRow(at: item.indexPath) as! CardTableViewCell
        cell.updateData(item: item)
        manager.reload()
        
        if let data = item.data {
            let obj = self.dataList[item.indexPath.item]
            obj.copywith(item: data)
            //保存数据
//            UserDefaults.standard.set(classArray: self.dataList, key: DataListKey)
            CardPassObj.SaveCardPassList(dataList: self.dataList)
            print("update data with \(data)")
        }
    }
    @objc func handleDeleteObj(notification:Notification){
    //删除一个银行卡数据
        let item = notification.object as! CardTableViewCellItem
//        self.tableView.setEditing(true, animated: true)
        self.dataList.remove(at: item.indexPath.item)
        item.delete()
        manager.reload()
        //保存数据
//        UserDefaults.standard.set(classArray: self.dataList, key: DataListKey)
        CardPassObj.SaveCardPassList(dataList: self.dataList)
    }
    func cellEditEvent(item: CardTableViewCellItem) {
        print("edit action====with \(item.indexPath.item)")
        let vc = EditBankCardViewController(item: item)
        let nav = UINavigationController(rootViewController:vc)
        present(nav,animated:true,completion:nil)

    }
    func cellunLockEvent(item: CardTableViewCellItem) {
        print("show action====")

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
