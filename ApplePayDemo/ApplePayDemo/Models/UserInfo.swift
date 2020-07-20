//
//  UserInfo.swift
//  ApplePayDemo
//
//  Created by Eunyeong Kim on 2020/07/20.
//  Copyright © 2020 Eunyeong Kim. All rights reserved.
//

import Foundation

struct UserInfo {
    let email = "unnnyong@applePay.com"
    let name = "Eunyeong"
    let phoneNumber = "01011112222"
    let address1 = "서울시 행복하구"

    static let shared = UserInfo()
}
