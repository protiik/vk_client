//
//  AllGroupsTableController.swift
//  loginForm
//
//  Created by prot on 10/02/2020.
//  Copyright © 2020 prot. All rights reserved.
//

import UIKit

class AllGroupsTableController: UITableViewController {

    let searchGroupsUserRequest = SearchGroupsRequest()
    
    @IBOutlet weak var searchBarAllGroup: UISearchBar!
    
    var allGroupsMassive = [
        
        Group(name: "Party", imageGroups: UIImage(named: "party")!),
        Group(name: "Мохнатая мышь", imageGroups: UIImage(named: "мышь")!),
        Group(name: "Справедливый выбор", imageGroups: UIImage(named: "справ")!),
        Group(name: "Мощные ребята", imageGroups: UIImage(named: "мощь")!),
        Group(name: "Траншея моего отца", imageGroups: UIImage(named: "траншея")!),
        Group(name: "Человек vs гепард", imageGroups: UIImage(named: "гепард")!),
        Group(name: "Молодой", imageGroups: UIImage(named: "party")!),
        Group(name: "Жарища", imageGroups: UIImage(named: "мышь")!),
        Group(name: "Как сделать нормальный поиск?", imageGroups: UIImage(named: "справ")!),
        Group(name: "Всю ночь делал", imageGroups: UIImage(named: "мощь")!),
        Group(name: "Как не умереть за Xcodom?", imageGroups: UIImage(named: "траншея")!),
        Group(name: "Пот и кровь", imageGroups: UIImage(named: "гепард")!),
        Group(name: "Развивая бессоницу", imageGroups: UIImage(named: "party")!),
        Group(name: "Подсел на героин", imageGroups: UIImage(named: "мышь")!),
        Group(name: "Перегон авто", imageGroups: UIImage(named: "справ")!),
        Group(name: "Не смотря на все остальное", imageGroups: UIImage(named: "мощь")!),
        Group(name: "Я продолжаю это делать", imageGroups: UIImage(named: "траншея")!),
        Group(name: "А на самом деле, все в порядке", imageGroups: UIImage(named: "гепард")!)
    ]
    
    var searching = false
    var searchAns = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        searchGroupsUserRequest.request(group: "Music")
    }

    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 1
//    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if searching {
            return searchAns.count
        }else {
            return allGroupsMassive.count
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "GroupsCell", for: indexPath) as? GroupsCell else {
            preconditionFailure("Нет связи с GroupsCell")
        }
        
        if searching {
            let allGroup = searchAns[indexPath.row]
            cell.groupNameLabel.text = allGroup
            for i in allGroupsMassive{
                if allGroup == i.name{
                    cell.groupImageView.image = i.imageGroups
                }
            }
            
        }else {
            let allGroup = allGroupsMassive[indexPath.row]
            cell.groupNameLabel.text = allGroup.name
            cell.groupImageView.image = allGroup.imageGroups
        }

        return cell
    }
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension AllGroupsTableController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
        
        var searchMassive = [String]()
        for i in allGroupsMassive{
            searchMassive.append(i.name)
        }
        searchAns = searchMassive.filter({$0.prefix(searchText.count) == searchText})
        
        searching = true
        print(searchAns)
        tableView.reloadData()
        
    }
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        hideKeyboard()
        searching = false
        searchBarAllGroup.text = ""
        tableView.reloadData()
    }
    
    @objc func hideKeyboard() {
        self.searchBarAllGroup.endEditing(true)
    }
    
}
