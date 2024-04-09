//
//  URL.swift
//  myHealthClub
//
//  Created by TBC on 14/11/19.
//  Copyright © 2019 TBC. All rights reserved.
//

import Foundation

extension URL{
    
    func withQueries(_ queries:[String:String]) -> URL? {
        var components = URLComponents(url: self, resolvingAgainstBaseURL: true)
        components?.queryItems = queries.compactMap{URLQueryItem(name: $0.0, value: $0.1)}
        return components?.url
    }

    func justQueries(_ queries:[String:String]) -> URL? {
        var components = URLComponents(url: self, resolvingAgainstBaseURL: true)
        components?.queryItems = queries.compactMap{URLQueryItem(name: $0.0, value: $0.1)}
        return components?.url
    }
}
