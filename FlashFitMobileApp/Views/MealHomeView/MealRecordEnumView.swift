//
//  MealRecordEnumView.swift
//  FlashFitMobileApp
//
//  Created by Gayan Kalinga on 2023-08-25.
//

import Foundation

import SwiftUI

enum MealReocrdFormType: Identifiable, View{
    case new
    case update(MealRecordEntity)

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
            return AddMealView(viewModel: MealRecordViewModel())
        case .update(let mealRecordEntity):
            return AddMealView(viewModel: MealRecordViewModel(mealRecordEntity))
        }
    }
}
