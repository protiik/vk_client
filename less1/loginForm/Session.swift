//
//  Session.swift
//  loginForm
//
//  Created by prot on 17.03.2020.
//  Copyright © 2020 prot. All rights reserved.
//

import UIKit

class Session {
    private init() {}
    static let shared: Session = .init()
    var token = String()
    var userId = Int()
    
    
    func getImage (url:String?) -> UIImage?{
           guard let image = url else { return nil }
           if let url = URL(string: image) {
            return UIImage(data: try! Data(contentsOf: url))
           }
           return nil
       }
}
