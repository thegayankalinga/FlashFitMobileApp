//
//  PlanTodayView.swift
//  FlashFitMobileApp
//
//  Created by user233619 on 8/6/23.
//

import SwiftUI

struct PlanTodayView: View {
    @Environment(\.managedObjectContext) var moc
    @EnvironmentObject var user: LoggedInUserModel
    
    @ObservedObject var mealVM = MealRecordViewModel()
    @ObservedObject var workoutVM = WorkoutViewModel()
    @State private var calorieGain = 0.0
    @State private var calorieBurn = 0.0
    @State private var percentage = 0
    @State private var workoutCount = 0
    
    let goal = 150.0
    
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
                    HStack{
                        VStack (alignment: .leading, spacing: 3){
                            Text("Today's Goal to Burn")
                                .font(.subheadline)
                                .fontWeight(.medium)
                            Text("\(calorieBurn - calorieGain, specifier: "%.2f") / \(goal, specifier: "%.2f") K/Cal")
                                .font(.caption)
                        }
                        Spacer()
                        
                        HStack{
                            Image(systemName: "\(workoutCount).circle")
                            Text("Planned")
                        }
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
        .onAppear(perform: {
            print("today view appear")
            workoutVM.getDailyWorkouts(moc, userId: user.email!, date: Date.now)
            workoutCount = workoutVM.savedDailyWorkouts.count
            calorieBurn = workoutVM.getCaloriesForByDay(moc, userId: user.email!, date: Date.now)
            calorieGain = mealVM.getCaloriesForByDay(moc, userId: user.email!, date: Date.now)
            
            let difference = calorieBurn - calorieGain
            //let remainingToGoal = goal - difference
            percentage = Int(difference/goal * 100.0)
            
            print(percentage)
            
            switch percentage {
            case 0..<25:
                workoutVM.todayViewColor = CustomColors.primaryRed
            case 25..<50:
                workoutVM.todayViewColor = CustomColors.primaryOrange
            case 50..<75:
                workoutVM.todayViewColor = CustomColors.primaryYellow
                print(workoutVM.todayViewColor)
            case 75...100:
                workoutVM.todayViewColor = CustomColors.primaryGreen
            default:
                workoutVM.todayViewColor = CustomColors.primaryColor
            }
            
        })
        .frame(height: 120)
        
    }
}

struct PlanTodayView_Previews: PreviewProvider {
    static var previews: some View {
        PlanTodayView()
    }
}
