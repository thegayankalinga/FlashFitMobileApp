//
//  LogoShapeView.swift
//  FlashFitMobileApp
//
//  Created by Gayan Kalinga on 2023-08-13.
//

import SwiftUI

struct LogoShapeView: View {
    var body: some View {
        VStack{
            
            Text("Header Graphic")
            Spacer()
            Text("LOGO")
            
            
        }
        .padding(50)
        .frame(maxWidth: .infinity, maxHeight: 200)
        .background(CustomColors.primaryColor)
        
    }
}

struct LogoShapeView_Previews: PreviewProvider {
    static var previews: some View {
        LogoShapeView()
    }
}
