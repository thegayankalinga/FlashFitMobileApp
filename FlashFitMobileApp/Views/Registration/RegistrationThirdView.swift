//
//  RegistrationThirdView.swift
//  FlashFitMobileApp
//
//  Created by Gayan Kalinga on 2023-08-13.
//

import SwiftUI
import PhotosUI
struct RegistrationThirdView: View {

        
        @Environment(\.managedObjectContext) var moc
        @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
        @StateObject var registrationVM: RegistrationViewModel
        @State private var response = 0;
        @State private var confirmButtonClickCount = 0
        @State private var validated = false
    @StateObject var imagePicker  = ImagePicker()
        
        
        
        var body: some View {
            
   
        VStack{
            LogoShapeView(logoTypeName: "home-logo")
                    .frame(maxHeight: 220)
     
            ScrollView{
                VStack{
                    Text("Confirm your details")
                        .font(.headline)
                        .padding(.top, 10)
                        .padding(.bottom, 25)
                    
                    Image(uiImage: (registrationVM.userImage))
                        .resizable()
                        .scaledToFill()
                        .frame(width: 128 , height: 128)
                        .clipShape(Circle())
                    
                    HStack{
                        PhotosPicker("Select Image",
                                     selection: $imagePicker.imageSelection,
                                     matching: .images,
                                     photoLibrary: .shared())
                    }
                    
                    
             
                    
                    VStack(alignment: .leading){
                       
                        //Data to confirm
                        VStack(alignment: .leading, spacing: 20){
                            
                            HStack(spacing: 20){
                                Text("Email: ")
                                Text(registrationVM.email)
                                
                            }
                            HStack(spacing: 20){
                                Text("Name: ")
                                Text(registrationVM.name)
                            }
                            
                            HStack(spacing: 20){
                                Text("Gender: ")
                                Text(registrationVM.genderType.rawValue)
                            }
                            
                            HStack(spacing: 20){
                                Text("Date of Birth: ")
                                Text("\(registrationVM.dateFormatter.string(from: registrationVM.dateOfBirth ))")
                            }
                            
                            HStack(spacing: 20){
                                Text("Weight: ")
                                Text(registrationVM.weight)
                            }
                            
                            
                        }
                        
                        .padding(.bottom, 20)
                    }
         
                    .padding(.top, 10)
                    
     
                    
                    if(confirmButtonClickCount == 0 ){
                        //TODO: Add the image icon to button
                        PrimaryActionButton(actionName: "Confirm", icon: "checkmark", disabled: false){
                            confirmButtonClickCount += 1
                            do{
                                response = try registrationVM.register(moc: moc)
                            }catch RegistrationError.userExist{
                                response = 409
                                print("User exist")
                            }catch RegistrationError.creationFailed{
                                response = 400
                                print("Something went wrong")
                            }catch{
                                response = 400
                                print("Something went wrong")
                            }
                            
                        }
                    }
                    
                    if(response == 201){
                        VStack{
                            Text("Hooray, Welcome")
                            
                            Text("Successfully Registered Please Login to continue.")
                            
                        }
                        Button("Login"){
                            confirmButtonClickCount = 0
                            
                            withAnimation{
                                registrationVM.navigateToRoot()
                                
                                self.presentationMode.wrappedValue.dismiss()
                                
                                self.presentationMode.wrappedValue.dismiss()
                            }
                        }.transition(.slide)
                        
                        
                        
                    }else if(response == 409){
                        VStack{
                            Text("User Already  Existing in our records, pls login")
                            Button("Login"){
                                confirmButtonClickCount = 0
                                
                                withAnimation{
                                    registrationVM.navigateToRoot()
                                    
                                    self.presentationMode.wrappedValue.dismiss()
                                    
                                    self.presentationMode.wrappedValue.dismiss()
                                }
                                
                            }
                            .transition(.slide)
                            
                        }
                        
                    }else if(response != 0){
                        VStack{
                            Text("Something went wrong, could you pls re-try")
                            Button("Re-Try"){
                                withAnimation{
                                    confirmButtonClickCount = 0
                                    registrationVM.navigateToRoot()
                                }
                            }.transition(.slide)
                        }
                    }
                }
            }
        }
        .toolbar{
            }.onChange(of: imagePicker.uiImage){ newImage in
                if let newImage{
                    registrationVM.userImage = newImage
            }
        }
   
        }

}

struct RegistrationThirdView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationThirdView(registrationVM: RegistrationViewModel(UIImage(imageLiteralResourceName: "profile picture")))
    }
}
