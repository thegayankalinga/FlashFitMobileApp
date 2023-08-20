//
//  WorkoutHomeView.swift
//  FlashFitMobileApp
//
//  Created by user233619 on 8/6/23.
//

import SwiftUI
import CoreData
import Charts

struct WorkoutHomeView: View {
    
    @EnvironmentObject var user: LoggedInUserModel
    @Environment(\.managedObjectContext) var moc
    
    @ObservedObject var workoutVm =  WorkoutViewModel()
    
    @State var date: Date = Date()
    @State private var totalCaloriesForSelectedDate: Double = 0.0
    @State var dailyData: [WorkoutEntity] = []
    
    var height:CGFloat = 130
    var width:CGFloat = 130
    var percent: CGFloat = 50 // total calories burned in the selected date
    
    // this value can be changed to let the user to set the target
    var avgCaloryBurnPerDay = 2000.0
    
    var columns = Array(repeating: GridItem(.flexible(), spacing: 20), count: 2)
    
    var body: some View {
        
        let percent  = (totalCaloriesForSelectedDate / avgCaloryBurnPerDay) * 100
        let progress = 1 - (percent / 100)
        
        VStack (alignment: .leading){
            DatePicker("Pick a date", selection: $date, displayedComponents: .date)
                .accentColor(.orange)
                .padding()
            
            // progress
            VStack(alignment: .leading){
                HStack{
                    Image(systemName: "flame.fill")
                    Text("Burned Calories")
                        .font(.footnote)
                        .padding(.bottom, 1)
                }
                
                ZStack {
                    Color(hex:0xFDB137)
                    ZStack{
                        Circle()
                            .stroke(Color.white ,style: StrokeStyle(lineWidth: 10))
                            .frame(width: width, height: height)
                        Circle()
                            .trim(from: CGFloat(progress), to: 1)
                            .stroke(Color.orange, style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round, miterLimit: .infinity, dash: [20,0], dashPhase: 0))
                            .rotationEffect(.degrees(90))
                            .rotation3DEffect(.degrees(180), axis: (x: 1, y: 0, z: 0))
                            .frame(width: width, height: height)
                        VStack{
                            Text("\(totalCaloriesForSelectedDate, specifier: "%.1f")").font(.title2).bold()
                            Text("K/Cal").font(.caption).bold().padding(0.5)
                        }
                    }
                    
                }
                .frame(height: 200)
                .cornerRadius(10)
                .padding(.bottom, 10)
                
            }
            // summary
            VStack (alignment: .leading){
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
            
            NavigationLink("Update Recorded Workouts", destination: WorkoutListView()).accentColor(.orange)
        }
        .navigationTitle("Workout")
        .onAppear {
            getTotalCalories()
            getSummaryData()
        }
        .onChange(of: date) { newValue in
            getTotalCalories()
            getSummaryData()
        }
    }
    
    // calculate total calories burnt in a given date
    func getTotalCalories() {
        totalCaloriesForSelectedDate = workoutVm.getCaloriesForByDay(moc, userId: user.email!, date: date)
        print("Calories", totalCaloriesForSelectedDate)
    }
    
    func getSummaryData() {
        workoutVm.getDailyWorkouts(moc, userId: user.email!, date: date)
    }
}

struct WorkoutHomeView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutHomeView()
    }
}

