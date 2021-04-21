//
//  FooterView.swift
//  VK Feed
//
//  Created by Nikolay Gutorov on 4/20/21.
//  Copyright © 2021 Nikolay Gutorov. All rights reserved.
//

import UIKit

class FooterView: UIView {
    
    private var label: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var loader: UIActivityIndicatorView = {
        let loader = UIActivityIndicatorView()
        loader.translatesAutoresizingMaskIntoConstraints = false
        loader.hidesWhenStopped = true
        return loader
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(label)
        addSubview(loader)
        
        label.anchor(top: topAnchor,
                     leading: leadingAnchor,
                     bottom: nil,
                     trailing: trailingAnchor,
                     padding: UIEdgeInsets(top: 8, left: 20, bottom: 0, right: 20))
        
        loader.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        loader.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 8).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func showLoader() {
        loader.startAnimating()
    }
    
    func setTitle(title: String?) {
        loader.stopAnimating()
        label.text = title
    }
}
