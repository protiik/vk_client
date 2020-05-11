//
//  NewsViewController.swift
//  loginForm
//
//  Created by prot on 22/02/2020.
//  Copyright © 2020 prot. All rights reserved.
//

import UIKit
import RealmSwift
class NewsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var refreshControl = UIRefreshControl()
    var newsList: Results<NewsVK>?
    var newsMassiveCell: [NewsVK]{
        guard let news = newsList else { return [] }
        return Array(news)
    }
    var groupsList: [GroupsVK] = []
    var cachedImagedNews = [String: UIImage]()
    var cahedImageGroups = [String: UIImage]()
    let newsService: NewsServiceRequest = NewsRequest(parser: SwiftyJSONParserNews())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let dataDownload = DispatchQueue(label: "download_data_news")
        dataDownload.async {
            self.newsService.loadData { }
        }
        loadData()
        
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(updateNews), for: .valueChanged)
    }
    
    @objc
    func updateNews() {
        newsService.loadData{ [weak self] in
            self?.refreshControl.endRefreshing()
        }
        tableView.reloadData()
    }
    
    func loadData(){
        do{
            let realm = try Realm()
            print(realm.configuration.fileURL ?? "Нет данных в БД")
            let news = realm.objects(NewsVK.self)
            let groups = realm.objects(GroupsVK.self)
            newsList = ( news )
            groupsList = Array(groups)
            tableView.reloadData()
        }catch{
            print(error.localizedDescription)
        }
    }
    private let queueNews = DispatchQueue(label: "download_url")
    private func downloadImageNews (for url: String, indexPath: IndexPath) {
        DispatchQueue.global().async {
            if let image = Session.shared.getImage(url: url){
                self.cachedImagedNews[url] = image
                DispatchQueue.main.async {
                    self.tableView.reloadRows(at: [indexPath], with: .automatic)
                }
            }
        }
    }
    private let queueGroups = DispatchQueue(label: "download_url_groups")
    private func downloadImageGroups (for url: String, indexPath: IndexPath) {
        queueGroups.async {
            if let image = Session.shared.getImage(url: url){
                self.cachedImagedNews[url] = image
                //                    self.tableView.reloadRows(at: [indexPath], with: .none)
                
            }
        }
    }
    
}

extension NewsViewController: UITableViewDelegate, UITableViewDataSource {
    override func viewWillAppear(_ animated: Bool) {
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsMassiveCell.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell", for: indexPath) as? NewsCell else {
            preconditionFailure("нет связи FriendsCell")
        }
        let element = newsMassiveCell[indexPath.row]
        cell.textView.text = element.text
        cell.likes.text = element.likes
        cell.comments.text = element.comments
        cell.reposts.text = element.repost
        cell.views.text = element.views
        
        groupsList.forEach { i in
            if element.id == -(i.id){
                cell.nameGroup.text = i.name
                let image = i.photo
                if let cached = cahedImageGroups[image] {
                    cell.groupImage?.image = cached
                }else {
                    downloadImageGroups(for: image , indexPath: indexPath)
                }

            }
        }
        
        let image = element.newsPhoto
        
        if let cached = cachedImagedNews[image ] {
            cell.postImage?.image = cached
        }else {
            downloadImageNews(for: image , indexPath: indexPath)
        }
        return cell
    }
    
    
    
    
    
    
}
