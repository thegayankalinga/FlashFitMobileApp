//
//  SplashScreenView.swift
//  FlashFitMobileApp
//
//  Created by Gayan Kalinga on 2023-08-14.
//

import SwiftUI

struct SplashScreenView: View {
    
    @State private var isActive = false
    
    @State private var size = 0.5
    @State private var opacity = 1.0
    
    
    var body: some View {
        
        if isActive {
            ContentView()
        }
        
        else {
            VStack {
                VStack {
                    Image("splash")
                        .resizable()
                        .scaledToFit()
                        .frame(width:250, height: 250)
                        .font(.system(size: 80))
                        .clipShape(Rectangle())
                    
                    Text("FlashFit")
                        .font(.title)
                        .fontWeight(.bold)
                }
                .scaleEffect(size)
                .opacity(opacity)
                .onAppear {
                    withAnimation(.easeIn(duration: 1.8).delay(0.5)){
                        self.size = 0.9
                        self.opacity = 1.0
                    }
            }
            }
            .onAppear{
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) {
                    self.isActive = true
                }
            }
        }
        
        
    }
}

struct SplashScreenView_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreenView()
    }
}
