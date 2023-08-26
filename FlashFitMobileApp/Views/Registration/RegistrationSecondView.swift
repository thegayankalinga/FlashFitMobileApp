//
//  RegistrationScreenTwoView.swift
//  FlashFitMobileApp
//
//  Created by Gayan Kalinga on 2023-08-13.
//

import SwiftUI

struct RegistrationSecondView: View {

    @ObservedObject var registrationVM: RegistrationViewModel
    @FocusState private var isFocused: FocusedField?
    
    enum FocusedField{
        case name, weight, height, dob, gender
        
    }
    
    var body: some View {
        VStack {
                
            LogoShapeView(logoTypeName: "home-logo")
            
            Text("Thats all we need...")
                .font(.headline)
                .padding(.top, 25)
                .padding(.bottom, 15)
                
            VStack(alignment: .leading){
                EntryField(bindingField: $registrationVM.name, placeholder: "Your Name", promptText: registrationVM.namePrompot, isSecure: false)
                    .focused($isFocused, equals: .name)
                    .textFieldStyle(GradientTextFieldBackground(systemImageString: "person", colorList: [.blue, .green]))
                    .padding(.bottom)
                
                EntryField(bindingField: $registrationVM.weight, placeholder: "Weight In Kilo Grams", promptText: registrationVM.weightPrompot, isSecure: false)
                    .numberOnly($registrationVM.weight, includeDecimal: false)
                    .focused($isFocused, equals: .weight)
                    .textFieldStyle(GradientTextFieldBackground(systemImageString: "person", colorList: [.blue, .green]))
                    .padding(.bottom)
                
                EntryField(bindingField: $registrationVM.height, placeholder: "Height in CentiMeter", promptText: registrationVM.heightPrompot, isSecure: false)
                    .numberOnly($registrationVM.weight, includeDecimal: false)
                    .focused($isFocused, equals: .height)
                    .textFieldStyle(GradientTextFieldBackground(systemImageString: "person", colorList: [.blue, .green]))
                    .padding(.bottom)
                
                
                Divider()
                Picker("", selection: $registrationVM.genderType) {
                    ForEach(GenderTypeEnum.allCases) { option in
                        // 2
                        Text(String(describing: option))
                    }
                }
                    .frame(height: 50)
                    .pickerStyle(.segmented)
//                Text("\(registrationVM.genderType.rawValue)")
            
                
                //TODO: Birthdate picker
                Divider()
                DatePicker("Birthdate",
                           selection: $registrationVM.dateOfBirth,
                           in: ...Date.now,
                           displayedComponents: [.date]
                          
                )
                //.datePickerStyle(GraphicalDatePickerStyle())
                .padding()
                Text(registrationVM.agePrompt)
                    .fixedSize(horizontal: false, vertical: true)
                    .font(.caption)
                    .padding(.leading, 10)
                    .foregroundColor(.red)
                
            }
            .padding(25)
                Spacer(minLength: 25)
            
            //TODO: Add the image icon to button
            PrimaryActionButton(actionName: "Next",
                                icon: "chevron.forward",
                                disabled: !registrationVM.isSignupSecondPageComplete) {
                    isFocused = nil
                    registrationVM.navigateTo3()
                }
            .opacity(registrationVM.isSignupSecondPageComplete ? 1 : 0.6)
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
        
        .onAppear{
            UITextField.appearance().clearButtonMode = .whileEditing
        }
        
        }
     

}

struct RegistrationScreenTwoView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationSecondView(registrationVM: RegistrationViewModel(UIImage(imageLiteralResourceName: "profile picture")))
    }
}
