//
//  PhotoCache.swift
//  loginForm
//
//  Created by prot on 25.05.2020.
//  Copyright © 2020 prot. All rights reserved.
//

import UIKit
import Alamofire

fileprivate protocol Reloadable {
    
    func reloadRow(index: IndexPath)
    
}

class PhotoCache {
    private let cacheLifeTime: TimeInterval = 60 * 5
    private var images = [String: UIImage]()
    
    let queue = DispatchQueue(label: "download_image_cache")
    
    private static let patName: String = {
        let pathName = "images"
        guard let cacheDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else { return pathName }
        let url = cacheDirectory.appendingPathComponent(pathName)
        if !FileManager.default.fileExists(atPath: url.path) {
            do {
                try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
            }catch {
                print(error.localizedDescription)
            }
        }
        return pathName
    }()
    
    
    private let container: Reloadable
    
    init( table: UITableView) {
        container = Table(table: table)
    }
    
    init( collection: UICollectionView) {
        container = Collection(collection: collection)
    }
    
    
    private func  loadImage(for indexPath: IndexPath, at url: String){
        Alamofire.request(url).responseData(queue: queue) { [weak self] response in
            guard let data = response.data,
                let image = UIImage(data: data) else {return}
            self?.images[url] = image
            
            DispatchQueue.main.async {[weak self] in
                self?.container.reloadRow(index: indexPath)
            }
            
        }
    }
    
    
    func image(indexPath: IndexPath, at url: String) -> UIImage? {
        var image: UIImage?
        if let cached = images[url]{
            image = cached
            print("load ram")
        }
//        else if let cached = readImage(url: url){
//            image = cached
//            print("load HDD")
//        }
        else{
            loadImage(for: indexPath, at: url)
            print("load")
        }
        return image
    }
    
    private func getFilePath( for url: String ) -> String?{
        guard let cachesDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else {return nil}
        let fileName = url.split(separator: "/").last ?? "default"
        return cachesDirectory.appendingPathComponent(PhotoCache.patName + fileName).path
    }
    
    private func saveImageToCache ( url: String, image: UIImage ) {
        if let filepath = getFilePath(for: url),
            let data = image.pngData() {
            FileManager.default.createFile(atPath: filepath, contents: data, attributes: nil)
        }
    }
    
    private func readImage(url: String) -> UIImage? {
        guard let filePath = getFilePath(for: url),
            let info = try? FileManager.default.attributesOfItem(atPath: filePath),
            let modificationDate = info[FileAttributeKey.modificationDate] as? Date else  { return nil }
            
        let timePassed = Date().timeIntervalSince(modificationDate)
        
        if timePassed < cacheLifeTime,
            let image = UIImage(contentsOfFile: filePath){
            images[url] = image
            return image
        }else {
            return nil
        }
    }
    
}

extension PhotoCache {
    
    private class Table: Reloadable {
        let table: UITableView
        init(table:UITableView) {
            self.table = table
        }
        
        func reloadRow(index: IndexPath) {
            table.reloadRows(at: [index], with: .automatic)
        }
    }
    
    private class Collection: Reloadable {
        let collection: UICollectionView
        init(collection: UICollectionView) {
            self.collection = collection
        }
        
        func reloadRow(index: IndexPath) {
            collection.reloadItems(at: [index])
        }
    }
}
