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
    
    //MARK: Binding Variables
    @Published var noOfPotions: Int = 1
    @Published var date: Date = Date.now
    @Published var totalCalories = ""
    @Published var weight: String = ""
    @Published var selectedMealType: MealTypeEntity?
    @Published var mealTypeID: UUID = UUID()
    @Published var isAddMoreChecked = false
    @Published var myMealRecords: [MealRecordEntity] = []
    @Published var myMealTypes: [MealTypeEntity] = []
    
    //MARK: Stored Variables
    var recordID: UUID?
    var id: UUID?
    var updating: Bool {id != nil}
    var userEmail: String = ""
    
    //MARK: Initializers
    init(){
        
    }

    init(_ mealRecordEntity: MealRecordEntity){
        print(mealRecordEntity.mealRecordID)
        recordID = mealRecordEntity.mealRecordID
        id = recordID
        mealTypeID = mealRecordEntity.mealType
        noOfPotions = mealRecordEntity.noOfPotionsConsumed
        date = mealRecordEntity.recordCreatedDate
        totalCalories = String(format: "%.2f",mealRecordEntity.caloriesGainTotal)
        weight = String(format: "%.2f",mealRecordEntity.weightRecorded)
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
        selectedMealType != nil
    }
    
    
    //MARK: Other Functions
    func calTotalCalories(moc: NSManagedObjectContext) {
       
        let valueZero = self.selectedMealType?.caloriesGain ?? 0.00
//        let valueOne: Double = Double(calories) ?? 0.00
        let valueTwo = Double(self.noOfPotions)
        
        totalCalories = String(valueZero * valueTwo)
    }
    
    //MARK: Database functions
    func getAllMealRecordsByEmail(email: String, moc: NSManagedObjectContext){
        let fetchRequest: NSFetchRequest<MealRecordEntity> = MealRecordEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "userEmail == %@", email)
        
        do {
           
            myMealRecords = try moc.fetch(fetchRequest)
            
        } catch {
            print("Error checking for value existence: \(error)")
         
        }
    }
    
    func getMealTypeByUUID(moc: NSManagedObjectContext){
        let id = self.mealTypeID
        let fetchRequest: NSFetchRequest<MealTypeEntity> = MealTypeEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "typeID == %@", id as CVarArg)
        
        do {
           
            selectedMealType = try moc.fetch(fetchRequest).first
            
        } catch {
            print("Error checking for value existence: \(error)")
         
        }
    }
    
    func getMealTypeBySpecificID(id: UUID, moc: NSManagedObjectContext){
       
        let fetchRequest: NSFetchRequest<MealTypeEntity> = MealTypeEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "typeID == %@", id as CVarArg)
        
        do {
           
            selectedMealType = try moc.fetch(fetchRequest).first
            
        } catch {
            print("Error checking for value existence: \(error)")
         
        }
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
