//
//  PlanTodayView.swift
//  FlashFitMobileApp
//
//  Created by user233619 on 8/6/23.
//

import SwiftUI

struct PlanTodayView: View {
    
    @ObservedObject var mealVM = MealRecordEntity()
    @ObservedObject var workoutVM = WorkoutViewModel()
    
    var body: some View {
        VStack {
            HStack (alignment: .top){
                VStack (alignment: .leading, spacing: 30){
                    HStack {
                        Image(systemName: "dumbbell.fill")
                        Text("Workout Plan")
                            .font(.footnote)
                            .padding(.bottom, 1)
                    }
                    
                    VStack (alignment: .leading, spacing: 3){
                        Text("Today's Goal")
                            .font(.subheadline)
                            .fontWeight(.medium)
                        Text("150 K/Cal")
                            .font(.caption)
                    }
                }
                
                Spacer()
                
                Text("Record")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
            }
            
            .padding()
        }
        .frame(height: 120)
        
    }
}

struct PlanTodayView_Previews: PreviewProvider {
    static var previews: some View {
        PlanTodayView()
    }
}
