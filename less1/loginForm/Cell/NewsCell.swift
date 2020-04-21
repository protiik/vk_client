//
//  NewsCell.swift
//  loginForm
//
//  Created by prot on 22/02/2020.
//  Copyright © 2020 prot. All rights reserved.
//

import UIKit

class NewsCell: UITableViewCell {

    @IBOutlet weak var textView: UITextView!
    
    override func layoutSubviews() {
        textView.isScrollEnabled = false
        textView.isEditable = false
//
        print(textView.text.count)
        if textView.text.count > 150 {
            textView.isScrollEnabled = true
        }
//        if textView.text.count > 100{
//            heightTextView.constant = 77
//        }
//    }
    
    
//}
    }
    
}
