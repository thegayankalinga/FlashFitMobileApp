//
//  LogginError.swift
//  FlashFitMobileApp
//
//  Created by Gayan Kalinga on 2023-08-13.
//

import Foundation
enum LoginError: Error {
    case invalidCredentials
    case invalidUser
}

enum RegistrationError: Error{
    case creationFailed
    case userExist
}

enum UpdateError: Error{
    case UserNotFound
    case UpdateFailed
}
