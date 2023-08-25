//
//  WorkoutRecordEnumView.swift
//  FlashFitMobileApp
//
//  Created by Gayan Kalinga on 2023-08-25.
//

import Foundation

import SwiftUI

enum WorkoutReocrdFormType: Identifiable, View{
    case new
    case update(WorkoutEntity)

    var id: String{
        switch self{
        case .new:
            return "new"
        case .update:
            return "update"
        }
    }

    var body: some View{
        switch self{
        case .new:
            return AddWorkoutView(viewModel: WorkoutViewModel())
        case .update(let workoutReocrdEntity):
            return AddWorkoutView(viewModel: WorkoutViewModel(workoutReocrdEntity))
        }
    }
}
