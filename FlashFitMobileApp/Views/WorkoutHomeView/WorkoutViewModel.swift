//
//  WorkoutViewModel.swift
//  FlashFitMobileApp
//
//  Created by Gayan Kalinga on 2023-08-14.
//

import Foundation
import CoreData

class WorkoutViewModel : ObservableObject {
    
    @Published var savedWorkouts: [WorkoutEntity] = []
    @Published var savedWeeklyWorkouts: [WorkoutEntity] = []
       
    // fetch data
    func getWorkouts(_ moc: NSManagedObjectContext, userId: String) {
        let request = NSFetchRequest<WorkoutEntity>(entityName: "WorkoutEntity")
        request.predicate = NSPredicate(format: "userID == %@", userId)
        
        do {
            savedWorkouts = try moc.fetch(request)
        } catch let error {
            print("Error fetching. \(error)")
        }
    }
    
    // fetch data for current week
    func getWeeklyWorkouts(_ moc: NSManagedObjectContext, userId: String) {
        let calendar = Calendar.current
        var dateComponents = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date())
        
        // Find the weekday of the current day
        let weekday = calendar.component(.weekday, from: Date())
        
        // From monday to sunday
        let daysToSubtract = (weekday + 5) % 7
        let startOfWeek = calendar.date(byAdding: .day, value: -daysToSubtract, to: Date())!
        let endOfWeek = calendar.date(byAdding: .day, value: 6, to: startOfWeek)!
        
        
        let request = NSFetchRequest<WorkoutEntity>(entityName: "WorkoutEntity")
        request.predicate = NSPredicate(format: "userID == %@ AND date >= %@ AND date <= %@", userId, startOfWeek as NSDate, endOfWeek as NSDate)
        
        do {
            savedWeeklyWorkouts = try moc.fetch(request)
        } catch {
            print("Error fetching.")
        }
    }
    
    // save data
    func addWorkout(moc: NSManagedObjectContext, type: String, duration: String, date: Date, calories:String, weight: String, userId: String) {
        let workoutObj = WorkoutEntity(context: moc)
        workoutObj.userID = userId
        workoutObj.workoutType = type
        workoutObj.duration = Double(duration)!
        workoutObj.date = date
        workoutObj.id = UUID()
        workoutObj.calories = Double(calories)!
        workoutObj.weight = Double(weight)!
        saveData(moc, userId: userId)
    }
    
    func saveData(_ moc: NSManagedObjectContext, userId: String) {
        do {
            try moc.save()
            getWorkouts(moc, userId: userId)
        } catch let error {
            print("Error saving data to DB. \(error)")
        }
    }
    
    // update data
    func updateWorkout(_ moc: NSManagedObjectContext, entity: WorkoutEntity) {
        let id = entity.id
        let userId = entity.userID
        let wType = entity.workoutType ?? ""
        let duration = entity.duration
        let date = entity.date
        let calories = entity.calories

        if let existingWorkout = savedWorkouts.first(where: { $0.id == id }) {
            existingWorkout.id = id
            existingWorkout.userID = userId
            existingWorkout.workoutType = wType
            existingWorkout.duration = duration
            existingWorkout.date = date
            existingWorkout.calories = calories
        }
        saveData(moc, userId: userId!)
        
    }
    
    // remove data
    func deleteWorkout(_ moc: NSManagedObjectContext, indexSet: IndexSet, userId: String) {
        guard let index = indexSet.first else {return}
        
        print("index" , index)
        let workout = savedWorkouts[index]
        moc.delete(workout)
        
        saveData(moc, userId: userId)
    }
    
}
