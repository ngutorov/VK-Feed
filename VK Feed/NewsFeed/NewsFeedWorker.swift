//
//  NewsFeedWorker.swift
//  VK Feed
//
//  Created by Nikolay Gutorov on 4/7/21.
//  Copyright (c) 2021 Nikolay Gutorov. All rights reserved.
//

import UIKit

class NewsFeedService {
    
    var authService: AuthService
    var networking: Networking
    var dataFetcher: DataFetcher
    
    private var revealedPostIds: [Int] = []
    private var feedResponse: NewsFeedResponse?
    private var newFromInProcess: String?
    
    init() {
        self.authService = SceneDelegate.shared().authService
        self.networking = NetworkService(authService: authService)
        self.dataFetcher = NetworkDataFetcher(networking: networking)
    }
    
    func getUser(completion: @escaping (UserResponse?) -> Void) {
        dataFetcher.getUser { (userResponse) in
            completion(userResponse)
        }
    }
    
    func getFeed(completion: @escaping ([Int], NewsFeedResponse) -> Void) {
        dataFetcher.getFeed(nextBatchFrom: nil) { [weak self] (feedResponse) in
            self?.feedResponse = feedResponse
            guard let feedResponse = self?.feedResponse else { return }
            completion(self!.revealedPostIds, feedResponse)
        }
    }
    
    func revealPostIds(forPostId postId: Int, completion: @escaping ([Int], NewsFeedResponse) -> Void) {
        revealedPostIds.append(postId)
        guard let feedResponse = self.feedResponse else { return }
        completion(revealedPostIds, feedResponse)
    }
    
    func getNextBatch(completion: @escaping ([Int], NewsFeedResponse) -> Void) {
        newFromInProcess = feedResponse?.nextFrom
        dataFetcher.getFeed(nextBatchFrom: newFromInProcess) { [weak self] (feedResponse) in
            guard let feedResponse = feedResponse else { return }
            guard self?.feedResponse?.nextFrom != feedResponse.nextFrom else { return }
            
            if self?.feedResponse == nil {
                self?.feedResponse = feedResponse
            } else {
                self?.feedResponse?.items.append(contentsOf: feedResponse.items)
                
                var profiles = feedResponse.profiles
                if let oldProfiles = self?.feedResponse?.profiles {
                    let oldProfilesFiltered = oldProfiles.filter { (oldProfile) -> Bool in
                        !feedResponse.profiles.contains(where: { $0.id == oldProfile.id })
                    }
                    profiles.append(contentsOf: oldProfilesFiltered)
                }
                self?.feedResponse?.profiles = profiles
                
                var groups = feedResponse.groups
                if let oldGroups = self?.feedResponse?.groups {
                    let oldGroupsFiltered = oldGroups.filter { (oldGroups) -> Bool in
                        !feedResponse.groups.contains(where: { $0.id == oldGroups.id })
                    }
                    groups.append(contentsOf: oldGroupsFiltered)
                }
                self?.feedResponse?.groups = groups
                
                self?.feedResponse?.nextFrom = feedResponse.nextFrom
            }
            
            guard let response = self?.feedResponse else { return }
            completion(self!.revealedPostIds, response)
        }
    }
}
