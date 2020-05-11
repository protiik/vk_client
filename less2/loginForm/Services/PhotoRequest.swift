//
//  PhotoRequest.swift
//  loginForm
//
//  Created by prot on 17.03.2020.
//  Copyright © 2020 prot. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import RealmSwift

class PhotosVK: Object {
    @objc dynamic var photo = String()
}


protocol PhotosServiceRequest {
    func loadData ()
}

protocol PhotosParser {
    func parse (data: Data) -> [PhotosVK]
}

class SwiftyJSONParserPhotos: PhotosParser {
    func parse(data: Data) -> [PhotosVK] {
        do{
            let json = try JSON(data:data)
            let response = json["response"]
            let items = response["items"].arrayValue
            
            let result = items.map{item -> PhotosVK in
                let photos = PhotosVK()
                let sizes = item["sizes"].arrayValue
                if let first = sizes.first(where: {$0["type"].stringValue == "q"}){
                    photos.photo = first["url"].stringValue
                }
                
                return photos
            }
            return result
        }catch{
            print(error.localizedDescription)
            return []
        }
    }
}

class PhotosRequest: PhotosServiceRequest {

    let parser: PhotosParser
    
    func save( photos: [PhotosVK] )  {
        do {
            let realm = try Realm()
            let oldPhotos = realm.objects(PhotosVK.self)
            realm.beginWrite()
            realm.delete(oldPhotos)
            realm.add(photos)
            try realm.commitWrite()
        }catch{
            print(error.localizedDescription)
        }
        
    }
    
    init(parser: PhotosParser) {
        self.parser = parser
    }
    
    let userId = Session.shared.userId
    let baseURL = "https://api.vk.com/method"
    let apiKey = Session.shared.token
    
    func loadData () {
        let path = "/photos.getAll"
        let url = baseURL + path
        
        let parameters: Parameters = [
            "owner_id": userId,
            "v": "5.103",
            "access_token": apiKey
        ]
        print("\(userId)")
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON { (response) in
            guard let data = response.data else { return }
            
            let photos: [PhotosVK] = self.parser.parse(data: data)
            self.save(photos: photos)
        }
        
    }
    
}
