//
//  Supports.swift
//  Today's NASA
//
//  Created by Jie Wu on 2019/01/11.
//  Copyright © 2019 lindelin. All rights reserved.
//

import UIKit

extension URL {
    func withQueries(_ queries: [String: String]) -> URL? {
        var components = URLComponents(url: self, resolvingAgainstBaseURL: true)
        components?.queryItems = queries.map { URLQueryItem(name: $0.0, value: $0.1) }
        return components?.url
    }
}
