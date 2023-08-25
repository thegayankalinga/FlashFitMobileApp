//
//  AddMealTypeViewModel.swift
//  FlashFitMobileApp
//
//  Created by Gayan Kalinga on 2023-08-14.
//

import Foundation
import SwiftUI
import CoreData

class AddMealTypeViewModel: ObservableObject{
    @Published var mealName = ""
    @Published var caloriesGainPerPotion = ""
    @Published var mealImage: UIImage
    @Published var userEmail = ""
    @Published var isAddMoreChecked = false
    @Published var showAddMealSheet = false
    
    @Published var myMealTypes: [MealTypeEntity] = []
    
    var id: String?
    
    var updating: Bool {id != nil}
    
    init(_ uiImage: UIImage){
        self.mealImage = uiImage
    }
    
    init(_ mealTypeEntity: MealTypeEntity){
        mealName = mealTypeEntity.mealType
        id = mealTypeEntity.imageId
        mealImage = mealTypeEntity.uiImage
        caloriesGainPerPotion = String(mealTypeEntity.caloriesGained)
        userEmail = mealTypeEntity.userId
    }
    
    var incomplete: Bool{
        mealName.isEmpty ||
        mealImage == UIImage(systemName: "photo")! ||
        caloriesGainPerPotion.isEmpty
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
    
    
    func getAllMealTypes(email: String, moc: NSManagedObjectContext){
        let fetchRequest: NSFetchRequest<MealTypeEntity> = MealTypeEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "userEmail == %@", email)
        
        do {
           
            myMealTypes = try moc.fetch(fetchRequest)
            
        } catch {
            print("Error checking for value existence: \(error)")
         
        }
    }
    
   
}
