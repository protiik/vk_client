//
//  FriendsCell.swift
//  loginForm
//
//  Created by prot on 10/02/2020.
//  Copyright © 2020 prot. All rights reserved.
//

import UIKit

class FriendsCell: UITableViewCell {
    
    @IBOutlet weak var shadowView:ShadowView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var imageFriendView: UIImageView!
    
    override func layoutSublayers(of layer: CALayer) {
        imageFriendView.layer.cornerRadius = 35
        shadowView.backgroundColor = .white
        shadowView.animation()
        
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onTap(_:)))
        imageFriendView.isUserInteractionEnabled = true
        imageFriendView.addGestureRecognizer(tapGesture)
        
    }
    
    @objc func onTap(_ sender: UITapGestureRecognizer){
        print("Сжимаем картинку")
        
        
        UIView.animate(withDuration: 2,
                       delay: 0,
                       usingSpringWithDamping: 0.8,
                       initialSpringVelocity: 10,
                       animations: {
                        self.shadowView.transform = .init (scaleX: 0.85, y: 0.85)
                        self.shadowView.layer.shadowOpacity = 0
                        self.shadowView.layer.shadowRadius = 0
                        
        })
        UIView.animate(withDuration: 0.7,
                       delay: 1,
                       usingSpringWithDamping: 0.2,
                       initialSpringVelocity: 10,
                        animations: {
                            self.shadowView.transform = .init(scaleX: 1.2, y: 1.2)
                            self.shadowView.layer.shadowOpacity = 1
                            self.shadowView.layer.shadowRadius = 10
                            
        })
        
        UIView.animate(withDuration: 0.7,
                       delay: 2,
                       animations: {
                        self.shadowView.transform = .init (scaleX: 1, y: 1)
                        self.shadowView.layer.shadowOpacity = 1
                        self.shadowView.layer.shadowRadius = 6
        })		
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = nil
        imageFriendView.image = nil
        
    }
    
}

@IBDesignable class ShadowView: UIView{
    
    @IBInspectable var color:UIColor = .black
    @IBInspectable var opacity:Float = 1
    @IBInspectable var radius:CGFloat = 7
    
    func animation() {
        layer.cornerRadius = 34
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = CGSize(width: 4, height: 4)
        layer.shadowRadius = radius
        backgroundColor = .white
        
    }
    
}


