//
//  UserModel.swift
//  FlashFitMobileApp
//
//  Created by Gayan Kalinga on 2023-08-11.
//

import Foundation
import CoreData

struct UserModel: Identifiable{
    var id = UUID()
    
    var email: String
    var name: String
    var passwordSalt: String
    var passwordHash: String
    var genderType: GenderTypeEnum
    var weightInKilos: Double
    var heightInCentiMeter: Double
    var bodyMassIndex: Double
    var healthStatus: HealthStatusEnum
    var createdDate: Date
    
    
    
    
}



