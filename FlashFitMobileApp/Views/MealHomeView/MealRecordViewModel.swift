//
//  AddMealRecordViewModel.swift
//  FlashFitMobileApp
//
//  Created by Gayan Kalinga on 2023-08-25.
//

import Foundation
import SwiftUI
import CoreData


class MealRecordViewModel: ObservableObject{
    
    //MARK: Binding Variables
    @Published var noOfPotions: Int = 1
    @Published var date: Date = Date.now
    @Published var totalCalories = ""
    @Published var weight: String = ""
    
    @Published var selectedMealType: MealTypeEntity?
    @Published var mealTypeID: UUID = UUID()
    @Published var isAddMoreChecked = false
    @Published var myMealRecords: [MealRecordEntity] = []
    @Published var savedWeeklyMeals: [MealRecordEntity] = []
    @Published var myMealTypes: [MealTypeEntity] = []
    @Published var savedDailyMeals: [MealRecordEntity] = []
    
    //MARK: Stored Variables
    var mealTypeName: String?
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
        mealTypeName = mealRecordEntity.mealTypeNameFromRecord
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
    
    func getMealType(_ moc: NSManagedObjectContext, mealID: UUID) -> MealTypeEntity?{
        var mealObj: MealTypeEntity?
        do{
            mealObj  = MealRecordEntity.getMealTypeObject(moc: moc, typeID: mealID)
            print(mealObj?.mealType ?? "value not found")
//            print(mealObj.)
            return mealObj
        }

    }
    // fetch data
    func getMeals(_ moc: NSManagedObjectContext, userId: String) {
        let request = NSFetchRequest<MealRecordEntity>(entityName: "MealRecordEntity")
        request.predicate = NSPredicate(format: "userEmail == %@", userId)
        
        do {
            myMealRecords = try moc.fetch(request)
            myMealRecords.sort(by: { $0.recordDate! > $1.recordDate! })
        } catch let error {
            print("Error fetching. \(error)")
        }
    }
    
    // fetch data for current week
    func getWeeklyMeals(_ moc: NSManagedObjectContext, userId: String) {
        let calendar = Calendar.current
        
        // Find the weekday of the current day
        let weekday = calendar.component(.weekday, from: Date())
        
        // From monday to sunday
        let daysToSubtract = (weekday + 5) % 7
        let startOfWeek = calendar.date(byAdding: .day, value: -daysToSubtract, to: Date())!
        let endOfWeek = calendar.date(byAdding: .day, value: 6, to: startOfWeek)!
        
        
        let request = NSFetchRequest<MealRecordEntity>(entityName: "MealRecordEntity")
        request.predicate = NSPredicate(format: "userEmail == %@ AND recordDate >= %@ AND recordDate <= %@", userId, startOfWeek as NSDate, endOfWeek as NSDate)
        
        do {
            savedWeeklyMeals = try moc.fetch(request)
        } catch {
            print("Error fetching.")
        }
    }
    
    // fetch data for current week
    func getDailyMeals(_ moc: NSManagedObjectContext, userId: String, date: Date) {
        let request = NSFetchRequest<MealRecordEntity>(entityName: "MealRecordEntity")
        
        let calendar = Calendar.current
        let startDate = calendar.startOfDay(for: date)
        let endDate = calendar.date(byAdding: .day, value: 1, to: startDate)!
        
        request.predicate = NSPredicate(format: "userEmail == %@ AND recordDate >= %@ AND recordDate < %@", userId, startDate as NSDate, endDate as NSDate)
        
        do {
            savedDailyMeals = try moc.fetch(request)
        } catch {
            print("Error fetching.")
        }
    }
    
    // fetch total calories burnt in a given date
    func getCaloriesForByDay(_ moc: NSManagedObjectContext, userId: String, date: Date) -> Double {
        let request = NSFetchRequest<MealRecordEntity>(entityName: "MealRecordEntity")
        
        let calendar = Calendar.current
        let startDate = calendar.startOfDay(for: date)
        let endDate = calendar.date(byAdding: .day, value: 1, to: startDate)!
        
        request.predicate = NSPredicate(format: "userEmail == %@ AND recordDate >= %@ AND recordDate < %@", userId, startDate as NSDate, endDate as NSDate)
        
        var total: Double = 0.0
        
        do {
            let results  = try moc.fetch(request)
            
            if !results.isEmpty {
                for meal in results {
                    total = total + meal.totalCaloriesGained
                }
            }
        } catch let error {
            print("Error fetching. \(error)")
        }
        return total
    }
    
    // fetch total time in a given date
    func getTotalMealsByDay(_ moc: NSManagedObjectContext, userId: String, date: Date) -> Int {
        let request = NSFetchRequest<MealRecordEntity>(entityName: "MealRecordEntity")
        
        let calendar = Calendar.current
        let startDate = calendar.startOfDay(for: date)
        let endDate = calendar.date(byAdding: .day, value: 1, to: startDate)!
        
        request.predicate = NSPredicate(format: "userEmail == %@ AND recordDate >= %@ AND recordDate < %@", userId, startDate as NSDate, endDate as NSDate)
        
        var total: Int = 0
        
        do {
            let results  = try moc.fetch(request)
            
            if !results.isEmpty {
                total = results.count
            }
        } catch let error {
            print("Error fetching. \(error)")
        }
        return total
    }
    
    // save data
    func addMeal(moc: NSManagedObjectContext, type: UUID, potions: Int16, date: Date, calories:String, weight: String, userId: String) {
        let meal = MealRecordEntity(context: moc)
        meal.userEmail = userId
        meal.mealTypeID = type
        meal.noOfPotions = potions
        meal.recordDate = date
        meal.recordID = UUID()
        meal.totalCaloriesGained = Double(calories)!
        meal.weightAtRecord = Double(weight)!
        saveData(moc, userId: userId)
    }
    
    func saveData(_ moc: NSManagedObjectContext, userId: String) {
        do {
            try moc.save()
            getMeals(moc, userId: userId)
        } catch let error {
            print("Error saving meal data to DB. \(error)")
        }
    }
    
    // update data
    func updateMeal(_ moc: NSManagedObjectContext, entity: MealRecordEntity) {
        let id = entity.recordID
        let userId = entity.userEmail
        let mType = entity.mealTypeID
        let noOfPotions = entity.noOfPotions
        let date = entity.recordDate
        let calories = entity.totalCaloriesGained
        let weight = entity.weightAtRecord

        if let existingMeal = myMealRecords.first(where: { $0.recordID == id }) {
            existingMeal.recordID = id
            existingMeal.userEmail = userId
            existingMeal.mealTypeID = mType
            existingMeal.noOfPotions = noOfPotions
            existingMeal.recordDate = date
            existingMeal.totalCaloriesGained = calories
            existingMeal.weightAtRecord = weight
        }
        saveData(moc, userId: userId!)
    }
    
    // remove data
    func deleteMeal(_ moc: NSManagedObjectContext, indexSet: IndexSet, userId: String) {
        guard let index = indexSet.first else {return}
        
        print("index" , index)
        let meal = myMealRecords[index]
        moc.delete(meal)
        
        saveData(moc, userId: userId)
    }
}
