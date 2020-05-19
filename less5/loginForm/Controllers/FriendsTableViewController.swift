//
//  FriendsTableViewController.swift
//  loginForm
//
//  Created by prot on 10/02/2020.
//  Copyright © 2020 prot. All rights reserved.
//

import UIKit
import RealmSwift
import FirebaseDatabase


class FriendsTableViewController: UITableViewController{
    
    
    let friendService: FriendsServiceRequest = FriendRequest(parser: SwiftyJSONParserFriends())
    var friendsList: [Results<FriendsVK>] = []
    var searchMassive: [Results<FriendsVK>] = []
    private let searchbar: UISearchController = .init()
    var myFriendsCell: [Results<FriendsVK>]{
            return Array(searchbar.isActive ? searchMassive : friendsList)
    }
    var token: [NotificationToken] = []
    var cachedImaged = [String: UIImage]()
   
    
    
    var requestHandler: UInt = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchbar.searchResultsUpdater = self
        tableView.tableHeaderView = searchbar.searchBar
        
        tableView.register(UINib(nibName: "TestTableViewHeader", bundle: nil), forHeaderFooterViewReuseIdentifier: "HeaderView")
        
        
        let dataDownload = DispatchQueue(label: "download_data_friends")
//        dataDownload.async {
//            self.friendService.loadData{
//                self.prepareSections()
//            }
//        }
        prepareSections()
        
        let db = Database.database().reference()
        requestHandler = db.child("id").observe(.value, with: { snapshot in
            guard let id = snapshot.value as? [String] else {return}
            print (id)
        })
        
        
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(updateFriends), for: .valueChanged)
    }
    
    @objc
    func updateFriends() {
        friendService.loadData{ [weak self] in
            self?.refreshControl?.endRefreshing()
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    func prepareSections () {
        do {
            let realm = try Realm()
            print(realm.configuration.fileURL ?? "Нет данных в БД")
            let friendsLetters = Array (Set (realm.objects(FriendsVK.self).compactMap{$0.name.first?.lowercased()})).sorted()
            friendsList = friendsLetters.map {realm.objects(FriendsVK.self).filter("name BEGINSWITH[cd] %s", $0)}
            token.removeAll()
            friendsList.enumerated().forEach {observeChangesFriends(section: $0.offset, results: $0.element)}
            tableView.reloadData()
        }catch {
            print(error.localizedDescription)
        }
    }
    
    func observeChangesFriends (section: Int, results: Results<FriendsVK>) {
        
        token.append (results.observe { changes in
            guard let tableView = self.tableView else { return }
            switch changes {
            case .initial:
                tableView.reloadSections(IndexSet(integer: section), with: .automatic)
            case .update(_, let deletions, let insertions, let modifications):
                tableView.beginUpdates()
                tableView.insertRows(at: insertions.map({IndexPath(row: $0, section: section)}), with: .none)
                tableView.deleteRows(at: deletions.map({IndexPath(row: $0, section: section)}), with: .none)
                tableView.reloadRows(at: modifications.map({IndexPath(row: $0, section: section)}), with: .none)
                tableView.endUpdates()
            case .error(let error):
                print(error.localizedDescription)
            }
        })
    }
    
    //    func loadData () {
    //        do{
    //            let realm = try Realm()
    //            print(realm.configuration.fileURL ?? "Нет данных в БД")
    //            let friends = realm.objects(FriendsVK.self)
    //            friendsList = ( friends )
    //        }catch{
    //            print(error.localizedDescription)
    //        }
    //    }
    
    let queue = DispatchQueue(label: "download_url")
    private func downloadImage (for url: String, indexPath: IndexPath) {
        queue.async {
               if let image = Session.shared.getImage(url: url){
                   self.cachedImaged[url] = image

                   DispatchQueue.main.async {
                       self.tableView.reloadRows(at: [indexPath], with: .automatic)
                   }
               }
           }
    }
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        myFriendsCell.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return myFriendsCell[section].count
    }
    
        override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "HeaderView") as? TestTableViewHeader else {
                preconditionFailure("нет связи HeaderView")
            }
    
            headerView.someLabel.text = myFriendsCell[section].first?.name.first?.uppercased()
            headerView.layer.backgroundColor = #colorLiteral(red: 0.1813154817, green: 0.5886535645, blue: 0.9971618056, alpha: 1)
    
            return headerView
        }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FriendsCell", for: indexPath) as? FriendsCell else {
            preconditionFailure("нет связи FriendsCell")
        }
        let element = myFriendsCell[indexPath.section][indexPath.row]
        cell.nameLabel.text = element.name
        let image = element.photo
        if let cached = cachedImaged[image] {
            cell.imageFriendView.image = cached
        }else {
            downloadImage(for: image , indexPath: indexPath)
        }
        
        return cell
    }
    
    //    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    //        return sections[section].letter
    //    }
    //
    //    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
    //        if searching {
    //            return searchFriend.compactMap{$0.letter.uppercased()}
    //        }else {
    //            return sections.compactMap{$0.letter.uppercased()}
    //        }
    //
    //    }
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    //
    //     Override to support editing the table view.
    //    функция удаления эллементов свайпом
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        let section = friendsList[indexPath.section]
        let name = friendsList[indexPath.section][indexPath.row]
        if editingStyle == .delete {
            // Delete the row from the data source
            do{
                let realm = try Realm()
                realm.beginWrite()
                realm.delete(name)
                try realm.commitWrite()
            }catch{
                print(error.localizedDescription)
            }
        }
    }
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    //Иницилизация при переходе с индификатором
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "Show Friends",
            let indexPath = tableView.indexPathForSelectedRow {
            
            let section = friendsList[indexPath.section] // id элемента
            let element = section[indexPath.row]
            let destinationViewController = segue.destination as? FriendCollectionController //определение куда передаем инфу
            destinationViewController?.collectionFriendName = element.name
            //картинка
            Session.shared.userId = element.id
            
        }
    }
}

extension FriendsTableViewController: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchbar.searchBar.text else { return }
        if text.count > 0 {
        do{
            let realm = try Realm()
            print(realm.configuration.fileURL ?? "Нет данных в БД")
            searchMassive = [realm.objects(FriendsVK.self).filter("name contains [c]%@", text)]
            tableView.reloadData()
        }catch{
            print(error.localizedDescription)
        }
        }else {
            tableView.reloadData()
        }
    }
}

// Поиск
//extension FriendsTableViewController : UISearchBarDelegate {
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        if searchText.count > 0 {
//            searching = true
//            do {
//                let realm = try Realm()
//                print(realm.configuration.fileURL ?? "Нет данных в БД")
//                searchMassive = [realm.objects(FriendsVK.self).filter("name contains [c]%@", searchText)]
//                tableView.reloadData()
//            }catch {
//                print(error.localizedDescription)
//            }
//        }else {
//            searching = false
//            tableView.reloadData()
//        }
//    }
//
//    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
//
//        hideKeyboard()
//        searching = false
//        searchBar.text = ""
//        tableView.reloadData()
//
//    }
//    //Закрыть клавиатуру
//    @objc func hideKeyboard() {
//        self.searhBar.endEditing(true)
//    }
//}

