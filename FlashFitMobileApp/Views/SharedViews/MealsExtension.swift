//
//  MealsExtension.swift
//  FlashFitMobileApp
//
//  Created by Gayan Kalinga on 2023-08-14.
//

import Foundation
import UIKit
import CoreData

extension MealTypeEntity{
    
    var mealTypeID: UUID{
        typeID ?? UUID()
    }
    
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
    
    static func getSpecifiedMealsTypes(findEmail: String) -> NSFetchRequest<MealTypeEntity> {

        
        let request: NSFetchRequest<MealTypeEntity> = MealTypeEntity.fetchRequest()

          let findDescriptor = NSPredicate(format: "userEmail == %@", findEmail)
          request.predicate = findDescriptor

          // Add a sort descriptor for "calorieBurnPerMin" in ascending order
          let sortDescriptor = NSSortDescriptor(key: "caloriesGained", ascending: true)
          request.sortDescriptors = [sortDescriptor]

          return request
    }
    
    static func getMealTypeByID(id: UUID) -> NSFetchRequest<MealTypeEntity> {

        
        let request: NSFetchRequest<MealTypeEntity> = MealTypeEntity.fetchRequest()
        let findDescriptor = NSPredicate(format: "%K == %@", "typeID", id as CVarArg)
        //let findDescriptor = NSPredicate(format: "typeID == %@", id)
        
        request.predicate = findDescriptor
        
        return request
    }
}
