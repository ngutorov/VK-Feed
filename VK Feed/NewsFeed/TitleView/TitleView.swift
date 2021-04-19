//
//  TitleView.swift
//  VK Feed
//
//  Created by Nikolay Gutorov on 4/18/21.
//  Copyright © 2021 Nikolay Gutorov. All rights reserved.
//

import UIKit

protocol TitleViewViewModel {
    var photoUrlString: String? { get }
}

class TitleView: UIView {
    
    private var textField = InsertableTextField()
    
    private var avatarView: WebImageView = {
        let imageView = WebImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .orange
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(textField)
        addSubview(avatarView)
        makeConstraints()
    }
    
    func set(userViewModel: TitleViewViewModel) {
        avatarView.set(imageUrl: userViewModel.photoUrlString)
    }
    
    private func makeConstraints() {
        
        // avatarView constraints
        avatarView.anchor(top: topAnchor,
                          leading: nil,
                          bottom: nil,
                          trailing: trailingAnchor,
                          padding: UIEdgeInsets(top: 4, left: 0, bottom: 0, right: 4))
        
        avatarView.heightAnchor.constraint(equalTo: textField.heightAnchor, multiplier: 1).isActive = true
        avatarView.widthAnchor.constraint(equalTo: textField.heightAnchor, multiplier: 1).isActive = true
        
        // textField constraints
        textField.anchor(top: topAnchor,
                         leading: leadingAnchor,
                         bottom: bottomAnchor,
                         trailing: avatarView.leadingAnchor,
                         padding: UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 12))
    }
    
    override var intrinsicContentSize: CGSize {
        return UIView.layoutFittingExpandedSize
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        avatarView.layer.masksToBounds = true
        avatarView.layer.cornerRadius = avatarView.frame.width / 2
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
