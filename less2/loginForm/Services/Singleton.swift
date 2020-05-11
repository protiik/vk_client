//
//  Singleton.swift
//  loginForm
//
//  Created by prot on 14.03.2020.
//  Copyright © 2020 prot. All rights reserved.
//

import UIKit

class Singleton {
    private init() {}
    static let shared: Singleton = .init()
    var token: String?
    var userId: Int?
}
