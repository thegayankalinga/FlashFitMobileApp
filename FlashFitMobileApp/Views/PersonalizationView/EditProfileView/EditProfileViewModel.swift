//
//  EditProfileViewModel.swift
//  FlashFitMobileApp
//
//  Created by Gayan Kalinga on 2023-08-20.
//

import Foundation
import CoreData
import SwiftUI


class EditProfileViewModel: ObservableObject{
    
    @Environment(\.managedObjectContext) var moc
//    @EnvironmentObject var loggedInUser: LoggedInUserModel
    
    @Published var email = ""
    @Published  var name = ""
    @Published  var dob = Date()
    @Published  var height = ""
    @Published  var weight = ""
    @Published  var selectedGender = GenderTypeEnum.Male
    

  
    //UserService.getUserData(email: email, moc: moc)
    public func update(email: String, moc: NSManagedObjectContext)throws -> Int{

        
        if(UserService.valueExists(email: email, moc: moc)){
            
            let kg: Double = Double(weight) ?? 0.0
            let cm: Double = Double(height) ?? 0.0
            let bmi: Double = UserService.calculateBmi(weight: kg, height: cm)
            let hs: HealthStatusEnum = UserService.getHealthStatus(bodyMassIndexValue: bmi)
            
            //Saving the User
            do{
                if let user = try UserService.getUserEntityByEmail(email: email, moc: moc){
                    user.dateOfBirth = dob
                    user.name = name
                    user.genderType = selectedGender.rawValue
                    user.weight = kg
                    user.height = cm
                    user.bmi = bmi
                    user.healthStatus = hs.rawValue
                    user.createdDate = Date.now
                }else{
                    throw UpdateError.UserNotFound
                }
 
                
            }catch{
                throw UpdateError.UpdateFailed
            }
           
        
            
            if (try? moc.save()) != nil{
                return 201
            } else {
                throw UpdateError.UpdateFailed
            }
        }else{

            throw UpdateError.UserNotFound
        }
           
           
    }
    
}
