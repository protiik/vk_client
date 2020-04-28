//
//  FriendsRequest.swift
//  loginForm
//
//  Created by prot on 17.03.2020.
//  Copyright © 2020 prot. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import RealmSwift

class FriendsVK: Object {
    @objc dynamic var id = Int()
    @objc dynamic var name = ""
    @objc dynamic var photo = String()
    @objc dynamic var photoFull = String()
    
    
}

protocol FriendsServiceRequest {
    func loadData (handler: @escaping () -> Void)
}

protocol FriendsParser {
    func parse (data: Data) -> [FriendsVK]
}

class SwiftyJSONParserFriends: FriendsParser {
    func parse(data: Data) -> [FriendsVK] {
        do{
            let json = try JSON(data:data)
            let response = json["response"]
            let items = response["items"].arrayValue
            
            let result = items.map{item -> FriendsVK in
                let friends = FriendsVK()
                friends.id = item["id"].intValue
                let firstName = item["first_name"].stringValue
                let lastName = item["last_name"].stringValue
                friends.name = "\(firstName) \(lastName)"
                friends.photo = item["photo_50"].stringValue
                friends.photoFull = item["photo_100"].stringValue
                
                return friends
            }
            return result
        }catch{
            print(error.localizedDescription)
            return []
        }
    }
}

class FriendRequest: FriendsServiceRequest {
    let parser: FriendsParser
    func save( friends: [FriendsVK] )  {
        do {
            let realm = try Realm()
            let oldFriends = realm.objects(FriendsVK.self)
            realm.beginWrite()
            realm.delete(oldFriends)
            realm.add(friends)
            try realm.commitWrite()
        }catch{
            print(error.localizedDescription)
        }
        
    }
    
    init (parser: FriendsParser) {
        self.parser = parser
    }
    
    func loadData(handler: @escaping () -> Void) {
        
        let baseURL = "https://api.vk.com/method"
        let apiKey = Session.shared.token
        
        let path = "/friends.get"
        let url = baseURL + path
        
        let parameters: Parameters = [
            "fields": "name, photo_50, photo_100",
            "v": "5.52",
            "access_token": apiKey
        ]
        
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON { [handler] (response) in
            guard let data = response.data else { return }
            
            let friends: [FriendsVK] = self.parser.parse(data: data)
            self.save(friends: friends)
            handler()
        }
    }
}
