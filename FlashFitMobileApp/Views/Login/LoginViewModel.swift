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
    
    
    func login(email: String, password: String, moc: NSManagedObjectContext)throws -> UserModelEntity{
        
        var user: UserModelEntity
        
        //Getuser from the DB
        let fetchRequest: NSFetchRequest<UserModelEntity> = UserModelEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "email == %@", email)
        
        do {
            let context = moc // Replace with your actual managed object context
            let data = try context.fetch(fetchRequest).first
            
            if(data == nil){
                throw LoginError.invalidUser
            }else{
                
                user = UserModelEntity(context: moc)
                user.email = (data?.email)!
                user.name = (data?.name)!
                user.passwordSalt = (data?.passwordSalt)!
                user.passwordHash = (data?.passwordHash)!
                user.dateOfBirth = data?.dateOfBirth ?? Date.now
                user.genderType = data?.genderType!
                user.weight = (data?.weight)!
                user.height = (data?.height)!
                user.bmi = (data?.bmi)!
                user.healthStatus = data?.healthStatus!
                user.createdDate = (data?.createdDate)!
                user.userImageId = (data?.userImageId)

            }
            
        } catch {
            print("Error checking for value existence: \(error)")
            throw LoginError.invalidUser
        }
    
        
        //Assign Salt
        let salt: String = user.passwordSalt!
     
        let passwordHash = PasswordHasher.computeHash(password: password, salt: salt, pepper: pepper, iteration: passwordHasherIteration)
        
        if(user.passwordHash != passwordHash){
            throw LoginError.invalidCredentials
        }
        return user
        
    }
    
}
