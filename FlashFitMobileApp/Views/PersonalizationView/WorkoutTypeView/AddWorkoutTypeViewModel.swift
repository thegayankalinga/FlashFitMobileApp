//
//  AddWorkoutTypeViewModel.swift
//  FlashFitMobileApp
//
//  Created by Gayan Kalinga on 2023-08-16.
//

import Foundation
import SwiftUI
import CoreData

class AddWorkoutTypeViewModel: ObservableObject{
    
    @Published var workoutName = ""
    @Published var caloriesBurnedPerMin = ""
    @Published var workoutImage: UIImage
    @Published var userEmail = ""
    @Published var isAddMoreChecked = false
    @Published var myWorkoutTypes: [WorkoutTypeEntity] = []
    @Published var showAddWorkoutSheet = false
    
    var id: String?
    var updating: Bool{id != nil}
    
    init(_ uiImage: UIImage){
        self.workoutImage = uiImage
    }
    
    init(_ workoutTypeEntity: WorkoutTypeEntity){
        workoutName = workoutTypeEntity.workoutName
        id = workoutTypeEntity.imageId
        workoutImage = workoutTypeEntity.uiImage
        caloriesBurnedPerMin = String(workoutTypeEntity.caloriesBurned)
        userEmail = workoutTypeEntity.userId
    }
    
    //MARK: Validation Computed Properties
    var incomplete: Bool{
        workoutName.isEmpty ||
        workoutImage == UIImage(systemName: "photo")! ||
        caloriesBurnedPerMin.isEmpty
    }
    
    var workoutNamePrompt: String{
        if isValidWorkoutName(){
            return ""
        }else{
            return "Workout should have a valid name"
        }
    }
    
    var caloriesBurnedPrompt: String{
        if isValidCaloriesBurned(){
            return ""
        }else{
            return "Please enter vallid amount for caloreis burned per minute"
        }
    }
    
    
    //MARK: Validation Functions
    func isValidWorkoutName() -> Bool{
        workoutName.count > 2
    }
    
    func isValidCaloriesBurned() -> Bool{
        (Double(caloriesBurnedPerMin) ?? 0.00) > 0
    }
    
    
    func getAllWorkoutTypes(email: String, moc: NSManagedObjectContext){
        let fetchRequest: NSFetchRequest<WorkoutTypeEntity> = WorkoutTypeEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "userEmail == %@", email)
        
        do {
           
            myWorkoutTypes = try moc.fetch(fetchRequest)
            
        } catch {
            print("Error checking for value existence: \(error)")
         
        }
    }
}
