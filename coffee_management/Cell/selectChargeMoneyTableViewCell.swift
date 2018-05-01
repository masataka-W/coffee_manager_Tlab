//
//  selectChargeMoneyTableViewCell.swift
//  coffee_management
//
//  Created by kota on 2018/04/29.
//  Copyright © 2018年 Masataka W. All rights reserved.
//

import UIKit

protocol chargeMoneyDelegate {
    func chargeMoneyChoise(tag: Int)
}

class selectChargeMoneyTableViewCell: UITableViewCell {
    
    var delegate: chargeMoneyDelegate?
    
    @IBOutlet weak var chargeMoneyButton: UIButton!
    @IBAction func chargeMoneyButton(_ sender: Any) {
        delegate?.chargeMoneyChoise(tag: self.tag)
        print("きちんと押されたよ")
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        chargeMoneyButton.layer.cornerRadius = chargeMoneyButton.frame.width / 2
    }
}
