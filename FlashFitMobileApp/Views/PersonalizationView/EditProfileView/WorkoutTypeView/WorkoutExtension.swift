//
//  WorkoutExtension.swift
//  FlashFitMobileApp
//
//  Created by Gayan Kalinga on 2023-08-16.
//

import Foundation
import UIKit

extension WorkoutTypeEntity{
    var mealType: String{
        workoutTypeName ?? ""
    }
    
    var imageId: String{
        imageID ?? ""
    }
    
    var caloriesGain: Double{
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
