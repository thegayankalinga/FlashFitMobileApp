//
//  UserUpdateDto.swift
//  FlashFitMobileApp
//
//  Created by Gayan Kalinga on 2023-08-20.
//

import Foundation

public struct UserUpdateDto{
    var name: String
    var genderType: GenderTypeEnum
    var weightInKilos: Double
    var heightInCentiMeter: Double
    var bodyMassIndex: Double
    var healthStatus: HealthStatusEnum
    var createdDate: Date
}
