//
//  UserService.swift
//  FlashFitMobileApp
//
//  Created by Gayan Kalinga on 2023-08-20.
//

import Foundation
import CoreData
import UIKit
class UserService{
    
    static func getUserData(email: String, moc: NSManagedObjectContext)throws -> UserModel{
        
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
                    dateOfBirth: (data?.dateOfBirth) ?? Date.now,
                    genderType: GenderTypeEnum(rawValue: (data?.genderType)!)!,
                    weightInKilos: (data?.weight)!,
                    heightInCentiMeter: (data?.height)!,
                    bodyMassIndex: (data?.bmi)!,
                    healthStatus: HealthStatusEnum(rawValue: (data!.healthStatus)!)!,
                    createdDate: (data?.createdDate)!,
                    image: (data?.uiImage) ?? UIImage(imageLiteralResourceName: "profile picture")
                )
            }
            
            
            print(user.self)
        } catch {
            print("Error checking for value existence: \(error)")
            throw LoginError.invalidUser
        }
    
        
        return user
        
    }
    
    static func getUserEntityByEmail(email: String, moc: NSManagedObjectContext)throws -> UserModelEntity?{
        
        
        //Getuser from the DB
        let fetchRequest: NSFetchRequest<UserModelEntity> = UserModelEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "email == %@", email)
        
        do{
            let context = moc // Replace with your actual managed object context
            let data = try context.fetch(fetchRequest).first
            
            return context.object(with: data!.objectID) as? UserModelEntity
            
        }catch{
            print(error.localizedDescription)
            throw UpdateError.UserNotFound
        }
    
        
        
    }
    
    
    static func valueExists(email: String, moc: NSManagedObjectContext) -> Bool {
        let fetchRequest: NSFetchRequest<UserModelEntity> = UserModelEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "email == %@", email)
        
        do {
            let context = moc // Replace with your actual managed object context
            let count = try context.count(for: fetchRequest)
            return count > 0
        } catch {
            print("Error checking for value existence: \(error)")
            return false
        }
    }
    
    static func calculateBmi(weight: Double, height: Double) -> Double {

        var bmi: Double = 0.0
        
        var heightMeters = height / 100
        heightMeters = heightMeters * heightMeters

        bmi = weight / heightMeters

        return bmi
    }
    
    static func getHealthStatus(bodyMassIndexValue: Double) -> HealthStatusEnum {
        
        switch bodyMassIndexValue {
        case ...18.5:
            return .Underweight
        case 18.5...24.9:
            return .Normalweight
        case 25...29.9:
            return .Overweight
        case 30...:
            return .Obesity
        default:
            return .None
        }
    }
}
