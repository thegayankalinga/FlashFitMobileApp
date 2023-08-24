//
//  MealViewModel.swift
//  FlashFitMobileApp
//
//  Created by user233619 on 8/24/23.
//

import Foundation
import CoreData

class MealViewModel : ObservableObject {
    
    @Published var savedMeals: [MealRecordEntity] = []
    @Published var savedWeeklyMeals: [MealRecordEntity] = []
    @Published var savedDailyMeals: [MealRecordEntity] = []
       
    // fetch data
    func getMeals(_ moc: NSManagedObjectContext, userId: String) {
        let request = NSFetchRequest<MealRecordEntity>(entityName: "MealRecordEntity")
        request.predicate = NSPredicate(format: "userEmail == %@", userId)
        
        do {
            savedMeals = try moc.fetch(request)
            savedMeals.sort(by: { $0.recordDate! > $1.recordDate! })
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
            savedWeeklyMeals = try moc.fetch(request)
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
    /*func getWorkoutTimeByDay(_ moc: NSManagedObjectContext, userId: String, date: Date) -> Double {
        let request = NSFetchRequest<MealRecordEntity>(entityName: "MealRecordEntity")
        
        let calendar = Calendar.current
        let startDate = calendar.startOfDay(for: date)
        let endDate = calendar.date(byAdding: .day, value: 1, to: startDate)!
        
        request.predicate = NSPredicate(format: "userEmail == %@ AND recordDate >= %@ AND recordDate < %@", userId, startDate as NSDate, endDate as NSDate)
        
        var total: Double = 0.0
        
        do {
            let results  = try moc.fetch(request)
            
            if !results.isEmpty {
                for workout in results {
                    total = total + workout.duration
                }
            }
        } catch let error {
            print("Error fetching. \(error)")
        }
        return total
    }*/
    
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

        if let existingMeal = savedMeals.first(where: { $0.recordID == id }) {
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
        let meal = savedMeals[index]
        moc.delete(meal)
        
        saveData(moc, userId: userId)
    }
}
