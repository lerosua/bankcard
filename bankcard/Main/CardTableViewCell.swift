//
//  CardTableViewCell.swift
//  ZJTableViewManagerExample
//
//  Created by Jie Zhang on 2019/8/15.
//  Copyright © 2019 . All rights reserved.
//

import UIKit
import LocalAuthentication

let openHeight: CGFloat = (screenWidth - 30) * (593 / 939) + 25
let closeHeight: CGFloat = 54
class CardTableViewCellItem: ZJTableViewItem {
    var isOpen = false
    var zPosition: CGFloat = 0
    var data:CardPassObj?
    var isUnlock = false
    
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

var colorIndex = 0
let gradientColors = [["#9C2CF3","#3A49F9"],
                      ["E42C66","F55B46"],
                      ["#EDD822","#F38A0C"],
                      ["#20B1FF","#0D51D7"],
                      ["#68EBB5","#00AA7C"],
                      ["#78EDD3","#1279B6"],
                      ["#D2217E","#692D91"]
                      ]

class CardTableViewCell: UITableViewCell, ZJCellProtocol {
    
    var item: CardTableViewCellItem!
    @IBOutlet var nameLabel:UILabel!
    @IBOutlet var numberLabel:UILabel!
    @IBOutlet var passLabel:UILabel!
    @IBOutlet var hidingPassLabel:UILabel!
    
    @IBOutlet var editBtn :UIButton!
    @IBOutlet var logoView:UIImageView!
    @IBOutlet var remarkLabel:UILabel!
    @IBOutlet var lockBtn :UIButton!
    
    typealias ZJCellItemClass = CardTableViewCellItem
    @IBOutlet var labelWidthConstraint: NSLayoutConstraint!
    @IBOutlet var passLabelWidthConstraint: NSLayoutConstraint!

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
        
        let colorGroup = gradientColors[colorIndex%gradientColors.count]
        //设置渐变
        let layerGradient = getLineGradintLayer(ui:cardImg,fromHexColor:colorGroup[0], toHexColor:colorGroup[1])
        cardImg.layer.addSublayer(layerGradient)
        colorIndex += 1
        print("use color index:\(colorIndex)")
        
    }
    func cellPrepared() {
        layer.zPosition = item.zPosition
    }
    func cellWillAppear() {
        layer.masksToBounds = false
        contentView.layer.masksToBounds = false
        self.nameLabel.text = item.data?.name
        self.passLabel.text = "过期时间:" +  (item.data?.password ?? "")
        self.hidingPassLabel.text = "**** **** ****"
        self.remarkLabel.text = item.data?.remark
         if item.isUnlock {
            self.lockBtn.setImage(UIImage(named: "unlock"), for: .normal)
        }else{
            self.lockBtn.setImage(UIImage(named: "lock"), for: .normal)
        }
        //处理号码
        // 原始文字
        if let originalText = item.data?.cardNumber{
            // 显示处理后的文字
            self.numberLabel.text = originalText.bankNumberString()
        }
        
    }

    func updateData(item:CardTableViewCellItem){
        self.item = item
        self.nameLabel.text = item.data?.name
        self.passLabel.text = "过期时间:" +  (item.data?.password ?? "")
        self.numberLabel.text = item.data?.cardNumber.bankNumberString()
        self.remarkLabel.text = item.data?.remark
    }
    
    
    @IBAction func editButtonAction(sender :UIButton){
        print("edit action")
        if let handler = item.editHandler {
            handler(item)
        }
    }
    @IBAction func showButtonAction(sender :UIButton){
        print("show pass")
        
        let context = BCLAContext.shareInstance
        
        if !item.isUnlock && BCLAContext.getUseAuthState() {
            let currentType = context.biometricType
            if currentType != .none {
                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "auth".l10n()) { result, error in
                    print("get result \(result)")
                    if result {
                        //回主线程操作UI
                        DispatchQueue.main.async {
                            self.item.isUnlock = !self.item.isUnlock
                            let state = self.item.isUnlock
                            if state {
                                self.shrinkAnimation()
                            }else{
                                self.expandAnimation()
                            }
                        }
                    }else{
                        print("认证失败 \(String(describing: error))")
                    }
                    
                }
            }
        }else{
            item.isUnlock = !item.isUnlock
            let state = item.isUnlock
            if state {
                shrinkAnimation()
            }else{
                expandAnimation()
            }
        }
    }
    
    func shrinkAnimation() {
          UIView.animate(withDuration: 1.0, animations: {
              self.labelWidthConstraint.constant = 0
              self.passLabelWidthConstraint.constant = 100
              self.lockBtn.setImage(UIImage(named: "unlock"), for: .normal)
              self.layoutIfNeeded()
          }) { (completed) in
              if completed {
              }
          }
      }
      
      func expandAnimation() {
          UIView.animate(withDuration: 1.0, animations: {
              self.labelWidthConstraint.constant = 100
              self.passLabelWidthConstraint.constant = 0
              self.lockBtn.setImage(UIImage(named: "lock"), for: .normal)
              self.layoutIfNeeded()
          }) { (completed) in
              if completed {

              }
          }
      }
    
}
