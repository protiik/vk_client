//
//  GroupsCell.swift
//  loginForm
//
//  Created by prot on 10/02/2020.
//  Copyright © 2020 prot. All rights reserved.
//

import UIKit

class GroupsCell: UITableViewCell {

    @IBOutlet weak var groupNameLabel: UILabel!
    @IBOutlet weak var groupImageView: UIImageView!

    override func layoutSubviews() {
        groupImageView.layer.cornerRadius = 42
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onTap(_:)))
        groupImageView.isUserInteractionEnabled = true
        groupImageView.addGestureRecognizer(tapGesture)
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        groupNameLabel.text = nil
        groupImageView.image = nil
        
    }
        
    @objc func onTap(_ sender: UITapGestureRecognizer){
        print("Сжимаем картинку")
        
        UIView.animate(withDuration: 1,
                       delay: 0,
                       usingSpringWithDamping: 0.8,
                       initialSpringVelocity: 10,
                       animations: {
                        self.groupImageView.transform = .init(scaleX: 0.9, y: 0.9)
        })
        
        UIView.animate(withDuration: 1,
                       delay: 0,
                       animations: {
                        self.groupImageView.transform = .init(scaleX: 1, y: 1)
        })
    }
    
    
    
    
}
