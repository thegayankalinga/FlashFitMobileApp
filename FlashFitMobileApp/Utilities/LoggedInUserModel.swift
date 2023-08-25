//
//  LoggedInUserModel.swift
//  FlashFitMobileApp
//
//  Created by Gayan Kalinga on 2023-08-15.
//

import Foundation

class LoggedInUserModel: ObservableObject {
    @Published var email: String?
    @Published var name: String?
    @Published var height: Double?
    @Published var weight: Double?
    
    init(email: String, name: String, height: Double, weight: Double) {
        self.email = email
        self.name = name
        self.height = height
        self.weight = weight
        
    }
    
    init(){
        
    }

}
