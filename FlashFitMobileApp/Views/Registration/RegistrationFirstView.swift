//
//  RegistrationFirstView.swift
//  FlashFitMobileApp
//
//  Created by Gayan Kalinga on 2023-08-13.
//

import SwiftUI

struct RegistrationFirstView: View {
        
        @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
        @ObservedObject var registrationVM: RegistrationViewModel
        
        @State private var nextView: IdentifiableView? = nil
        @FocusState private var isFocused: FocusedField?
        
        enum FocusedField{
            case email, password, confirmPassword, name
            
        }
        
        var body: some View {
            VStack {
                
                //TODO: Graphic & Logo
                LogoShapeView()
               
                Text("Lets Start...")
                    .font(.headline)
                    .padding(.top, 25)
                    .padding(.bottom, 25)
                
                VStack {
                    
                    EntryField(bindingField: $registrationVM.email, placeholder: "Email Address", promptText: registrationVM.emailPrompt, isSecure: false)
                        .focused($isFocused, equals: .email)
                        .textFieldStyle(GradientTextFieldBackground(systemImageString: "person", colorList: [.blue, .green]))
                        .padding(.bottom)
                    
                    EntryField(bindingField: $registrationVM.password, placeholder: "Password", promptText: registrationVM.goodPasswordPrompt, isSecure: true)
                        .focused($isFocused, equals: .password)
                        .disableAutocorrection(true)
                        .textFieldStyle(GradientTextFieldBackground(systemImageString: "lock", colorList: [.blue, .green]))
                        .padding(.bottom)
                    
                    EntryField(bindingField: $registrationVM.confirmPassword, placeholder: "Confirm Password", promptText: registrationVM.confirmPasswordPrompt, isSecure: true)
                        .focused($isFocused, equals: .confirmPassword)
                        .disableAutocorrection(true)
                        .textFieldStyle(GradientTextFieldBackground(systemImageString: "lock.fill", colorList: [.blue, .green]))
                        .padding(.bottom)
                }
                .padding(25)
                       
                Spacer(minLength: 25)
                
                //TODO: Add the image icon to button
                PrimaryActionButton(
                    actionName: "Next",
                    icon: "chevron.forward",
                    disabled: !registrationVM.isSignupFirstPageComplete
                ) {
                    registrationVM.navigateTo2()
                }
                .opacity(registrationVM.isSignupFirstPageComplete ? 1 : 0.6)
                
                
                HStack{
                    Text("Already have an account ?")

                    Button("Login"){
                        self.presentationMode.wrappedValue.dismiss()
                    }
                    
              
                }
                
                Spacer(minLength: 50)

                
            }
            .toolbar {
                ToolbarItem(placement: .keyboard) {
                    Button{
                        isFocused = nil
                    }label: {
                        Image(systemName: "keyboard.chevron.compact.down")
                    }
                    
                }
            }
        }

}

struct RegistrationFirstView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationFirstView(registrationVM: RegistrationViewModel(UIImage(imageLiteralResourceName: "profile picture")))
    }
}
