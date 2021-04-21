//
//  NetworkDataFetcher.swift
//  VK Feed
//
//  Created by Nikolay Gutorov on 4/7/21.
//  Copyright © 2021 Nikolay Gutorov. All rights reserved.
//

import Foundation

protocol DataFetcher {
    func getFeed(nextBatchFrom: String?, response: @escaping (NewsFeedResponse?) -> Void)
    func getUser(response: @escaping (UserResponse?) -> Void)
}

struct NetworkDataFetcher: DataFetcher {
    
    private let authService: AuthService
    let networking: Networking
    
    init(networking: Networking, authService: AuthService = SceneDelegate.shared().authService) {
        self.networking = networking
        self.authService = authService
    }
    
    func getFeed(nextBatchFrom: String?, response: @escaping (NewsFeedResponse?) -> Void) {
        var params = ["filters": "post, photo"]
        params["start_from"] = nextBatchFrom
        networking.request(path: API.newsFeed, params: params) { (data, error) in
            if let error = error {
                print("Error while requesting the Feed: \(error.localizedDescription)")
                response(nil)
            }
            let decoder = self.decodeJSON(type: NewsFeedResponseWrapped.self, from: data)
            response(decoder?.response)
        }
    }
    
    func getUser(response: @escaping (UserResponse?) -> Void) {
        guard  let userId = authService.userId else { return }
        let params = ["user_ids": userId, "fields": "photo_100"]
        networking.request(path: API.user, params: params) { (data, error) in
            if let error = error {
                print("Error receiving requested data: \(error.localizedDescription)")
                response(nil)
            }
            
            let decoded = self.decodeJSON(type: UserResponseWrapped.self, from: data)
            response(decoded?.response.first)
        }
    }
    
    private func decodeJSON<T: Decodable>(type: T.Type, from: Data?) -> T? {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        guard let data = from, let response = try? decoder.decode(type.self, from: data) else { return nil }
        return response
    }
}
