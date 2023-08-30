//
//  BankInputCell.swift
//  bankcard
//
//  Created by rosua le on 2023/8/30.
//

import UIKit

class BankInputCell: UITableViewCell {
    
    @IBOutlet var titleLabel:UILabel!
    @IBOutlet var contentField:UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
