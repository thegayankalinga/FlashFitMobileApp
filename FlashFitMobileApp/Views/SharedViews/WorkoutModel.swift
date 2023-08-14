//
//  WorkoutModel.swift
//  FlashFitMobileApp
//
//  Created by Gayan Kalinga on 2023-08-14.
//

import Foundation

struct WorkoutModel: Identifiable{
    var id = UUID()
    var calories: Double
    var date: Date
    var duration: Double
    var userId: String
    var weight: Double
    var workoutType: String
}
