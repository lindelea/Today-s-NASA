//
//  Models.swift
//  Today's NASA
//
//  Created by Jie Wu on 2019/01/11.
//  Copyright © 2019 lindelin. All rights reserved.
//

import UIKit

struct Photo: Codable {
    var title: String
    var content: String
    var url: URL
    var copyright: String?
    var date: String
    var mediaType: String
    
    enum CodingKeys: String, CodingKey {
        case title
        case content = "explanation"
        case url
        case copyright
        case date
        case mediaType = "media_type"
    }
    
    static func fetchPhotoInfo(date: String = "", callback: @escaping (Photo?) -> Void) {
        let baseURL = URL(string: "https://api.nasa.gov/planetary/apod")!
        let query: [String: String] = [
            "api_key": "LsaXS1HWv6bqRi2DJKxOFNoyqSSteqVnM5j9UD64",
            "date": date
        ]
        let url = baseURL.withQueries(query)!
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data {
                let coder = JSONDecoder()
                let photo = try? coder.decode(Photo.self, from: data)
                callback(photo)
            } else {
                callback(nil)
            }
        }
        task.resume()
    }
    
    func fetchImage(callback: @escaping (UIImage?) -> Void) {
        let task = URLSession.shared.dataTask(with: self.url) { (data, response, error) in
            if let data = data {
                let image = UIImage(data: data)
                callback(image)
            } else {
                callback(nil)
            }
        }
        task.resume()
    }
}

struct HistoryPhotos: Codable {
    var photos: [Photo]
    
    enum CodingKeys: String, CodingKey {
        case photos
    }
    
    func store() {
        let coder = JSONEncoder()
        let projectCollection = try! coder.encode(self)
        let cachesDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
        let archiveURL = cachesDirectory.appendingPathComponent("Histories").appendingPathExtension("json")
        try! projectCollection.write(to: archiveURL)
        print("保存成功：", archiveURL)
        NotificationCenter.default.post(name: LocalNotificationService.historyUpdated, object: nil)
    }
    
    static func find() -> HistoryPhotos {
        let coder = JSONDecoder()
        do {
            let cachesDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
            let archiveURL = cachesDirectory.appendingPathComponent("Histories").appendingPathExtension("json")
            let data = try Data(contentsOf: archiveURL)
            let historyPhotos = try coder.decode(HistoryPhotos.self, from: data)
            return historyPhotos
        } catch {
            return HistoryPhotos(photos: [])
        }
    }
}
