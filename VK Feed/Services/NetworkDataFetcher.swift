//
//  NetworkDataFetcher.swift
//  VK Feed
//
//  Created by Nikolay Gutorov on 4/7/21.
//  Copyright © 2021 Nikolay Gutorov. All rights reserved.
//

import Foundation

protocol DataFetcher {
    func getFeed(response: @escaping (NewsFeedResponse?) -> Void)
}

struct NetworkDataFetcher: DataFetcher {
    
    let networking: Networking
    
    init(networking: Networking) {
        self.networking = networking
    }
    
    func getFeed(response: @escaping (NewsFeedResponse?) -> Void) {
        let params = ["filters": "post, photo"]
        networking.request(path: API.newsFeed, params: params) { (data, error) in
            if let error = error {
                print("Error while requesting the Feed: \(error.localizedDescription)")
                response(nil)
            }
            let decoder = self.decodeJSON(type: NewsFeedResponseWrapped.self, from: data)
            response(decoder?.response)
        }
    }
    
    private func decodeJSON<T: Decodable>(type: T.Type, from: Data?) -> T? {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        guard let data = from, let response = try? decoder.decode(type.self, from: data) else { return nil }
        return response
    }
}
