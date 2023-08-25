//
//  UserEntityExtension.swift
//  FlashFitMobileApp
//
//  Created by Gayan Kalinga on 2023-08-25.
//

import Foundation


import Foundation
import UIKit
import CoreData

extension UserModelEntity{
    
    var userEmail: String{
        email ?? ""
    }
    
    var fullName: String{
        name ?? ""
    }
    
    var userID: UUID{
        id ?? UUID()
    }
    
    var userImageID: String{
        userImageId ?? ""
    }
    
    var currentWeight: Double{
        weight
    }
    
    var currentHeight: Double{
        height
    }
    
    var userId: String{
        userEmail
    }
    
    
    var dob: Date{
        dateOfBirth ?? Date.now
    }
    
    var uiImage: UIImage{
        if !userImageID.isEmpty, let image = FileManager().retrieveImage(with: userImageID){
            return image
        }else{
            return UIImage(imageLiteralResourceName: "profile picture")
        }
    }
}
