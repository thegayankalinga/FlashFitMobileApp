//
//  UserRegisterDto.swift
//  FlashFitMobileApp
//
//  Created by Gayan Kalinga on 2023-08-12.
//

import Foundation

public struct UserRegisterDto{
    var email: String
    var name: String
    var password: String
    var genderType: GenderTypeEnum
    var weightInKilos: Double
    var heightInCentiMeter: Double
    var bodyMassIndex: Double
    var healthStatus: HealthStatusEnum
    var createdDate: Date
}
