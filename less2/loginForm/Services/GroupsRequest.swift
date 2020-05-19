//
//  GroupsRequest.swift
//  loginForm
//
//  Created by prot on 17.03.2020.
//  Copyright © 2020 prot. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import RealmSwift

class GroupsVK: Object {
    @objc dynamic var id = Int()
    @objc dynamic var name = String()
    @objc dynamic var photo = String()
}


protocol GroupsServiceRequest {
    func loadData (handler: @escaping () -> Void)
}

protocol GroupsParser {
    func parse (data: Data) -> [GroupsVK]
}

class SwiftyJSONParserGroups: GroupsParser {
    func parse(data: Data) -> [GroupsVK] {
        do{
            let json = try JSON(data:data)
            let response = json["response"]
            let items = response["items"].arrayValue
            
            let result = items.map{item -> GroupsVK in
                let groups = GroupsVK()
                groups.id = item["id"].intValue
                groups.name = item["name"].stringValue
                groups.photo = item["photo_50"].stringValue
                
                return groups
            }
            return result
        }catch{
            print(error.localizedDescription)
            return []
        }
    }
}

class GroupsRequest: GroupsServiceRequest {

    let dataDownload = DispatchQueue(label: "data_download_AF")
    
    let parser: GroupsParser
    
    func save( groups: [GroupsVK] )  {
        do {
            let realm = try Realm()
            let oldGroups = realm.objects(GroupsVK.self)
            realm.beginWrite()
            realm.delete(oldGroups)
            realm.add(groups)
            try realm.commitWrite()
        }catch{
            print(error.localizedDescription)
        }
        
    }
    
    init(parser: GroupsParser) {
        self.parser = parser
    }
    
    func loadData(handler: @escaping () -> Void) {
        let baseURL = "https://api.vk.com/method"
        let apiKey = Session.shared.token
        
        let path = "/groups.get"
        let url = baseURL + path
        
        let parameters: Parameters = [
            "v": "5.52",
            "access_token": apiKey,
            "extended": 1
        ]
        
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON(queue: dataDownload) { [handler]  (response) in
            guard let data = response.data else { return }
            
            let groups: [GroupsVK] = self.parser.parse(data: data)
            self.save(groups: groups)
            handler()
            
        }
        
    }
    
}
