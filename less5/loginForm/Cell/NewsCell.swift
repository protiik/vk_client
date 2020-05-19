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
    @IBOutlet weak var likes: UILabel!
    @IBOutlet weak var comments: UILabel!
    @IBOutlet weak var reposts: UILabel!
    @IBOutlet weak var views: UILabel!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var groupImage: UIImageView!
    @IBOutlet weak var nameGroup: UILabel!
    
    override func layoutSubviews() {
        groupImage.layer.cornerRadius = groupImage.frame.height / 2
        textView.isScrollEnabled = false
        textView.isEditable = false
        if textView.text.count > 150 {
            textView.isScrollEnabled = true
        }
//        if textView.text.count > 100{
//            heightTextView.constant = 77
//        }
//    }
    
//        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 5, right: 0))
        
    }
    override func prepareForReuse() {
               super.prepareForReuse()
               textView.text = nil
               likes.text = nil
               comments.text = nil
               reposts.text = nil
               views.text = nil
           
    }
    
}
