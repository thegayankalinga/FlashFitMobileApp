//
//  GradientTextFieldBackground.swift
//  FlashFitMobileApp
//
//  Created by Gayan Kalinga on 2023-08-12.
//

import Foundation
import SwiftUI
struct GradientTextFieldBackground: TextFieldStyle {
    
    let systemImageString: String
    let colorList: [Color]
    
    // Hidden function to conform to this protocol
    func _body(configuration: TextField<Self._Label>) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16.0)
                .stroke(
                    LinearGradient(
                        colors: colorList,
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .frame(height: 50)
            
            HStack {
                Image(systemName: systemImageString)
                // Reference the TextField here
                configuration
            }
            .padding(.leading)
            .foregroundColor(.gray)
        }
    }
}
