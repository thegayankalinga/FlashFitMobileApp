//
//  RegistrationViewModel.swift
//  FlashFitMobileApp
//
//  Created by Gayan Kalinga on 2023-08-11.
//

import Foundation
import CoreData
import SwiftUI



class RegistrationViewModel: ObservableObject{

    
    
    
    @Published var navigationPath = NavigationPath()
    
    @Published var email = ""
    @Published var name = ""
    @Published var password = ""
    @Published var confirmPassword = ""
    @Published var genderType = GenderTypeEnum.Male
    @Published var dateOfBirth: Date = Calendar.current.date(byAdding: .year, value: -15, to: Date())!
    @Published var weight = ""
    @Published var height = ""
    @Published var userImage: UIImage
  
    var dateFormatter = DateFormatter()

    
    init(_ uiImage: UIImage){
        self.dateFormatter.dateFormat = "yyyy-MMM-dd"
        self.userImage = uiImage
    }
    
    init( navigationPath: NavigationPath = NavigationPath(), email: String = "", name: String = "", password: String = "", confirmPassword: String = "", genderType: GenderTypeEnum = GenderTypeEnum.Male, dateOfBirth: Foundation.Date? = nil, weight: String = "", height: String = "", dateFormatter: DateFormatter = DateFormatter(), image: UIImage) {
        
        self.navigationPath = navigationPath
        self.email = email
        self.name = name
        self.password = password
        self.confirmPassword = confirmPassword
        self.genderType = genderType
        self.dateOfBirth = dateOfBirth ?? Calendar.current.date(byAdding: .year, value: -15, to: Date())!
        self.weight = weight
        self.height = height
        self.dateFormatter.dateFormat = "yyyy-MMM-dd"
        self.userImage = image
    }

    
   
    //MARK: NAVIGATION FUNCTIONS
    func navigateTo2() {
        navigationPath.append(2)
    }
    
    func navigateTo3() {
        navigationPath.append("1")
    }

    
    func navigateBack() {
        navigationPath.removeLast()
    }
    
    func navigateToRoot() {
        navigationPath = NavigationPath()
    }
    

    
    //MARK: VALIDATTION PROMPT COMPUTED PROPERTIES
    var isSignupFirstPageComplete: Bool{
        if  !passwordsMatch() ||
            !isValidEmail() ||
            !isPasswordGood() {
            return false
        
        }
        return true
    }
    
    var isSignupSecondPageComplete: Bool{
        if  !isValidName() ||
            !isValidWeigt() ||
            !isValidHeight() ||
            !isValidAge() {
            return false
        
        }
        return true
    }
    
    var confirmPasswordPrompt: String{
        if passwordsMatch(){
            return ""
        }else{
            return "Passwords do not match"
        }
    }
    
    var goodPasswordPrompt: String{
        if(isPasswordGood()){
            return ""
        }else{
            return "Password should have atleast \(4 - (password.count)) characters"
        }
    }
    
    var emailPrompt: String{
        if isValidEmail(){
            return ""
        }else{
            return "Email should be valid"
        }
    }
    
    var namePrompot: String{
        if isValidName(){
            return ""
        }else{
            return "Name cannot be empty"
        }
    }
    
    var weightPrompot: String{
        if isValidWeigt() {
            return ""
        }else{
            return "Weight cannot be less than 20KG"
        }
    }
    
    var heightPrompot: String{
        if isValidHeight() {
            return ""
        }else{
            return "Height cannot be less than 50CM"
        }
    }
    
    var agePrompt: String{
        if isValidAge() {

            return ""
        }else {
            return "Age must be 15 years or older"
        }
    }
    
    
    //TODO: to update the validation functions
    //MARK: VALIDATTION FUNCTIONS
    func passwordsMatch() -> Bool{
        password == confirmPassword
    }
    
    func isPasswordGood() -> Bool{
        let passwordTest = NSPredicate(
            format: "SELF MATCHES %@", "^.{4,}$")
        
        return passwordTest.evaluate(with: password)
    }
    
    func isValidEmail() -> Bool{
        let emailTest = NSPredicate(
                format: "SELF MATCHES %@",
                "^([a-zA-Z0-9_\\-\\.]+)@((\\[[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.)|(([a-zA-Z0-9\\-]+\\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\\]?)$")

            return emailTest.evaluate(with: email)
        
    }
    
    func isValidName() -> Bool{
        let nameTest = NSPredicate(
            format: "SELF MATCHES %@", "^.{2,}$")
        
        return nameTest.evaluate(with: name)
    }
    
    func isValidWeigt() -> Bool{
        let convertedWeight = Double(weight) ?? 0.00
        return convertedWeight > 20
    }
    
    func isValidHeight() -> Bool{
        let convertedHeight = Double(height) ?? 0.00
        return convertedHeight  > 50
    }
    
    func isValidAge() -> Bool{
        (calculateAge(birthdate: dateOfBirth) ?? 1) >= 15
    }
    
    
    func calculateAge(birthdate: Date) -> Int? {
        let calendar = Calendar.current
        let currentDate = Date()
        
        let ageComponents = calendar.dateComponents([.year, .month, .day], from: birthdate, to: currentDate)
        
        if let years = ageComponents.year,
           let months = ageComponents.month,
           let days = ageComponents.day {
            // Adjust the age if the birthday hasn't occurred yet this year
            if (months < 0) || (months == 0 && days < 0) {
                return years - 1
            } else {
                return years
            }
        }
        
        return nil
    }

    
    //MARK: REGISTRATION FUNCTION
    public func register(moc: NSManagedObjectContext)throws -> Int{
  
        if(UserService.valueExists(email: email, moc: moc)){
            print("User alredy exists")
            throw RegistrationError.userExist
        }else{
            let pepper: String = "DEFAULTPEPPERVALUE"
            let passwordHasherIteration: Int = 3
            
            let kg: Double = Double(weight) ?? 0.0
            let cm: Double = Double(height) ?? 0.0
            let bmi: Double = UserService.calculateBmi(weight: kg, height: cm)
            let hs: HealthStatusEnum = UserService.getHealthStatus(bodyMassIndexValue: bmi)
            let pslt = PasswordHasher.generateSalt()
            
            let psh = PasswordHasher.computeHash(
                password: password,
                salt: pslt,
                pepper: pepper,
                iteration: passwordHasherIteration)
            
            //Saving the User
            let user = UserModelEntity(context: moc)
            user.id = UUID()
            user.dateOfBirth = dateOfBirth
            user.email = email
            user.name = name
            user.passwordSalt = pslt
            user.passwordHash = psh
            user.genderType = genderType.rawValue
            user.weight = kg
            user.height = cm
            user.bmi = bmi
            user.healthStatus = hs.rawValue
            user.createdDate = Date.now
            user.userImageId = UUID().uuidString
        
            
            try? moc.save()
            FileManager().saveImage(with: user.userImageID, image: userImage)
            
            if (try? moc.save()) != nil{
                return 201
            } else {
                throw RegistrationError.creationFailed
            }
            
        }
           
           
    }
}
