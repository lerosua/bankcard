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

var colorIndex = 1
let gradientColors = [["E42C66","F55B46"],
                      ["EABE35","EABE35"],
                      ["ED713C","ED713C"],
                      ["E42C66","F55B46"],
                      ["E42C66","F55B46"],
                      ["E42C66","F55B46"],
                      ["E42C66","F55B46"]]

class CardTableViewCell: UITableViewCell, ZJCellProtocol {

    var item: CardTableViewCellItem!
    @IBOutlet var nameLabel:UILabel!
    @IBOutlet var numberLabel:UILabel!
    @IBOutlet var passLabel:UILabel!
    @IBOutlet var editBtn :UIButton!
    @IBOutlet var logoView:UIImageView!
    @IBOutlet var remarkLabel:UILabel!
    @IBOutlet var lockBtn :UIButton!

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
        
        let colorGroup = gradientColors[gradientColors.count%colorIndex]
        //设置渐变
        let layerGradient = getLineGradintLayer(ui:cardImg,fromHexColor:colorGroup[0], toHexColor:colorGroup[1])
        cardImg.layer.addSublayer(layerGradient)
        colorIndex += 1
        
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
        self.lockBtn.setImage(UIImage(named: "unlock"), for: .selected)
    
    }
    
    @IBAction func editButtonAction(sender :UIButton){
        print("edit action")
        if let handler = item.editHandler {
            handler(item)
        }
    }
    @IBAction func showButtonAction(sender :UIButton){
        print("show pass")
        if let handler = item.lockHandler {
            handler(item)
        }
    }
    
    
}
