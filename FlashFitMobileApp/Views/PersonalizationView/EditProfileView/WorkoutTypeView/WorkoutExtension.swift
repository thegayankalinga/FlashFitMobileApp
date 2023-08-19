//
//  WorkoutExtension.swift
//  FlashFitMobileApp
//
//  Created by Gayan Kalinga on 2023-08-16.
//

import Foundation
import UIKit

extension WorkoutTypeEntity{
<<<<<<< HEAD
    var workoutName: String{
=======
    var mealType: String{
>>>>>>> weight-predict-model
        workoutTypeName ?? ""
    }
    
    var imageId: String{
        imageID ?? ""
    }
    
<<<<<<< HEAD
    var caloriesBurned: Double{
=======
    var caloriesGain: Double{
>>>>>>> weight-predict-model
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
}
