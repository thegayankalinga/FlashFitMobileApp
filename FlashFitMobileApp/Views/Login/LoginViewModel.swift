//
//  LoginViewModel.swift
//  FlashFitMobileApp
//
//  Created by Gayan Kalinga on 2023-08-12.
//

import Foundation
import CoreData
import SwiftUI

class LoginViewModel: ObservableObject{
    
   
    
    let pepper: String = "DEFAULTPEPPERVALUE"
    let passwordHasherIteration: Int = 3
    @Published var email = ""
    @Published var password = ""
    
    
    func login(email: String, password: String, moc: NSManagedObjectContext)throws -> UserModel{
        
        var user: UserModel
        
        //Getuser from the DB
        let fetchRequest: NSFetchRequest<UserModelEntity> = UserModelEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "email == %@", email)
        
        do {
            let context = moc // Replace with your actual managed object context
            let data = try context.fetch(fetchRequest).first
            
            if(data == nil){
                throw LoginError.invalidUser
            }else{
                user = UserModel(
                    email: (data?.email)!,
                    name: (data?.name)!,
                    passwordSalt: (data?.passwordSalt)!,
                    passwordHash: (data?.passwordHash)!,
                    dateOfBirth: data?.dateOfBirth ?? Date.now,
                    genderType: GenderTypeEnum(rawValue: (data?.genderType)!)!,
                    weightInKilos: (data?.weight)!,
                    heightInCentiMeter: (data?.height)!,
                    bodyMassIndex: (data?.bmi)!,
                    healthStatus: HealthStatusEnum(rawValue: (data!.healthStatus)!)!,
                    createdDate: (data?.createdDate)!
                )
            }
            
        } catch {
            print("Error checking for value existence: \(error)")
            throw LoginError.invalidUser
        }
    
        
        //Assign Salt
        let salt: String = user.passwordSalt
     
        let passwordHash = PasswordHasher.computeHash(password: password, salt: salt, pepper: pepper, iteration: passwordHasherIteration)
        
        if(user.passwordHash != passwordHash){
            throw LoginError.invalidCredentials
        }
        return user
        
    }
    
}
