//
//  MealRecordExtension.swift
//  FlashFitMobileApp
//
//  Created by Gayan Kalinga on 2023-08-20.
//

import Foundation
import UIKit
import CoreData
import SwiftUI

extension MealRecordEntity{
    
    var mealRecordID: UUID{
        recordID ?? UUID()
    }
    
    var recordCreatedDate: Date{
        recordDate ?? Date.now
    }
    
    var mealType: UUID{
        mealTypeID ?? UUID()
    }
    
    var mealTypeNameFromRecord: String{
        mealTypeName ?? ""
    }
    
    var userID: String{
        userEmail ?? ""
    }
    
    var noOfPotionsConsumed: Int{
        Int(noOfPotions)
    }
    
    var caloriesGainTotal: Double{
        totalCaloriesGained
    }
    
    var weightRecorded: Double{
        weightAtRecord
    }
    
    static func getMealTypeObject(moc: NSManagedObjectContext, typeID: UUID) -> MealTypeEntity{
        var mealObj = MealTypeEntity()
        do{
            mealObj  = try moc.fetch(MealTypeEntity.getMealTypeByID(id: typeID)).first ?? MealTypeEntity()
            return mealObj
        }catch{(print(error.localizedDescription))}
        
        return mealObj
    }
    
    static func getSpecifiedMealsRecordByDate(findEmail: String, givenDate: Date) -> NSFetchRequest<MealRecordEntity> {

        let calendar = Calendar.current
        let startDate = calendar.startOfDay(for: givenDate)
        let endDate = calendar.date(byAdding: .day, value: 1, to: startDate)!
        let dateDescription = NSPredicate(format: "recordDate >= %@ AND date < %@", argumentArray: [startDate, endDate])

    
        let request: NSFetchRequest<MealRecordEntity> = MealRecordEntity.fetchRequest()

        let findDescriptor = NSPredicate(format: "userEmail == %@", findEmail)
        
        
          request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [findDescriptor, dateDescription])

          // Add a sort descriptor for "calorieBurnPerMin" in ascending order
          let sortDescriptor = NSSortDescriptor(key: "recordDate", ascending: true)
          request.sortDescriptors = [sortDescriptor]

          return request
    }
    
    static func getSpecifiedMealsRecord(findEmail: String) -> NSFetchRequest<MealRecordEntity> {

        
        let request: NSFetchRequest<MealRecordEntity> = MealRecordEntity.fetchRequest()

        let findDescriptor = NSPredicate(format: "userEmail == %@", findEmail)
        
          request.predicate = findDescriptor

          // Add a sort descriptor for "calorieBurnPerMin" in ascending order
          let sortDescriptor = NSSortDescriptor(key: "recordDate", ascending: true)
          request.sortDescriptors = [sortDescriptor]

          return request
    }
}
