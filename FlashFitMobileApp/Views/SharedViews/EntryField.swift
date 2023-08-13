//
//  EntryField.swift
//  FlashFitMobileApp
//
//  Created by Gayan Kalinga on 2023-08-13.
//

import SwiftUI

struct EntryField: View {
    @Binding var bindingField: String
    var placeholder: String
    var promptText: String
    var isSecure: Bool
    var body: some View {
        VStack(alignment: .leading){
           
            if(isSecure){
                SecureField(placeholder, text: $bindingField).autocapitalization(.none)
            }else{
                TextField(placeholder, text: $bindingField).autocapitalization(.none)
            }
            Text(promptText)
            .fixedSize(horizontal: false, vertical: true)
            .font(.caption)
            .padding(.leading, 10)
            .foregroundColor(.red)

        }
    }
}

struct EntryField_Previews: PreviewProvider {
    static var previews: some View {
        EntryField(bindingField: .constant("Value"), placeholder: "placeholder", promptText: "this is a prompt", isSecure: false)
    }
}
