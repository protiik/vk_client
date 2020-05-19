//
//  NewsRequest.swift
//  loginForm
//
//  Created by prot on 27.04.2020.
//  Copyright © 2020 prot. All rights reserved.
//
import Alamofire
import SwiftyJSON
import RealmSwift

class NewsVK: Object{
    @objc dynamic var id = 0
    @objc dynamic var text = ""
    @objc dynamic var newsPhoto = ""
    @objc dynamic var likes = ""
    @objc dynamic var comments = ""
    @objc dynamic var repost = ""
    @objc dynamic var views = ""
}
protocol NewsServiceRequest {
    func loadData (handler: @escaping () -> Void)
}
protocol NewsParser {
    func parse (data: Data) -> [NewsVK]
}
class SwiftyJSONParserNews: NewsParser {
    func parse(data: Data) -> [NewsVK] {
        do{
            let json = try JSON(data:data)
            let response = json["response"]
            let items = response["items"].arrayValue
            
            let result = items.map{item -> NewsVK in
                let news = NewsVK()
                news.text = item["text"].stringValue
                news.id = item["source_id"].intValue
                news.comments = item["comments"]["count"].stringValue
                news.likes = item["likes"]["count"].stringValue
                news.repost = item["reposts"]["count"].stringValue
                news.views = item["views"]["count"].stringValue
                let attachments = item["attachments"].arrayValue
                // attachments -> type == photo
                if let element = attachments.first(where: {$0["type"].stringValue == "photo"}){
                    let photo = element["photo"]
                    let sizes = photo["sizes"].arrayValue
                    if let type = sizes.first(where: {$0["type"].stringValue == "q"}){
                        news.newsPhoto = type["url"].stringValue
                    }
                    // attachments -> type == doc
                }else if let element  = attachments.first(where: {$0["type"].stringValue == "doc"}){
                    let photo = element["doc"]["preview"]["photo"]
                    let sizes = photo["sizes"].arrayValue
                    if let type = sizes.first(where: {$0["type"].stringValue == "o"}){
                        news.newsPhoto = type["src"].stringValue
                    }
                    // attachments -> type == link
                }else if let element  = attachments.first(where: {$0["type"].stringValue == "link"}){
                    let link = element["link"]
                    news.text = link["title"].stringValue
                    let sizes = link["sizes"].arrayValue
                    if let type = sizes.first(where: {$0["type"].stringValue == "q"}){
                        news.newsPhoto = type["url"].stringValue
                    }
                }
                
                return news
            }
            return result
        }catch{
            print(error.localizedDescription)
            return []
        }
    }
}

class NewsRequest: NewsServiceRequest {
    
    let dataDownload = DispatchQueue(label: "data_download_AF")
    
    let parser: NewsParser
    
    func save( news: [NewsVK] )  {
        do {
            let realm = try Realm()
            let oldNews = realm.objects(NewsVK.self)
            realm.beginWrite()
            realm.delete(oldNews)
            realm.add(news)
            try realm.commitWrite()
        }catch{
            print(error.localizedDescription)
        }
        
    }
    
    init (parser: NewsParser) {
        self.parser = parser
    }
    
    func loadData(handler: @escaping () -> Void) {
        
        let baseURL = "https://api.vk.com/method"
        let apiKey = Session.shared.token
        
        let path = "/newsfeed.get"
        let url = baseURL + path
        
        let parameters: Parameters = [
            "filters": "post",
            "count": "15",
            "source_ids":"groups",
            "max_photos": "0",
            "v": "5.103",
            "access_token": apiKey
        ]
        
        Alamofire.request(url, method: .post, parameters: parameters).responseJSON(queue:dataDownload) { [handler] (response) in
            guard let data = response.data else { return }
            
            let news: [NewsVK] = self.parser.parse(data: data)
            self.save(news: news)
            handler()
        }
    }
}
