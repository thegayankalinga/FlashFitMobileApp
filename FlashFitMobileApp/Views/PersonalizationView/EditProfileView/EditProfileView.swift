//
//  EditProfileView.swift
//  FlashFitMobileApp
//
//  Created by user233619 on 8/6/23.
//

import SwiftUI
import PhotosUI
import CoreData

struct EditProfileView: View {
    
    
    @EnvironmentObject var user: LoggedInUserModel
    @Environment(\.dismiss) var dismiss
    @Environment(\.managedObjectContext) var moc
    
    @StateObject var imagePicker  = ImagePicker()
    @StateObject var viewModel: EditProfileViewModel
    @State private var showingAlert = false
    
    @State private var alertHeading = ""
    @State private var alertMessage = ""
    
    @FocusState private var isFocused: FocusedField?
    
    enum FocusedField{
        case name, height, weight
        
    }
    
    var body: some View {
            VStack {
                Form {
                    
                    Image(uiImage: viewModel.userImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 64 , height: 64)
                        .clipShape(Circle())
                        .frame(maxWidth: .infinity, alignment: .center)
                    HStack{
                        PhotosPicker("Select Profile Picture",
                                     selection: $imagePicker.imageSelection,
                                     matching: .images,
                                     photoLibrary: .shared())
                        
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.bottom, 15)
                    
                    Section (header: Text("Personal Details")){
                        TextField("Full Name", text: $viewModel.name)
                        
                        DatePicker("Birthdate", selection: $viewModel.dob, displayedComponents: [.date])
                            .accentColor(.orange)
                        
                        
                    }
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
                .tint(.pink)
                
                PrimaryActionButton(actionName: "Update", icon: "checkmark", disabled: viewModel.incomplete){
                    isFocused = nil
                    
                    viewModel.getTheUserDetailsToUpdate(email: user.email!, moc: moc)
                    if viewModel.updating{
                        if(viewModel.id == nil || viewModel.id! == ""){
                            print("seeting id for existing user")
                            viewModel.id = UUID().uuidString
                        }
                        if let id = viewModel.id,
                           let selectedItem = viewModel.userToUpdate{
                            //print(id)
                            //print(viewModel.userToUpdate)
                            let bmi = UserService.calculateBmi(weight: Double(viewModel.weight) ?? 0.0, height: Double(viewModel.height) ?? 0.0)
                            selectedItem.name = viewModel.name
                            selectedItem.weight = Double(viewModel.weight) ?? 0.0
                            selectedItem.height = Double(viewModel.height) ?? 0.0
                            selectedItem.genderType = viewModel.selectedGender.rawValue
                            selectedItem.dateOfBirth = viewModel.dob
                            selectedItem.bmi = bmi
                            selectedItem.healthStatus = UserService.getHealthStatus(bodyMassIndexValue: bmi).rawValue
                            
                            //print(selectedItem.userImageId)
                            if(selectedItem.userImageID == ""){
                                print("setting")
                               
                                selectedItem.userImageId = id
                            }
                            
                            if(selectedItem.id == nil){
                                selectedItem.id = UUID(uuidString: id)
                            }
                            //print(selectedItem)
                            FileManager().saveImage(with: id, image: viewModel.userImage)
                            
                            if moc.hasChanges{
                                try? moc.save()
                            }
                            
                            alertHeading = "Update Successful"
                            alertMessage = "\(viewModel.name) Updated Successful"
                            showingAlert.toggle()
                            print("\(viewModel.name) Updated Successful")
                        }
                    }
                    
                    
                    
                }
                .opacity(!viewModel.incomplete ? 1 : 0.6)
                .padding(.bottom, 25)

            }
            //.edgesIgnoringSafeArea(.all)
            .toolbar {
                ToolbarItem(placement: .keyboard) {
                    Button{
                        isFocused = nil
                    }label: {
                        Image(systemName: "keyboard.chevron.compact.down")
                    }
                    
                }
            }
            .onChange(of: imagePicker.uiImage){ newImage in
                if let newImage{
                    viewModel.userImage = newImage
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
        EditProfileView(viewModel: EditProfileViewModel(UIImage(imageLiteralResourceName: "profile picture")))
           
    }
}
