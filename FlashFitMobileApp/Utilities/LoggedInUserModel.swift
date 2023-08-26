//
//  LoggedInUserModel.swift
//  FlashFitMobileApp
//
//  Created by Gayan Kalinga on 2023-08-15.
//

import Foundation
import UIKit

class LoggedInUserModel: ObservableObject {
    @Published var email: String?
    @Published var name: String?
    @Published var height: Double?
    @Published var weight: Double?
    @Published var userImage: UIImage?
    
    init(email: String, name: String, height: Double, weight: Double, image: UIImage) {
        self.email = email
        self.name = name
        self.height = height
        self.weight = weight
        self.userImage = image
    }
    
    init(){
        
    }

}
