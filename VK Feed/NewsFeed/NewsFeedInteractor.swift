//
//  NewsFeedInteractor.swift
//  VK Feed
//
//  Created by Nikolay Gutorov on 4/7/21.
//  Copyright (c) 2021 Nikolay Gutorov. All rights reserved.
//

import UIKit

protocol NewsFeedBusinessLogic {
    func makeRequest(request: NewsFeed.Model.Request.RequestType)
}

class NewsFeedInteractor: NewsFeedBusinessLogic {
    
    var presenter: NewsFeedPresentationLogic?
    var service: NewsFeedService?
    
    func makeRequest(request: NewsFeed.Model.Request.RequestType) {
        if service == nil {
            service = NewsFeedService()
        }
        
        switch request {
        case .getNewsFeed:
            service?.getFeed(completion: { [weak self] (revealedPostIds, feedResponse) in
                self?.presenter?.presentData(response: NewsFeed.Model.Response.ResponseType.presentNewsFeed(feed: feedResponse, revealedPostIds: revealedPostIds))
            })
        case .getUser:
            service?.getUser(completion: { [weak self] (userResponse) in
                self?.presenter?.presentData(response: NewsFeed.Model.Response.ResponseType.presentUserInfo(user: userResponse))
            })
        case .revealPostIds(postId: let postId):
            service?.revealPostIds(forPostId: postId, completion: { [weak self] (revealedPostIds, feedResponse) in
                self?.presenter?.presentData(response: NewsFeed.Model.Response.ResponseType.presentNewsFeed(feed: feedResponse, revealedPostIds: revealedPostIds))
            })
        case .getNextBatch:
            self.presenter?.presentData(response: NewsFeed.Model.Response.ResponseType.presentFooterLoader)
            service?.getNextBatch(completion: { (revealedPostIds, feedResponse) in
                self.presenter?.presentData(response: NewsFeed.Model.Response.ResponseType.presentNewsFeed(feed: feedResponse, revealedPostIds: revealedPostIds))
            })
        }
    }
}

