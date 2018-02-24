//
//  LeasesHeaderCell.swift
//  Markt
//
//  Created by Jeremy Kim on 1/7/18.
//  Copyright © 2018 jkim. All rights reserved.
//

import Foundation
import UIKit

class LeasesHeaderCell: UITableViewCell{
    
    static let height: CGFloat = 54
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

}