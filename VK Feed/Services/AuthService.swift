//
//  AuthService.swift
//  VK Feed
//
//  Created by Nikolay Gutorov on 9/24/20.
//  Copyright © 2020 Nikolay Gutorov. All rights reserved.
//

import Foundation
import VK_ios_sdk

protocol AuthServiceDelegate: class {
    func authServiceShouldShow(viewController: UIViewController)
    func authServiceSignIn()
    func authServiceSignInFail()
}

class AuthService: NSObject, VKSdkDelegate, VKSdkUIDelegate {
    
    private let appId = API.appId
    private let vkSdk: VKSdk
    
    weak var delegate: AuthServiceDelegate?
    
    var token: String? {
        return VKSdk.accessToken()?.accessToken
    }
    
    var userId: String? {
        return VKSdk.accessToken()?.userId
    }
    
    override init() {
        vkSdk = VKSdk.initialize(withAppId: appId)
        
        super.init()
        print("*** Initializing VKSdk...")
        
        vkSdk.register(self)
        vkSdk.uiDelegate = self
    }
    
    func wakeUpSession() {
        let scope = ["wall", "friends"]
        VKSdk.wakeUpSession(scope) { [delegate] (state, error) in
            switch state {
            case .initialized:
                print("*** Session initialized!")
                VKSdk.authorize(scope)
            case .authorized:
                print("*** User authorized!")
                delegate?.authServiceSignIn()
            default:
                //fatalError(error?.localizedDescription ?? "Authorization error!")
                delegate?.authServiceSignInFail()
            }
        }
    }
    
    func vkSdkAccessAuthorizationFinished(with result: VKAuthorizationResult!) {
        print(#function)
        
        if result.token != nil {
            delegate?.authServiceSignIn()
        }
    }
    
    func vkSdkUserAuthorizationFailed() {
        print(#function)
        delegate?.authServiceSignInFail()
    }
    
    func vkSdkShouldPresent(_ controller: UIViewController!) {
        print(#function)
        delegate?.authServiceShouldShow(viewController: controller)
    }
    
    func vkSdkNeedCaptchaEnter(_ captchaError: VKError!) {
        print(#function)
    }
}
