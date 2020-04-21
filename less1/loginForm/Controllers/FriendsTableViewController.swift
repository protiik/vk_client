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
    var token: [NotificationToken] = []
    var requestHandler: UInt = 0
    var cachedImaged = [String: UIImage]()
    
    @IBOutlet weak var searhBar: UISearchBar!
    
    var sections = [Section]()
    var searchFriend = [Search]()
    
    
    var searchAns = [String]()
    var searching = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "TestTableViewHeader", bundle: nil), forHeaderFooterViewReuseIdentifier: "HeaderView")
        
        friendService.loadData {
//            self.loadData()
            self.prepareSections()
        }
        
        
        let db = Database.database().reference()
        requestHandler = db.child("id").observe(.value, with: { snapshot in
            guard let id = snapshot.value as? [String] else {return}
            print (id)
        })
        
        
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
                    tableView.insertRows(at: insertions.map({IndexPath(row: $0, section: section)}), with: .automatic)
                    tableView.deleteRows(at: deletions.map({IndexPath(row: $0, section: section)}), with: .automatic)
                    tableView.reloadRows(at: modifications.map({IndexPath(row: $0, section: section)}), with: .automatic)
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
            }
            DispatchQueue.main.async {
                self.tableView.reloadRows(at: [indexPath], with: .automatic)
                self.tableView.tableHeaderView?.reloadInputViews()
            }
        }
    }
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        if searching {
            return searchMassive.count
        }else {
            return friendsList.count
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searching {
            return searchMassive[section].count
        }else {
            return friendsList[section].count
        }
    }
    
//    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "HeaderView") as? TestTableViewHeader else {
//            preconditionFailure("нет связи HeaderView")}
//
//        if searching {
//            headerView.someLabel.text = searchMassive[section].first?.name.first?.uppercased()
//        }else {
//            headerView.someLabel.text = friendsList[section].first?.name.first?.uppercased()
//        }
//
//        headerView.layer.backgroundColor = #colorLiteral(red: 0.1813154817, green: 0.5886535645, blue: 0.9971618056, alpha: 1)
//
//        return headerView
//    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FriendsCell", for: indexPath) as? FriendsCell else {
            preconditionFailure("нет связи FriendsCell")
        }
        //         Если есть буква в сеарч баре тогда
        if searching {
            let element = searchMassive[indexPath.section][indexPath.row]
            cell.nameLabel.text = element.name// имя
            //картинка
            let image = element.photo
            if let cahed = cachedImaged[image]{
                cell.imageFriendView.image = cahed
            }else {
                downloadImage(for: image, indexPath: indexPath)
            }

        }else {
            let element = friendsList[indexPath.section][indexPath.row]
            let image = element.photo
            if let cahed = cachedImaged[image]{
                cell.imageFriendView.image = cahed
            }else {
                downloadImage(for: image, indexPath: indexPath)
            }
            
            cell.nameLabel.text =  element.name
            //картинка

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

            if searching {
                let element = searchMassive[indexPath.section][indexPath.row] // id элемента
                let destinationViewController = segue.destination as? FriendCollectionController //определение куда передаем инфу
                destinationViewController?.collectionFriendName = element.name
                //картинка
                
            }else {
                let section = friendsList[indexPath.section] // id элемента
                let element = section[indexPath.row]
                let destinationViewController = segue.destination as? FriendCollectionController //определение куда передаем инфу
                destinationViewController?.collectionFriendName = element.name
                //картинка
                destinationViewController?.collectionFriendImage = element.photo
                Session.shared.userId = element.id
            }
            
            //            let section = friendsList[indexPath.row]
            //            let firstFriendName = section.fisrtName
            //            let lasFriendName = section.lastName
            //            let image = section.photoFull
            //            let id = section.id
            //            let destinationViewController = segue.destination as? FriendCollectionController
            //            destinationViewController?.collectionFriendName = "\(firstFriendName) \(lasFriendName)"
            //            destinationViewController?.collectionFriendImage = image
            //            Session.shared.userId = id
        }
    }
}
    

// Поиск
extension FriendsTableViewController : UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searching = true
    
        //Поиск
//        searchAns = searchMassive.filter({$0!.contains(searchText)}) as! [String]
//        //Сортировка под новую структуру
//        let groupedDictionary = Dictionary(grouping: searchAns, by: {String($0.prefix(1))})
//        let keys = groupedDictionary.keys.sorted()
//        searchFriend = keys.map{ Search(letter: $0, names: groupedDictionary[$0]!.sorted()) }

//        do {
//                   let realm = try Realm()
//                   print(realm.configuration.fileURL ?? "Нет данных в БД")
//                   let friendsLetters = Array (Set (realm.objects(FriendsVK.self).compactMap{$0.name.first?.lowercased()})).sorted()
//                   searchMassive = friendsLetters.map {realm.objects(FriendsVK.self).filter("name contains '\(searchText)'", $0)}
//                   token.removeAll()
//                   searchMassive.enumerated().forEach {observeChangesFriends(section: $0.offset, results: $0.element)}
//                   tableView.reloadData()
//               }catch {
//                   print(error.localizedDescription)
//               }
       
        

        print(searchMassive)
        tableView.reloadData()

    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {

        hideKeyboard()
        searching = false
        searchBar.text = ""
        tableView.reloadData()

    }
    //Закрыть клавиатуру
    @objc func hideKeyboard() {
        self.searhBar.endEditing(true)
    }
    
    
    
    
    
}
