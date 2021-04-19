//
//  UserResponse.swift
//  VK Feed
//
//  Created by Nikolay Gutorov on 4/18/21.
//  Copyright © 2021 Nikolay Gutorov. All rights reserved.
//

import Foundation

struct UserResponseWrapped: Decodable {
    let response: [UserResponse]
}

struct UserResponse : Decodable {
    let photo100: String?
}
