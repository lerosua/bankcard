//
//  CardTableViewCell.swift
//  ZJTableViewManagerExample
//
//  Created by Jie Zhang on 2019/8/15.
//  Copyright © 2019 . All rights reserved.
//

import UIKit

let openHeight: CGFloat = (UIScreen.main.bounds.size.width - 30) * (593 / 939) + 25
let closeHeight: CGFloat = 54
class CardTableViewCellItem: ZJTableViewItem {
    var isOpen = false
    var zPosition: CGFloat = 0
    var data:CardPassObj?
    
    override init() {
        super.init()
        cellHeight = closeHeight
        selectionStyle = .none
    }
    init(obj :CardPassObj){
        super.init()
        cellHeight = closeHeight
        selectionStyle = .none
        data = obj
    }
    
    func openCard() {
        isOpen = true
        cellHeight = openHeight
    }

    func closeCard() {
        isOpen = false
        cellHeight = closeHeight
    }
}

class CardTableViewCell: UITableViewCell, ZJCellProtocol {


    
    var item: CardTableViewCellItem!
    @IBOutlet var nameLabel:UILabel!
    @IBOutlet var numberLabel:UILabel!
    @IBOutlet var passLabel:UILabel!
//    @IBOutlet var bgImgView:UIImageView!
    @IBOutlet var editBtn :UIButton!
    @IBOutlet var logoView:UIImageView!
    
    typealias ZJCellItemClass = CardTableViewCellItem

    @IBOutlet var cardView: UIView!
    @IBOutlet var cardImg: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let radius: CGFloat = 15
        cardView.layer.cornerRadius = radius
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOpacity = 0.5
        cardView.layer.shadowOffset = CGSize(width: 0.5, height: 0.5)
        cardView.layer.shadowRadius = radius
        cardImg.layer.cornerRadius = radius
        cardImg.clipsToBounds = true
        
        //设置渐变
        let layerGradient = getLineGradintLayer(ui:cardImg,fromHexColor:"8FD3F4", toHexColor:"84FAB0")
        cardImg.layer.addSublayer(layerGradient)
        
    }
    func cellPrepared() {
        layer.zPosition = item.zPosition
    }
    func cellWillAppear() {
         layer.masksToBounds = false
        contentView.layer.masksToBounds = false
        self.nameLabel.text = item.data?.name
        self.numberLabel.text = item.data?.cardNumber
        self.passLabel.text = item.data?.password
    
    }
    
    @IBAction func editButtonAction(sender :UIButton){
        print("edit action")
    }
    @IBAction func showButtonAction(sender :UIButton){
        print("show pass")
    }
    
    
}
