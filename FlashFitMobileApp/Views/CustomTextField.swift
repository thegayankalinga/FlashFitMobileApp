//
//  CustomTextField.swift
//  FlashFitMobileApp
//
//  Created by user233619 on 8/12/23.
//

import SwiftUI

struct CustomTextField: View {
    
    var placeholder: String
    @Binding var text: String
    
    var body: some View {
        TextField(placeholder, text: $text)
            .padding(EdgeInsets(top: 5, leading: 20, bottom: 5, trailing: 0))
            .frame(maxWidth: .infinity)
            .background(Color.white)
            .cornerRadius(15)
            .overlay(RoundedRectangle(cornerRadius: 15)
                .stroke(Color.gray.opacity(0.2), lineWidth: 1))
            .foregroundColor(.black)
        
    }
}

/*struct CustomTextField_Previews: PreviewProvider {
    static var previews: some View {
        CustomTextField()
    }
}*/
