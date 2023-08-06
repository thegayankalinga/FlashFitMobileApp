//
//  HomeScreenView.swift
//  FlashFitMobileApp
//
//  Created by Gayan Kalinga on 2023-08-05.
//

import SwiftUI

struct HomeScreenView: View {
    var body: some View {
       
        VStack{
            // profile
            ProfileSectionView()
            
            ScrollView {
                
                // prediction
                ZStack {
                    Color(hex:0xFDB137)
                    PredictionSectionView()
                }
                .cornerRadius(10)
                .padding(.top, 15)
                .padding(.bottom, 10)
                
                // plan for today
                ZStack {
                    Color(hex:0xFDB137)
                    PlanTodayView()
                }
                .cornerRadius(10)
                .padding(.bottom, 10)

                // weekly chart
                ZStack{
                    Color(hex:0xF4F4F4)
                    WeeklyChartView()
                }
                .cornerRadius(10)
                .padding(.bottom, 10)
                
            }
        }
    }
}

struct HomeScreenView_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreenView()
    }
}

extension Color {
    init(hex: Int, alpha: Double = 1.0) {
        let red = Double((hex >> 16) & 0xff) / 255.0
        let green = Double((hex >> 8) & 0xff) / 255.0
        let blue = Double(hex & 0xff) / 255.0
        self.init(red: red, green: green, blue: blue, opacity: alpha)
    }
}
