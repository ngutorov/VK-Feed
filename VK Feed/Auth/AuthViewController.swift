//
//  AuthViewController.swift
//  VK Feed
//
//  Created by Nikolay Gutorov on 8/29/20.
//  Copyright © 2020 Nikolay Gutorov. All rights reserved.
//

import UIKit

class AuthViewController: UIViewController {
    
    private var authService: AuthService!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        
        authService = SceneDelegate.shared().authService
        
    }

    @IBAction func signInButtonPressed(_ sender: Any) {
        authService.wakeUpSession()
    }
    
    private func configureUI() {
        overrideUserInterfaceStyle = .light
    }
}
