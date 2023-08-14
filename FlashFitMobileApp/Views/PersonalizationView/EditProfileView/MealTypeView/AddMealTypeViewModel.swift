//
//  AddMealTypeViewModel.swift
//  FlashFitMobileApp
//
//  Created by Gayan Kalinga on 2023-08-14.
//

import Foundation
import SwiftUI

class AddMealTypeViewModel: ObservableObject{
    @Published var mealName = ""
    @Published var caloriesGainPerPotion = ""
    @Published var mealImage: UIImage
    @Published var isAddMoreChecked = false
    
    var id: String?
    
    var updating: Bool {id != nil}
    
    init(_ uiImage: UIImage){
        self.mealImage = uiImage
    }
    
    init(_ myImage: MealTypeEntity){
        mealName = myImage.mealType
        id = myImage.imageId
        mealImage = UIImage(systemName: "photo")!
    }
    
    var incomplete: Bool{
        mealName.isEmpty || mealImage == UIImage(systemName: "photo")!
    }
    
    var mealTypeNamePrompt: String{
        if isValidMealTypeName() {
            return ""
        }else{
            return "Meal Type should have a valid name"
        }
    }
    
    var caloriesGainedPrompot: String{
        if isValidCaloriesGained(){
            return ""
        }else{
            return "Please enter valid amount for calories gained"
        }
    }
    
    
    func isValidMealTypeName() -> Bool{
        mealName.count > 2
    }
    
    func isValidCaloriesGained() -> Bool{
        (Double(caloriesGainPerPotion) ?? 0.00) > 0
    }
}
