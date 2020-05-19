//
//  FriendCollectionController.swift
//  loginForm
//
//  Created by prot on 11/02/2020.
//  Copyright © 2020 prot. All rights reserved.
//

import UIKit
import RealmSwift


class FriendCollectionController: UICollectionViewController {
    
    let photoService: PhotosServiceRequest = PhotosRequest(parser: SwiftyJSONParserPhotos())
    var collectionFriendName: String?
    var photosList: Results<PhotosVK>?
    var photosMassive: [PhotosVK]{
        guard let photos = photosList else {return []}
        return Array(photos)
    }
    
    lazy var photosCached = PhotoCache(collection: self.collectionView)
//    var cachedImaged = [String: UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(Session.shared.userId)
        title = collectionFriendName
        
        photoService.loadData{ }
        loadDataFriends()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
    }
    
    func loadDataFriends () {
        do{
            let realm = try Realm()
            print(realm.configuration.fileURL ?? "Нет данных в БД")
            let photos = realm.objects(PhotosVK.self)
            photosList = ( photos )
        }catch{
            print(error.localizedDescription)
        }
            print(photosMassive)
    }
//    let queue = DispatchQueue(label: "download_url")
//    private func downloadImage (for url: String, indexPath: IndexPath) {
//        queue.async {
//            if let image = Session.shared.getImage(url: url){
//                self.cachedImaged[url] = image
//                DispatchQueue.main.async {
//                    self.collectionView.reloadItems(at: [indexPath])
//                }
//            }
//        }
//    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using [segue destinationViewController].
     // Pass the selected object to the new view controller.
     }
     */
    
    // MARK: UICollectionViewDataSource
    
    //    override func numberOfSections(in collectionView: UICollectionView) -> Int {
    //        // #warning Incomplete implementation, return the number of sections
    //        return 0
    //    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
//        print(photosMassive.count)
        return photosMassive.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FriendsCollectionCell", for: indexPath) as! FriendsCollectionCell
        
        let element = photosMassive[indexPath.row]
        let image = element.photo
        cell.friendImageView.image = photosCached.image(indexPath: indexPath, at: image)
        
        return cell
    }
    
    
    @objc func onSwipe(_ sender: UISwipeGestureRecognizer){
        
        
    }
    
    
    // MARK: UICollectionViewDelegate
    
    /*
     // Uncomment this method to specify if the specified item should be highlighted during tracking
     override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment this method to specify if the specified item should be selected
     override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
     override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
     return false
     }
     
     override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
     return false
     }
     
     override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
     
     }
     */
    
}


