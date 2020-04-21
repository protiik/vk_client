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
//    @objc dynamic var firstName = String()
//    @objc dynamic var lastName = String()
    @objc dynamic var name = ""
    @objc dynamic var photo = String()
    @objc dynamic var photoFull = String()
    
    
}

//class DataBaseFriends {
//    func save( friends: [FriendsVK] ) throws {
//
//        let realm = try Realm()
//        print(realm.configuration.fileURL)
//        realm.beginWrite()
//        realm.add(friends)
//        try realm.commitWrite()
//    }
//
//    func friends() -> [FriendsVK] {
//        do {
//            let realm = try Realm()
//            let objects = realm.objects(FriendsVK.self)
//            return Array(objects)
//        }
//        catch {
//            return []
//        }
//    }
//}

protocol FriendsServiceRequest {
    func loadData (completion: @escaping () -> Void)
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
    
    func loadData(completion: @escaping () -> Void) {
        
        let baseURL = "https://api.vk.com/method"
        let apiKey = Session.shared.token
        
        let path = "/friends.get"
        let url = baseURL + path
        
        let parameters: Parameters = [
            "fields": "name, photo_50, photo_100",
            "v": "5.52",
            "access_token": apiKey
        ]
        
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON { [completion] (response) in
            guard let data = response.data else { return }
            
            let friends: [FriendsVK] = self.parser.parse(data: data)
            self.save(friends: friends)
            completion()
        }
        
    }
    
    //    let baseURL = "https://api.vk.com/method"
    //    let apiKey = Session.shared.token
    //
    //    func request () {
    //        let path = "/friends.get"
    //        let url = baseURL + path
    //
    //        let parameters: Parameters = [
    //            "fields": "name",
    //            "v": "5.52",
    //            "access_token": apiKey
    //        ]
    
    //        Alamofire.request(url, method: .get, parameters: parameters).responseData { response in
    //            print("Запрос друзей \(response.value ?? "")")
    //        }
    
    
    //        Alamofire.request(url, method: .get, parameters: parameters).responseJSON { response in
    //            print("Запрос друзей \(response.value ?? "")")
    //        }
    
    //        Alamofire.request("https://api.vk.com/method/friends.get?v=5.52&access_token=813c1c16e28b5c1ee4876f3b65e8260a8626dbd18a6f5d06faa9db78225b90b00594512ad33a92c3bf0a0").responseJSON { response in
    //            print(response.value)
}
//class SerializerParser: FriendsParser {
//    func parse(data: Data) -> [FriendUrl] {
//        do {
//            let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
//
//            guard let jsonParsed = json as? [String: Any],
//                let response = jsonParsed["response"] as? [String: Any],
//                let items = response["items"] as? [Any] else {return []}
//
//            let result = items.compactMap { raw -> FriendUrl? in
//                guard let point = raw as? [String: Any],
//                    let id = point["id"] as? Int,
//                    let firstName = point["first_name"] as? String,
//                    let lastName = point["last_name"] as? String,
//                    let photo = point["photo_50"] as? String else {return nil}
//
//                var friend = FriendUrl()
//
//                friend.id = id
//                friend.fisrtName = firstName
//                friend.lastName = lastName
//                friend.photo = photo
//
//                return friend
//
//            }
//             return result
//        }catch {
//            print(error.localizedDescription)
//            return []
//        }
//    }
//
//
//
//}
