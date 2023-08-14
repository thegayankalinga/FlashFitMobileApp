//
//  WorkoutViewModel.swift
//  FlashFitMobileApp
//
//  Created by Gayan Kalinga on 2023-08-14.
//

import Foundation
import CoreData

class WorkoutViewModel : ObservableObject {
    
    //let container: NSPersistentContainer
    @Published var savedWorkouts: [WorkoutEntity] = []
    
    
    // fetch data
    func getWorkouts(_ moc: NSManagedObjectContext) {
        let request = NSFetchRequest<WorkoutEntity>(entityName: "WorkoutEntity")
        
        do {
            savedWorkouts = try moc.fetch(request)
        } catch let error {
            print("Error fetching. \(error)")
        }
    }
    
    // save data
    func addWorkout(moc: NSManagedObjectContext, type: String, duration: String, date: Date, calories:String, weight: String) {
        let workoutObj = WorkoutEntity(context: moc)
        workoutObj.workoutType = type
        workoutObj.duration = Double(duration)!
        workoutObj.date = date
        workoutObj.id = UUID()
        workoutObj.calories = Double(calories)!
        workoutObj.weight = Double(weight)!
        saveData(moc)
    }
    
    func saveData(_ moc: NSManagedObjectContext) {
        do {
            try moc.save()
            getWorkouts(moc)
        } catch let error {
            print("Error saving data to DB. \(error)")
        }
    }
    
    // update data
    func updateWorkout(entity: WorkoutEntity) {
        let id = entity.id
        let wType = entity.workoutType ?? ""
        let duration = entity.duration
        let date = entity.date

        if let existingWorkout = savedWorkouts.first(where: { $0.id == id }) {
            existingWorkout.id = id
            existingWorkout.workoutType = wType
            existingWorkout.duration = duration
            existingWorkout.date = date
        }
    }
    
    // remove data
    func deleteWorkout(_ moc: NSManagedObjectContext, indexSet: IndexSet) {
        guard let index = indexSet.first else {return}
        
        print("index" , index)
        let workout = savedWorkouts[index]
        moc.delete(workout)
        
        saveData(moc)
    }
    
}
