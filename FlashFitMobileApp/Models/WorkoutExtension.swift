//
//  WorkoutExtension.swift
//  FlashFitMobileApp
//
//  Created by Gayan Kalinga on 2023-08-20.
//

import Foundation
import UIKit
import CoreData

extension WorkoutTypeEntity{
    var workoutTypeID: UUID{
        typeID ?? UUID()
    }
    
    var workoutName: String{
        workoutTypeName ?? ""
    }
    
    var imageId: String{
        imageID ?? ""
    }
    
    var caloriesBurned: Double{
        calorieBurnPerMin
    }
    
    var userId: String{
        userEmail ?? ""
    }
    
    var uiImage: UIImage{
        if !imageId.isEmpty, let image = FileManager().retrieveImage(with: imageId){
            return image
        }else{
            return UIImage(systemName: "photo")!
        }
    }
    

        static func getSpecifiedWorkoutTypes(findEmail: String) -> NSFetchRequest<WorkoutTypeEntity> {

            
            let request: NSFetchRequest<WorkoutTypeEntity> = WorkoutTypeEntity.fetchRequest()

              let findDescriptor = NSPredicate(format: "userEmail == %@", findEmail)
              request.predicate = findDescriptor

              // Add a sort descriptor for "calorieBurnPerMin" in ascending order
              let sortDescriptor = NSSortDescriptor(key: "calorieBurnPerMin", ascending: true)
              request.sortDescriptors = [sortDescriptor]

              return request
        }

}

