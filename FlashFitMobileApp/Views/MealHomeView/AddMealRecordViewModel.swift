//
//  AddMealRecordViewModel.swift
//  FlashFitMobileApp
//
//  Created by Gayan Kalinga on 2023-08-25.
//

import Foundation
import SwiftUI
import CoreData


class AddMealRecordViewModel: ObservableObject{
    
    //MARK: Form Variable
    @Published var noOfPotions: Int = 1
    @Published var date: Date = Date.now
    @Published var calories: String = ""
    @Published var weight: String = ""
    @Published var addMore: Bool = false
    var userEmail: String = ""
    @Published var myMealRecords: [MealRecordEntity] = []
    @Published var selectedMealType: MealTypeEntity?
    var recordID: UUID?
    
    var id: UUID?
    var updating: Bool {id != nil}
    
    init(){
        
    }

    init(_ mealRecordEntity: MealRecordEntity){
        recordID = mealRecordEntity.mealRecordID
        id = recordID
        selectedMealType =  mealRecordEntity.mealObject
        noOfPotions = mealRecordEntity.noOfPotionsConsumed
        date = mealRecordEntity.recordCreatedDate
        calories = String(mealRecordEntity.caloriesGainTotal)
        weight = String(mealRecordEntity.weightRecorded)
        userEmail = mealRecordEntity.userID
        
    }
    
    //MARK: Validation Computed Properties
    var incomplete: Bool{
        isValidMealType() ||
        isValidWeigth() 
    }
    
    var weightPrompt: String{
        if isValidWeigth(){
            return ""
        }else{
            return "Please Enter valid value for weight"
        }
    }
    
    
    //MARK: Validation Functions
    func isValidWeigth() -> Bool{
        (Double(weight) ?? 0.00) > 0
    }
    
    func isValidMealType() -> Bool{
        selectedMealType == nil
    }
}
