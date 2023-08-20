//
//  MealsExtension.swift
//  FlashFitMobileApp
//
//  Created by Gayan Kalinga on 2023-08-14.
//

import Foundation
import UIKit

extension MealTypeEntity{
    var mealType: String{
        mealTypeName ?? ""
    }
    
    var imageId: String{
        imageID ?? ""
    }
    
    var caloriesGain: Double{
        caloriesGained
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