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
    
    enum CodingKeys: String, CodingKey {
        case title
        case content = "explanation"
        case url
        case copyright
    }
    
    static func fetchPhotoInfo(callback: @escaping (Photo?) -> Void) {
        let baseURL = URL(string: "https://api.nasa.gov/planetary/apod")!
        let query: [String: String] = [
            "api_key": "DEMO_KEY"
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
