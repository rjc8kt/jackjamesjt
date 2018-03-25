//
//  ChatTableView.swift
//  jackjamesjt
//
//  Created by Jack Morris on 3/25/18.
//  Copyright © 2018 Richard James Childress. All rights reserved.
//

import UIKit

class ChatTableView: UITableView {}

class ChatTableViewCell: UITableViewCell {
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var messageText: UILabel!
    
//    @IBOutlet var leftConstraint: NSLayoutConstraint!
//    @IBOutlet var rightConstraint: NSLayoutConstraint!
//    
//    func layout() {
//        if let layer = messageView?.layer {
//            layer.cornerRadius = 5
//            layer.masksToBounds = true
//            layer.shadowOffset = .zero
//            layer.shadowOpacity = 0.2
//            layer.shadowRadius = 10
//            layer.shadowColor = UIColor.black.cgColor
//            layer.masksToBounds = false
//        }
////        self.messageText!.setContentHuggingPriority(.fittingSizeLevel, for: .horizontal)
//        self.messageText!.translatesAutoresizingMaskIntoConstraints = false
//        
//        super.awakeFromNib()
//    }
}
