
//
//  UserModel.swift
//  FlashFitMobileApp
//
//  Created by Gayan Kalinga on 2023-08-11.
//

import Foundation
import CoreData

class UserModel: Identifiable, ObservableObject{
    var id = UUID()
    
    @Published var email: String
    @Published var name: String
    @Published var passwordSalt: String
    @Published var passwordHash: String
    @Published var genderType: GenderTypeEnum
    @Published var weightInKilos: Double
    @Published var heightInCentiMeter: Double
    @Published var bodyMassIndex: Double
    @Published var healthStatus: HealthStatusEnum
    @Published var createdDate: Date
    
    init(id: UUID = UUID(), email: String, name: String, passwordSalt: String, passwordHash: String, genderType: GenderTypeEnum, weightInKilos: Double, heightInCentiMeter: Double, bodyMassIndex: Double, healthStatus: HealthStatusEnum, createdDate: Date) {
        self.id = id
        self.email = email
        self.name = name
        self.passwordSalt = passwordSalt
        self.passwordHash = passwordHash
        self.genderType = genderType
        self.weightInKilos = weightInKilos
        self.heightInCentiMeter = heightInCentiMeter
        self.bodyMassIndex = bodyMassIndex
        self.healthStatus = healthStatus
        self.createdDate = createdDate
    }
    
    
}




