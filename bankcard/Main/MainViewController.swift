//
//  ViewController.swift
//  bankcard
//
//  Created by rosua le on 2021/3/19.
//

import UIKit
import L10n_swift
import EmptyDataSet_Swift
import LocalAuthentication
import SnapKit

let DataListKey :String = "bankListKey"

class MainViewController: UIViewController {

    var tableView: UITableView!
    var manager: ZJTableViewManager!
    var dataSection: ZJTableViewSection!
    var lastOpenItem: CardTableViewCellItem?
    var lastItem: CardTableViewCellItem? //最后一个需要永不关闭

    var addBtnItem:UIBarButtonItem?
    var sysBtnItem:UIBarButtonItem?
    var bottomView:UIView!

    var dataList = [CardPassObj]()
    lazy var authContext:LAContext = {
        return LAContext()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavbar()
        self.setupTableView()
        self.setupNotification()
        self.loadData()
        self.startADTimer()
    }

    func cellTapEvent(item: CardTableViewCellItem) {
        if item == lastItem {
            lastOpenItem?.closeCard()
            lastItem?.openCard()
            manager.updateHeight()
            //解决动画闪烁问题
            tableView.fixCellBounds()
            print("最后一个点击事件")
            return
        }
        
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
        
        self.bottomView = UIView()
        self.view.addSubview(self.bottomView)
        self.bottomView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(200)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        self.tableView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.bottom.equalTo(self.bottomView)
        }
        
    }
    func setupNavbar() {
        title = "VIP Card".l10n()
        let addBtn = UIBarButtonItem(image: UIImage(named: "sys_add")!.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(addButtonTapped))
        addBtnItem = addBtn
        let sysBtn = UIBarButtonItem(image: UIImage(named: "sys_setting")!.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(sysButtonTapped))
        sysBtnItem = sysBtn
        navigationItem.rightBarButtonItems = [addBtn,sysBtn]

    }
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if traitCollection.userInterfaceStyle == .dark {
            addBtnItem?.image = UIImage(named: "sys_add_b")?.withRenderingMode(.alwaysOriginal)
            sysBtnItem?.image = UIImage(named: "sys_setting_b")?.withRenderingMode(.alwaysOriginal)
        }else{
            addBtnItem?.image = UIImage(named: "sys_add")?.withRenderingMode(.alwaysOriginal)
            sysBtnItem?.image = UIImage(named: "sys_setting")?.withRenderingMode(.alwaysOriginal)
        }
    }
    
    @objc func addButtonTapped(){
        if self.dataList.count >= 100 {
            showNormalAlert(title: "Info".l10n(), message: "Can't be more card".l10n())
            return
        }
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
    
    // MARK:-
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.loadAD()
    }
    @objc func timerAction(){
        print("reload ad")
        self.loadAD()
    }
    
    func loadData(){
    
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
           
            index += 1
            lastItem = item
        }
        //保持最后一个的展开
        lastItem?.openCard()
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
        lastItem?.closeCard()
        lastItem = item
        manager.reload()
        
        //保存数据
        CardPassObj.SaveCardPassList(dataList: self.dataList)
        
        if self.dataList.count == 100 {
            showNormalAlert(title: "Info".l10n(), message: "Too many card be added".l10n())
        }

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
            CardPassObj.SaveCardPassList(dataList: self.dataList)
            print("update data with \(data)")
        }
    }
    @objc func handleDeleteObj(notification:Notification){
    //删除一个银行卡数据
        let item = notification.object as! CardTableViewCellItem
        self.dataList.remove(at: item.indexPath.item)
        item.delete()
        
        //重置最后一个
//        if dataSection.items.count > 0 {
//            lastItem = dataSection.items.last
//            lastItem?.openCard()
//        }
        manager.reload()
        //保存数据
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
         if !item.isUnlock{
             let currentType = LAContext().biometricType
             if currentType != .none {
                 authContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "auth".l10n()) { result, error in
                     print("get result \(result)")
                 }
             }
             
        }
    }
}




extension MainViewController:EmptyDataSetSource,EmptyDataSetDelegate {
    
    func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
                return UIImage(named: "empty_bank_list")
    }
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let title = "Record VIP Card ".l10n()
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
    
    func getADHeader()->UIView {
        let adView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 80))
        let naviveItem = SCNativeItem(placementId: TapNavtiveADId)
        let fixSize = naviveItem.showNative(with: adView)
        print("get fix adSize \(fixSize)")
        //重新调整frame
        adView.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: fixSize)
        return adView
    }
    
    func startADTimer(){
        
        // 创建定时器
        Timer.scheduledTimer(timeInterval: 30,
                                        target: self,
                                      selector: #selector(timerAction),
                                      userInfo: nil,
                                       repeats: true)
    }
    func loadAD(){
        TopOnNativeAD.shared.load(placementId: TapNavtiveADId)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            
            for subview in self.bottomView.subviews{
                subview.removeFromSuperview()
            }
            
            let myHeader = self.getADHeader()
            if myHeader.frame.size != CGSizeZero {
                self.bottomView.addSubview(myHeader)
                self.tableView.snp.remakeConstraints { make in
                    make.left.right.top.equalToSuperview()
                    make.bottom.equalTo(self.bottomView)
                }
                self.bottomView.snp.remakeConstraints { make in
                    make.height.equalTo(myHeader.frame.height)
                    make.left.right.equalToSuperview()
                    make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
                }
            }else{
                self.bottomView.snp.remakeConstraints { make in
                    make.height.equalTo(0)
                }
                self.tableView.snp.remakeConstraints { make in
                    make.edges.equalToSuperview()
                }
            }
            self.tableView.reloadData()
        }
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
