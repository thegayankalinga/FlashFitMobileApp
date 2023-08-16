//
//  PrimaryActionButton.swift
//  FlashFitMobileApp
//
//  Created by Gayan Kalinga on 2023-08-13.
//

import SwiftUI

struct PrimaryActionButton: View {
    
    var actionName: String
    var icon: String
    var disabled: Bool
    var onClick: (() -> Void)
    
    
    var body: some View {
        Button(action: onClick){
            HStack {
                Text(actionName) /// your text
                
                Image(systemName: icon) // set image here
                        .aspectRatio(contentMode: .fit)
            }
        }
        .frame(width: 300, alignment: .center)
        .padding()
        .background(Color(red: 1, green: 0.749, blue: 0.12))
        .foregroundStyle(Color.black)
        .clipShape(Capsule())
        .disabled(disabled)
    }
}


//call site
//CustomButton(
//    text: "Custom Button",
//    icon: Image(systemName: "plus")
//) {
//    print("Clicked!")
//}

struct PrimaryActionButton_Previews: PreviewProvider {
    static var previews: some View {
        PrimaryActionButton(actionName: "Confirm", icon: "chevron.forward", disabled: false, onClick: {print("Clicked")})
    }
}
