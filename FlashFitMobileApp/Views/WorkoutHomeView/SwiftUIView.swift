//
//  SwiftUIView.swift
//  FlashFitMobileApp
//
//  Created by Gayan Kalinga on 2023-08-14.
//

import SwiftUI

struct SwiftUIView: View {
    var body: some View {
        
        GeometryReader{ (proxy : GeometryProxy) in
            VStack(alignment: .trailing) {
                Image("logo")
                    .resizable()
                
                    .edgesIgnoringSafeArea(.top)
                
                    .frame(width: .infinity, height: 280)
                
            }
            .frame(width: proxy.size.width, height:proxy.size.height , alignment: .topLeading)
        }
    }
}


struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIView()
    }
}
