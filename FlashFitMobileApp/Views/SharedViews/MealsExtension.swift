//
//  MealsExtension.swift
//  FlashFitMobileApp
//
//  Created by Gayan Kalinga on 2023-08-14.
//

import Foundation

extension MealTypeEntity{
    var mealType: String{
        mealTypeName ?? ""
    }
    
    var imageId: String{
        imageID ?? ""
    }
    
    var caloriesGain: Double{
        caloriesGained
    }
}
