//
//  WorkoutRecordExtension.swift
//  FlashFitMobileApp
//
//  Created by Gayan Kalinga on 2023-08-25.
//

import Foundation
import Foundation
import UIKit
import CoreData
import SwiftUI

extension WorkoutEntity{
    var workoutRecordID: UUID{
        id ?? UUID()
    }
    
    var workoutTypeID: String{
        workoutType ?? ""
    }
    
    var workoutTypeNameFromRecord: String{
        workoutTypeName ?? ""
    }
    
    var weightAtWorkout: Double{
        weight
    }
    
    var userEmailID: String{
        userID ?? ""
    }
    
    var workoutDuration: Double{
        duration
    }
    
    var workedoutDate: Date{
        date ?? Date.now
    }
    
    var totalCalorieBurned: Double{
        calories
    }
    
    
    
    static func getSpecifiedWorkoutRecordByDate(findEmail: String, givenDate: Date) -> NSFetchRequest<WorkoutEntity> {

        let calendar = Calendar.current
        let startDate = calendar.startOfDay(for: givenDate)
        let endDate = calendar.date(byAdding: .day, value: 1, to: startDate)!
        let dateDescription = NSPredicate(format: "date >= %@ AND date < %@", argumentArray: [startDate, endDate])

    
        let request: NSFetchRequest<WorkoutEntity> = WorkoutEntity.fetchRequest()

        let findDescriptor = NSPredicate(format: "userID == %@", findEmail)
        
        
          request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [findDescriptor, dateDescription])

          // Add a sort descriptor for "calorieBurnPerMin" in ascending order
          let sortDescriptor = NSSortDescriptor(key: "date", ascending: true)
          request.sortDescriptors = [sortDescriptor]

          return request
    }
    
    static func getSpecifiedWorkoutRecord(findEmail: String) -> NSFetchRequest<WorkoutEntity> {

        
        let request: NSFetchRequest<WorkoutEntity> = WorkoutEntity.fetchRequest()

        let findDescriptor = NSPredicate(format: "userID == %@", findEmail)
        
          request.predicate = findDescriptor

          // Add a sort descriptor for "calorieBurnPerMin" in ascending order
          let sortDescriptor = NSSortDescriptor(key: "date", ascending: true)
          request.sortDescriptors = [sortDescriptor]

          return request
    }
}
