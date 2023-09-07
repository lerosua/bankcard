//
//  SwitchCell.swift
//  bankcard
//
//  Created by rosua le on 2023/8/30.
//

import UIKit

class SwitchCell: UITableViewCell {

    @IBOutlet var titleLabel:UILabel!
    @IBOutlet var switchBtn:UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        self.backgroundColor = .systemBackground
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    // 在CustomCell中
    var switchChanged: ((_ switch: UISwitch) -> Void)?

    @IBAction func switchValueChanged(_ sender: UISwitch) {
      switchChanged?(sender)
    }
}
