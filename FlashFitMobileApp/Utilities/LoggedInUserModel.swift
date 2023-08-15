//
//  LoggedInUserModel.swift
//  FlashFitMobileApp
//
//  Created by Gayan Kalinga on 2023-08-15.
//

import Foundation

class LoggedInUserModel: ObservableObject {
    @Published var email: String
    @Published var name: String
    
    init(email: String, name: String) {
        self.email = email
        self.name = name
    }

}
