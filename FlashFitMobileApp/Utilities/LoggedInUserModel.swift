//
//  LoggedInUserModel.swift
//  FlashFitMobileApp
//
//  Created by Gayan Kalinga on 2023-08-15.
//

import Foundation

class LoggedInUserModel: ObservableObject {
    @Published var user: UserModel
    
    init(user: UserModel) {
        self.user = user
    }
}
