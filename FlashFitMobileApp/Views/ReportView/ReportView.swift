//
//  ReportView.swift
//  FlashFitMobileApp
//
//  Created by user233619 on 8/6/23.
//

import SwiftUI

struct ReportView: View {
    
    @State private var tabIndex = 0
    @EnvironmentObject var user: LoggedInUserModel
    
    var body: some View {
        
        VStack {
            Text("Statistics")
                .font(.title3).bold()
            
            // tab view
            Picker(selection: $tabIndex, label: Text("")) {
                Text("Workouts").tag(0)
                Text("Meals").tag(1)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            
            switch tabIndex {
            case 0:
                WorkoutReportView()
            case 1:
                MealsReportView()
            default:
                EmptyView()
            }
            
            Spacer(minLength: 0)
        }
        .environmentObject(user)
    }
}

struct ReportView_Previews: PreviewProvider {
    static var previews: some View {
        ReportView()
    }
}
