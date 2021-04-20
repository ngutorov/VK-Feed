//
//  NewsFeedPresenter.swift
//  VK Feed
//
//  Created by Nikolay Gutorov on 4/7/21.
//  Copyright (c) 2021 Nikolay Gutorov. All rights reserved.
//

import UIKit

protocol NewsFeedPresentationLogic {
    func presentData(response: NewsFeed.Model.Response.ResponseType)
}

class NewsFeedPresenter: NewsFeedPresentationLogic {
    
    weak var viewController: NewsFeedDisplayLogic?
    var cellLayoutCalculator: FeedCellLayoutCalculatorProtocol = FeedCellLayoutCalculator()
    
    let dateFormatter: DateFormatter = {
        let dt = DateFormatter()
        dt.locale = Locale.current
        dt.dateFormat = "yyyy-MM-dd HH:mm"
        return dt
    }()
    
    func presentData(response: NewsFeed.Model.Response.ResponseType) {
        
        switch response {
        
        case .presentNewsFeed(let feed, let revealedPostIds):
            let cells = feed.items.map { (feedItem) in
                cellViewModel(from: feedItem, profiles: feed.profiles, groups: feed.groups, revealedPostIds: revealedPostIds)
            }
            
            let newsFeedViewModel = NewsFeedViewModel(cells: cells)
            viewController?.displayData(viewModel: NewsFeed.Model.ViewModel.ViewModelData.displayNewsFeed(feedViewModel: newsFeedViewModel))
        
        case .presentUserInfo(user: let user):
            let userViewModel = UserViewModel.init(photoUrlString: user?.photo100)
            viewController?.displayData(viewModel: NewsFeed.Model.ViewModel.ViewModelData.displayUser(userViewModel: userViewModel))
        }
    }
    
    private func cellViewModel(from feedItem: NewsFeedItem, profiles: [Profile], groups: [Group], revealedPostIds: [Int]) -> NewsFeedViewModel.Cell {
        
        let profile = self.profile(for: feedItem.sourceId, profiles: profiles, groups: groups)
        let photoAttachments = self.photoAttachments(feedItem: feedItem)
        
        let date = Date(timeIntervalSince1970: feedItem.date)
        let dateTitle = dateFormatter.string(from: date)
        let isFullSized = revealedPostIds.contains(feedItem.postId)
        
        let sizes = cellLayoutCalculator.sizes(postText: feedItem.text, photoAttachments: photoAttachments, isFullSizedPost: isFullSized)
        
        let postText = feedItem.text?.replacingOccurrences(of: "<br>", with: "\n")
        
        return NewsFeedViewModel.Cell.init(postId: feedItem.postId,
                                           iconUrlString: profile?.photo ?? "",
                                           name: profile?.name ?? "",
                                           text: postText,
                                           date: dateTitle,
                                           likes: formatCounter(feedItem.likes?.count),
                                           comments: formatCounter(feedItem.comments?.count),
                                           reposts: formatCounter(feedItem.reposts?.count),
                                           views: formatCounter(feedItem.views?.count),
                                           photoAttachments: photoAttachments,
                                           sizes: sizes)
    }
    
    private func formatCounter(_ counter: Int?) -> String? {
        guard let counter = counter, counter > 0 else { return nil }
        var counterString = String(counter)
        if 4...6 ~= counterString.count {
            counterString = String(counterString.dropLast(3)) + "K"
        } else if counterString.count > 6 {
            counterString = String(counterString.dropLast(6)) + "M"
        }
        return counterString
    }
    
    private func profile(for sourceId: Int, profiles: [Profile], groups: [Group]) -> ProfileRepresentable? {
        
        let profilesOrGroups: [ProfileRepresentable] = sourceId >= 0 ? profiles : groups
        let normalSourceId = sourceId >= 0 ? sourceId : -sourceId
        let profileRepresentable = profilesOrGroups.first { (myProfileReperesentable) -> Bool in
            myProfileReperesentable.id == normalSourceId
        }
        return profileRepresentable
    }
    
    private func photoAttachments(feedItem: NewsFeedItem) -> [NewsFeedViewModel.FeedCellPhotoAttachment] {
        guard let attachments = feedItem.attachments else { return [] }
        
        return attachments.compactMap { (attachment) -> NewsFeedViewModel.FeedCellPhotoAttachment? in
            guard let photo = attachment.photo else { return nil }
            return NewsFeedViewModel.FeedCellPhotoAttachment.init(photoUrl: photo.srcBig, width: photo.width, height: photo.height)
        }
    }
}
