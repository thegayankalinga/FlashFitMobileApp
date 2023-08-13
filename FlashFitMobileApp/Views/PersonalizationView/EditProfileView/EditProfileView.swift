//
//  EditProfileView.swift
//  FlashFitMobileApp
//
//  Created by user233619 on 8/6/23.
//

import SwiftUI

struct EditProfileView: View {
    
    @State private var name = ""
    @State private var dob = Date()
    @State private var height = ""
    @State private var weight = ""
    @State private var selectedGender = 0 // 0 - Male, 1 - Female
    
    var body: some View {
        VStack {
            
           Form {
               Section (header: Text("Personal Details")){
                   TextField("Full Name", text: $name)
  
                   DatePicker("Birthdate", selection: $dob, displayedComponents: [.date])
                       .accentColor(.orange)
                   
                   Picker(selection: $selectedGender, label: Text("Gender")) {
                       Text("Male").tag(0)
                       Text("Female").tag(1)
                   }
                   .pickerStyle(SegmentedPickerStyle())
                   .frame(width: 350)
               }
               
               Section(header: Text("Body Measurements")) {
                   TextField("Height (cm)", text: $height)
                   TextField("Weight (Kg)", text: $weight)
               }
           }.frame(height: 400)
            Button(action: {
                
            }, label: {
                Text("Update")
                    .frame(width: 350, height: 50, alignment: .center)
                    .background(Color.orange)
                    .cornerRadius(15)
                    .overlay(RoundedRectangle(cornerRadius: 15)
                        .stroke(Color.gray.opacity(0.2), lineWidth: 1))
                    .foregroundColor(.black)
                
            })
            Spacer()
        }
    }
}


struct EditProfileView_Previews: PreviewProvider {
    static var previews: some View {
        EditProfileView()
    }
}
