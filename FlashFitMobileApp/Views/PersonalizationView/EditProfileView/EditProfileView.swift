//
//  EditProfileView.swift
//  FlashFitMobileApp
//
//  Created by user233619 on 8/6/23.
//

import SwiftUI

struct EditProfileView: View {
    
    
    @EnvironmentObject var user: LoggedInUserModel
    @Environment(\.dismiss) var dismiss
    @Environment(\.managedObjectContext) var moc
    
    @StateObject var viewModel = EditProfileViewModel()
    @State private var showingAlert = false
    
    @State private var alertHeading = ""
    @State private var alertMessage = ""
    
    var body: some View {
        VStack {
            
           Form {
               Section (header: Text("Personal Details")){
                   TextField("Full Name", text: $viewModel.name)
  
                   DatePicker("Birthdate", selection: $viewModel.dob, displayedComponents: [.date])
                       .accentColor(.orange)
                   
                   
                   
                   Section (header: Text("Gender")){
                       Picker("", selection: $viewModel.selectedGender) {
                           ForEach(GenderTypeEnum.allCases) { option in
                               // 2
                               Text(String(describing: option))
                           }
                       }
                       .frame(height: 50)
                       .pickerStyle(.segmented)
                   }
                 
               }
               
               Section(header: Text("Height in Centi Meters")) {
                   EntryField(bindingField: $viewModel.height, placeholder: "Heigh in CM", promptText: "", isSecure: false)
                       .numberOnly($viewModel.height, includeDecimal: true)
               }
               Section(header: Text("Weight in Kilo Grams")) {
                   EntryField(bindingField: $viewModel.weight, placeholder: "Weight in KG", promptText: "", isSecure: false)
                       .numberOnly($viewModel.weight, includeDecimal: true)
                   //EntryField("Weight (Kg)", text: $viewModel.weight)
               }
           }
           
            Spacer()
            PrimaryActionButton(actionName: "Update", icon: "pencil.line", disabled: false){
                do{
                    let response = try viewModel.update(email: user.email ?? "", moc: moc)
                    if(response == 201){
                        alertHeading = "Update Successful"
                        alertMessage = "\(viewModel.name) Updated Successful"
                        showingAlert.toggle()
                        print("\(viewModel.name) Updated Successful")
                    }
                }catch UpdateError.UpdateFailed{
                    alertHeading = "Update Failed"
                    alertMessage = "Update Failed, Please re-try later"
                    showingAlert.toggle()
                    print("Update Failed")
                }catch UpdateError.UserNotFound{
                    alertHeading = "User not found for update"
                    alertMessage = "User details not found, please re-try later"
                    showingAlert.toggle()
                    print("User not found")
                    
                }catch{
                    alertHeading = "Unknown Error"
                    alertMessage = "Please re-try later, update unsuccessful"
                    showingAlert.toggle()
                    print("Something went wrong")
                }
            }
        }
        .onAppear(perform: setUserDataAtLoad)
        .environmentObject(user)
        .alert(isPresented: $showingAlert) { () -> Alert in
            Alert(title: Text(alertHeading), message: Text(alertMessage))
        }
    }
    
    
    func setUserDataAtLoad(){
       
        print("Loading")
        var localUser: UserModel
        
        do{
            if let email = user.email{
                localUser = try UserService.getUserData(email: email, moc: moc)
                viewModel.email = localUser.email
                viewModel.name = localUser.name
                viewModel.height = String(format: "%.2f", localUser.heightInCentiMeter)
                viewModel.dob = localUser.dateOfBirth
                viewModel.weight = String(format: "%.2f", localUser.weightInKilos)
                viewModel.selectedGender = localUser.genderType
            }
        }catch{
            print(error.localizedDescription)
        }
    }
}


struct EditProfileView_Previews: PreviewProvider {
    static var previews: some View {
        EditProfileView()
            .environmentObject(LoggedInUserModel(email: "bg15407@gmail.com", name: "Gayan"))
    }
}
