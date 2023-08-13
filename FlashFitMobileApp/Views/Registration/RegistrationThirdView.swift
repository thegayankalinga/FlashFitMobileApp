//
//  RegistrationThirdView.swift
//  FlashFitMobileApp
//
//  Created by Gayan Kalinga on 2023-08-13.
//

import SwiftUI

struct RegistrationThirdView: View {

        
        @Environment(\.managedObjectContext) var moc
        @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
        @StateObject var registrationVM: RegistrationViewModel
        
        @State private var response = 0;
        @State private var confirmButtonClickCount = 0
        @State private var validated = false
        
        
        
        
        var body: some View {
            
            VStack{
                LogoShapeView()
                
                Text("Confirm your details")
                    .font(.headline)
                    .padding(.top, 25)
                    .padding(.bottom, 25)
                
                //Data to confirm
                VStack(alignment: .leading){

                    Text(registrationVM.email)
                    Text(registrationVM.name)
                    Text(registrationVM.genderType.rawValue)
                    Text("\(registrationVM.dateFormatter.string(from: registrationVM.dateOfBirth ))")
                    Text(registrationVM.weight)
        
                }
                
                
                Spacer()
                
                if(confirmButtonClickCount == 0 ){
                    //TODO: Add the image icon to button
                    PrimaryActionButton(actionName: "Confirm", icon: "checkmark", disabled: false){
                        
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
                        
                        Button("Login"){
                            confirmButtonClickCount = 0
                            self.presentationMode.wrappedValue.dismiss()
                        }
                    }
                    
                }else if(response == 409){
                    VStack{
                        Text("User Already  Existing in our records, pls login")
                        Button("Login"){
                            confirmButtonClickCount = 0
                            self.presentationMode.wrappedValue.dismiss()
                        }
                    }
                    
                }else if(response != 0){
                    VStack{
                        Text("Something went wrong, could you pls re-try")
                        Button("Re-Try"){
                            confirmButtonClickCount = 0
                            registrationVM.navigateToRoot()
                        }
                    }
                }
                
                
            }
        }
     
                

            

}

struct RegistrationThirdView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationThirdView(registrationVM: RegistrationViewModel())
    }
}
