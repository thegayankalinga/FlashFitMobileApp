//
//  WorkoutTypeEnumView.swift
//  FlashFitMobileApp
//
//  Created by Gayan Kalinga on 2023-08-16.
//

import SwiftUI

enum WorkoutFormType: Identifiable, View{
    case new(UIImage)
<<<<<<< HEAD
    case update(WorkoutTypeEntity)
=======
    case update(MealTypeEntity)
>>>>>>> weight-predict-model
    
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
        case .new(let uiImage):
<<<<<<< HEAD
            return AddWorkoutTypeView(viewModel: AddWorkoutTypeViewModel(uiImage))
        case .update(let workoutTypeEntity):
            return AddWorkoutTypeView(viewModel: AddWorkoutTypeViewModel(workoutTypeEntity))
=======
            return AddMealTypeView(viewModel: AddMealTypeViewModel(uiImage))
        case .update(let mealTypeEntity):
            return AddMealTypeView(viewModel: AddMealTypeViewModel(mealTypeEntity))
>>>>>>> weight-predict-model
        }
    }
}
