//
//  NewsFeedModels.swift
//  VK Feed
//
//  Created by Nikolay Gutorov on 4/7/21.
//  Copyright (c) 2021 Nikolay Gutorov. All rights reserved.
//

import UIKit

enum NewsFeed {
   
  enum Model {
    struct Request {
      enum RequestType {
        case getNewsFeed
        case getUser
        case revealPostIds(postId: Int)
      }
    }
    struct Response {
      enum ResponseType {
        case presentNewsFeed(feed: NewsFeedResponse, revealedPostIds: [Int])
        case presentUserInfo(user: UserResponse?)
      }
    }
    struct ViewModel {
      enum ViewModelData {
        case displayNewsFeed(feedViewModel: NewsFeedViewModel)
        case displayUser(userViewModel: UserViewModel)
      }
    }
  }
}

struct UserViewModel: TitleViewViewModel {
    var photoUrlString: String?
}

struct NewsFeedViewModel {
    
    struct Cell: NewsFeedCellViewModel {
        var postId: Int
        var iconUrlString: String
        var name: String
        var text: String?
        var date: String
        var likes: String?
        var comments: String?
        var reposts: String?
        var views: String?
        var photoAttachments: [FeedCellPhotoAttachmentViewModel]
        var sizes: FeedCellSizes
    }
    
    struct FeedCellPhotoAttachment: FeedCellPhotoAttachmentViewModel {
        var photoUrl: String?
        var width: Int
        var height: Int
    }
    
    let cells: [Cell]
}
