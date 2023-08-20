//
//  WorkoutReportView.swift
//  FlashFitMobileApp
//
//  Created by user233619 on 8/20/23.
//

import SwiftUI
import Charts

struct WorkoutReportView: View {
    
    @EnvironmentObject var user: LoggedInUserModel
    @Environment(\.managedObjectContext) var moc
    
    @ObservedObject var workoutVm =  WorkoutViewModel()
    
    @State var date: Date = Date()
    @State private var totalCaloriesForSelectedDate: Double = 0.0
    @State private var totalTime: Double = 0.0
    @State var dailyData: [WorkoutEntity] = []
    
    var height:CGFloat = 130
    var width:CGFloat = 130
    var percent: CGFloat = 50 // total calories burned in the selected date
    
    // this value can be changed to let the user to set the target
    var avgCaloryBurnPerDay = 2000.0
    
    var body: some View {
        let percent  = (totalCaloriesForSelectedDate / avgCaloryBurnPerDay) * 100
        let progress = 1 - (percent / 100)
        
        VStack (alignment: .leading, spacing: 20){
            
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 170))], spacing: 20) {
                ZStack{
                    Rectangle()
                        .frame(width: 170, height: 170)
                        .foregroundColor(Color(hex:0xFDB137))
                        .cornerRadius(10)
                    
                    VStack (alignment: .leading, spacing: 30){
                        HStack {
                            Image(systemName: "flame.fill")
                            Text("Energy Burn")
                                .font(.footnote)
                            
                        }
                        
                        VStack (alignment: .leading, spacing: 3){
                            HStack{
                                Text("\(totalCaloriesForSelectedDate, specifier: "%.2f")")
                                    .font(.subheadline)
                                    .fontWeight(.bold)
                                Text("K/Cal")
                                    .font(.footnote)
                                    .foregroundColor(.secondary)
                                    .fontWeight(.semibold)
                            }
                        }
                    }
                }
                .foregroundColor(.black)
                
                ZStack{
                    Rectangle()
                        .frame(width: 170, height: 170)
                        .foregroundColor(Color(hex:0xFDB137))
                        .cornerRadius(10)
                    
                    VStack (alignment: .leading, spacing: 30){
                        HStack {
                            Image(systemName: "dumbbell.fill")
                            Text("Workout Duration")
                                .font(.footnote)
                        }
                        
                        VStack (alignment: .leading, spacing: 3){
                            HStack{
                                Text("\(Int(totalTime) / 60)")
                                    .font(.subheadline)
                                    .fontWeight(.bold)
                                
                                Text("hrs")
                                    .font(.footnote)
                                    .foregroundColor(.secondary)
                                    .fontWeight(.semibold)
                                
                                Text("\(Int(totalTime) % 60)")
                                    .font(.subheadline)
                                    .fontWeight(.bold)
                                
                                Text("mins")
                                    .font(.footnote)
                                    .foregroundColor(.secondary)
                                    .fontWeight(.semibold)
                            }
                        }
                    }
                }
                .foregroundColor(.black)
            }
            
            // summary
                HStack{
                    Image(systemName: "flame.fill")
                    Text("Daily Activity")
                        .font(.footnote)
                        .padding(.bottom, 1)
                }
                
                ZStack {
                    Color(hex:0xF5F5F5)
                    Chart {
                        ForEach(workoutVm.savedDailyWorkouts) { day in
                            BarMark(x: .value("Workout", day.workoutType ?? ""),
                                    y: .value("Duration (m)", day.duration)
                            )
                            .foregroundStyle(Color.orange)
                            .cornerRadius(6)
                        }
                    }
                    .frame(height: 150)
                    .chartXAxis {
                        AxisMarks(values: workoutVm.savedDailyWorkouts.map {$0.workoutType ?? "Unknown"}) { type in
                            AxisValueLabel()
                        }
                    }
                }
                .frame(height: 200)
                .cornerRadius(10)
                .padding(.bottom, 10)
        }
        .onAppear {
            getTotalCalories()
            getTotalTime()
            getSummaryData()
        }
        .onChange(of: date) { newValue in
            getTotalCalories()
            getTotalTime()
            getSummaryData()
        }
    }
    
    // calculate total calories burnt in a given week
    func getTotalCalories() {
        totalCaloriesForSelectedDate = workoutVm.getCaloriesForByDay(moc, userId: user.email!, date: date)
    }
    
    func getTotalTime() {
        totalTime = workoutVm.getWorkoutTimeByDay(moc, userId: user.email!, date: date)
    }
    
    func getSummaryData() {
        workoutVm.getDailyWorkouts(moc, userId: user.email!, date: date)
    }

}

struct WorkoutReportView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutReportView()
    }
}
