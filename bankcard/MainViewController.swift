//
//  ViewController.swift
//  bankcard
//
//  Created by rosua le on 2021/3/19.
//

import UIKit
import ZJTableViewManager

class MainViewController: UIViewController {

    var tableView: UITableView!
    var manager: ZJTableViewManager!
    var section: ZJTableViewSection!
    var lastOpenItem: CardTableViewCellItem?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "UpdateHeight"
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.separatorStyle = .none
        view.addSubview(tableView)
        manager = ZJTableViewManager(tableView: tableView)
        manager.register(CardTableViewCell.self, CardTableViewCellItem.self)
        section = ZJTableViewSection()
        manager.add(section: section)
        section.footerTitle = "银行卡密码管理系统"

        for index in 0 ..< 5 {
            let item = CardTableViewCellItem()
            section.add(item: item)
            item.zPosition = CGFloat(index)
            // cell tap event
            item.setSelectionHandler { [unowned self] (selectItem: CardTableViewCellItem) in
                self.cellTapEvent(item: selectItem)
            }
        }

        if let lastItem = section.items.last as? CardTableViewCellItem {
            // Last cell keep open and don't respond to the tap event
            lastItem.openCard()
            lastItem.selectionHandler = nil
        }

        manager.reload()
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
        // 注意：Xcode11.3.1 模拟器上tableview update height存在bug
        // 如果cell是透明的，动画过程中透明部分会变成不透明，影响动画的效果。
        // 真机上面是正常的
        manager.updateHeight()
    }
}

