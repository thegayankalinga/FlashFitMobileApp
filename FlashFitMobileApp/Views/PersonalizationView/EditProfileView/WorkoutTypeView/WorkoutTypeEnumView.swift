//
//  WorkoutTypeEnumView.swift
//  FlashFitMobileApp
//
//  Created by Gayan Kalinga on 2023-08-16.
//

import SwiftUI

enum WorkoutFormType: Identifiable, View{
    case new(UIImage)
    case update(MealTypeEntity)
    
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
            return AddMealTypeView(viewModel: AddMealTypeViewModel(uiImage))
        case .update(let mealTypeEntity):
            return AddMealTypeView(viewModel: AddMealTypeViewModel(mealTypeEntity))
        }
    }
}
