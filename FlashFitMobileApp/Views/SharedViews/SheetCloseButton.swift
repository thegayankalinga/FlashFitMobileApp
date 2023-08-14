//
//  SheetCloseButton.swift
//  FlashFitMobileApp
//
//  Created by Gayan Kalinga on 2023-08-14.
//

import Foundation
import SwiftUI

struct SheetCloseButton: View{
    
    var icon: String = "x.circle.fill"
    var disabled: Bool
    var onClick: (() -> Void)
    
    var body: some View {
        Button(action: onClick){
            HStack {
                 /// your text
                
                Image(systemName: icon) // set image here
                    .aspectRatio(contentMode: .fit)
            }
        }
        .frame(width: 32, alignment: .center)
        //.background(CustomColors.backgroundGray)
        .foregroundStyle(.gray)
        .clipShape(Circle())
        .disabled(disabled)
    }
}
