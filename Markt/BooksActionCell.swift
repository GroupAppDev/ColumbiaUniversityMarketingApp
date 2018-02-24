//
//  BooksActionCell.swift
//  Markt
//
//  Created by Jeremy Kim on 1/7/18.
//  Copyright © 2018 jkim. All rights reserved.
//

import Foundation
import UIKit

protocol BookActionCellDelegate: class {
    func didTapLikeButton(_ likeButton: UIButton, on cell: BooksActionCell)
}

class BooksActionCell: UITableViewCell{
    
    static let height: CGFloat = 96
    
    @IBOutlet var likeButton: UIButton!
    @IBOutlet var likeCountLabel: UILabel!
    @IBOutlet var timeAgoLabel: UILabel!
    
    weak var delegate: BookActionCellDelegate?
    
    override func awakeFromNib () {
        super.awakeFromNib ()
    }
    
    @IBAction func likeButtonTapped(_ sender: UIButton) {
        delegate?.didTapLikeButton(sender, on: self)
    }
    
    @IBAction func reportButtonTapped(_ sender: Any) {
        let alert = UIAlertController(title: "Report", message: "We will look into this post", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.window?.rootViewController?.present(alert, animated: true, completion: nil)
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    
}
