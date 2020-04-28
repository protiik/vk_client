//
//  SearchGroupsRequest.swift
//  loginForm
//
//  Created by prot on 17.03.2020.
//  Copyright © 2020 prot. All rights reserved.
//

import Foundation
import Alamofire

class SearchGroupsRequest {
    
    let baseURL = "https://api.vk.com/method"
    let apiKey = Session.shared.token
    
    func request (group: String) {
        let path = "/groups.search"
        let url = baseURL + path
        
        let parameters: Parameters = [
            "q": group,
            "count": 5,
            "v": "5.53",
            "access_token": apiKey
        ]
        
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON { response in
            print("Поиск групп \(response.value ?? "")")
        }
    }
}
