//
//  NewsFeedCell.swift
//  VK Feed
//
//  Created by Nikolay Gutorov on 4/7/21.
//  Copyright © 2021 Nikolay Gutorov. All rights reserved.
//

import UIKit

protocol NewsFeedCellViewModel {
    var iconUrlString: String { get }
    var name: String { get }
    var text: String? { get }
    var date: String { get }
    var likes: String? { get }
    var comments: String? { get }
    var reposts: String? { get }
    var views: String? { get }
    var photoAttachments: [FeedCellPhotoAttachmentViewModel] { get }
    var sizes: FeedCellSizes { get }
}

protocol FeedCellSizes {
    var postLabelFrame: CGRect { get }
    var attachmentFrame: CGRect { get }
    var bottomViewFrame: CGRect { get }
    var totalHeight: CGFloat { get }
    var moreTextButtonFrame: CGRect { get }
}

protocol FeedCellPhotoAttachmentViewModel {
    var photoUrl: String? { get }
    var width: Int { get }
    var height: Int { get }
}

class NewsFeedCell: UITableViewCell {
    
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var iconImageView: WebImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var postLabel: UILabel!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var commentsLabel: UILabel!
    @IBOutlet weak var repostsLabel: UILabel!
    @IBOutlet weak var viewsLabel: UILabel!
    @IBOutlet weak var postImageView: WebImageView!
    @IBOutlet weak var bottomView: UIView!
    
    static let reuseID = "NewsFeedCell"
    
    override func prepareForReuse() {
        iconImageView.set(imageUrl: nil)
        postImageView.set(imageUrl: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        iconImageView.layer.cornerRadius = iconImageView.bounds.height/2
        iconImageView.clipsToBounds = true
        
        cardView.layer.cornerRadius = 10
        cardView.clipsToBounds = true
        
        backgroundColor = .clear
        selectionStyle = .none
    }
    
//    func set(viewModel: NewsFeedCellViewModel) {
//        iconImageView.set(imageUrl: viewModel.iconUrlString)
//        nameLabel.text = viewModel.name
//        dateLabel.text = viewModel.date
//        postLabel.text = viewModel.text
//        likesLabel.text = viewModel.likes
//        commentsLabel.text = viewModel.comments
//        repostsLabel.text = viewModel.reposts
//        viewsLabel.text = viewModel.views
//
//        postLabel.frame = viewModel.sizes.postLabelFrame
//        postImageView.frame = viewModel.sizes.attachmentFrame
//        bottomView.frame = viewModel.sizes.bottomViewFrame
//
//        if let photoAttachment = viewModel.photoAttachments {
//            postImageView.set(imageUrl: photoAttachment.photoUrl)
//            postImageView.isHidden = false
//        } else {
//            postImageView.isHidden = true
//        }
//    }
}
