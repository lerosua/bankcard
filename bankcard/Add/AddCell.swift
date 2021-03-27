//
//  AddCell.swift
//  bankcard
//
//  Created by rosua le on 2021/3/20.
//

import UIKit

class AddCell: UITableViewCell {
    @IBOutlet var imgView:UIImageView!
    @IBOutlet var nameLabel:UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupWithBank(name:String){
        
        imageView?.image = UIImage(named: name)
        nameLabel.text = name.l10n()
    }
}
