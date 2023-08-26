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
    @EnvironmentObject var loggedInUser: LoggedInUserModel
    
    @Published var email = ""
    @Published  var name = ""
    @Published  var dob = Date()
    @Published  var height = ""
    @Published  var weight = ""
    @Published  var selectedGender = GenderTypeEnum.Male
    @Published var userImage: UIImage
    @Published var userToUpdate: UserModelEntity?
    
    var id: String?
    var updating: Bool {id != nil}

    init(_ uiImage: UIImage){
        self.userImage = uiImage
    }
    
    init(_ userModelEntity: UserModelEntity){
        
        email = userModelEntity.userEmail
        id = userModelEntity.userImageID
        name = userModelEntity.fullName
        dob = userModelEntity.dob
        height = String(format: "%.2f",userModelEntity.currentHeight)
        weight = String(format: "%.2f",userModelEntity.currentWeight)
        selectedGender = GenderTypeEnum(rawValue: userModelEntity.genderType ?? "MALE") ?? GenderTypeEnum.Male
        userImage = userModelEntity.uiImage

    }
    
    
    //MARK: computed properties for error handling
    var incomplete: Bool{
        name.isEmpty ||
        userImage == UIImage(systemName: "photo")! ||
        weight.isEmpty ||
        height.isEmpty
        
    }
    
    //MARK: functions for error handling
  
    
    //MARK: DB Operations
    func getTheUserDetailsToUpdate(email: String, moc: NSManagedObjectContext){
        if(UserService.valueExists(email: email, moc: moc)){
            print("user found")
            let fetchRequest: NSFetchRequest<UserModelEntity> = UserModelEntity.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "email == %@", email)
            
            do {
                print(email)
                userToUpdate = try moc.fetch(fetchRequest).first
                print(userToUpdate?.fullName ?? "No user in DB")
                print(updating)
                
            } catch {
                print("Error checking for value existence: \(error)")
                
            }}else{
                print("No user found")
            }
    }
    
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
