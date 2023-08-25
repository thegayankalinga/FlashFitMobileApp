//
//  HomeScreenView.swift
//  FlashFitMobileApp
//
//  Created by Gayan Kalinga on 2023-08-05.
//

import Charts
import SwiftUI

struct HomeScreenView: View {
    
    @EnvironmentObject var user: LoggedInUserModel
    @Environment(\.managedObjectContext) var moc
    
    @ObservedObject var workoutVm =  WorkoutViewModel()
    
    @State var dayByContent: [WeeklyActivity] = []
    @State var weeklyWorkouts: [Date: TimeInterval] = [:]
    
    @State private var total = 0.0
    @State var healthStatus : HealthStatusEnum = .Normalweight
    
    var body: some View {
        
        VStack{
            // profile
            ProfileSectionView().padding(.bottom, 20)
            
            ScrollView {
                
                // prediction
                ZStack {
                    Color(hex:0xFDB137)
                    VStack {
                        NavigationLink(destination: PredictionView()) {
                            HStack (alignment: .top) {
                                VStack (alignment: .leading, spacing: 30) {
                                    HStack {
                                        Image(systemName: "figure.walk")
                                        Text("Health Prediction")
                                            .font(.footnote)
                                            .padding(.bottom, 5)
                                    }
                                    
                                    VStack (alignment: .leading, spacing: 3) {
                                        Text(healthStatus.rawValue)
                                            .font(.subheadline)
                                            .fontWeight(.medium)
                                        Text("\((user.weight!), specifier: "%.2f") Kg")
                                            .font(.caption)
                                    }
                                }
                                
                                Spacer()
                                
                                Text("\(getDate())")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                
                                Image(systemName: "chevron.right")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            .padding()
                            .foregroundColor(.black)
                        }
                    }
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
                    VStack (alignment: .leading) {
                        
                        HStack{
                            Image(systemName: "flame.fill")
                            Text("Weekly Activity")
                                .font(.footnote)
                                .padding(.bottom, 1)
                        }
                        
                        HStack(spacing: 4) {
                            Text("\(Int(total) / 60)")
                                .font(.subheadline)
                                .fontWeight(.bold)
                                .padding(.bottom, 10)
                            
                            Text("hrs")
                                .font(.footnote)
                                .foregroundColor(.secondary)
                                .fontWeight(.semibold)
                                .padding(.bottom, 8)
                            
                            Text("\(Int(total) % 60)")
                                .font(.subheadline)
                                .fontWeight(.bold)
                                .padding(.bottom, 10)
                            
                            Text("mins")
                                .font(.footnote)
                                .foregroundColor(.secondary)
                                .fontWeight(.semibold)
                                .padding(.bottom, 8)
                        }
                        
                        Chart {
                            ForEach(dayByContent) { day in
                                BarMark(x: .value("Day of Week", day.date, unit: .day),
                                        y: .value("Duration (m)", day.workoutDuration)
                                )
                                .foregroundStyle(Color.orange)
                                .cornerRadius(6)
                            }
                        }
                        .frame(height: 150)
                        .chartXAxis {
                            AxisMarks(values: dayByContent.map {$0.date}) { date in
                                AxisValueLabel(format: .dateTime.weekday(.narrow), centered: true)
                            }
                        }
                        
                    }
                    .padding()
                    .cornerRadius(10)
                }
                .cornerRadius(10)
                .padding(.bottom, 10)
                
            }
        }
        .onAppear{
            calculateHealthStatus()
            getTotalDuration()
        }
    }
    
    func getTotalDuration () {
        // Clear the existing data
        weeklyWorkouts = [:]
        dayByContent = []
        
        workoutVm.getWeeklyWorkouts(moc, userId: user.email!)
        let data  = workoutVm.savedWeeklyWorkouts
        
        // group data by day
        let calendar = Calendar.current
        for workout in data {
            if let workoutDate = workout.date {
                let components = calendar.dateComponents([.year, .month, .day], from: workoutDate)
                let truncatedDate = calendar.date(from: components)!
                
                if let existingDuration = weeklyWorkouts[truncatedDate] {
                    weeklyWorkouts[truncatedDate] = existingDuration + workout.duration
                } else {
                    weeklyWorkouts[truncatedDate] = workout.duration
                }
            }
        }
        
        // Set default values if no values present for a day
        // Find the weekday of the current day
        let weekday = calendar.component(.weekday, from: Date())
        
        // From monday to sunday
        let daysToSubtract = (weekday + 5) % 7
        let startOfWeek = calendar.date(byAdding: .day, value: -daysToSubtract, to: Date())!
        let endOfWeek = calendar.date(byAdding: .day, value: 6, to: startOfWeek)!
        
        var currentDate = startOfWeek
        while currentDate <= endOfWeek {
            let truncatedDate = calendar.date(bySettingHour: 0, minute: 0, second: 0, of: currentDate)!
            if weeklyWorkouts[truncatedDate] == nil {
                weeklyWorkouts[truncatedDate] = 0.0
            }
            currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate)!
        }
        
        // weekly data
        let sortedByDate = weeklyWorkouts.sorted { $0.key < $1.key }
        dayByContent = sortedByDate.map { WeeklyActivity(date: $0.key, workoutDuration: $0.value) }
        
        // get weekly total
        total = dayByContent.reduce(0) {$0 + $1.workoutDuration}
    }
    
    func calculateHealthStatus(){
        let ht = (user.height ?? 0.0) / 100
        
        let BMI = (user.weight ?? 0.0) / (ht * ht)
        
        if BMI < 18.5 {
            healthStatus = .Underweight
        } else if 18.5 <= BMI && BMI < 25 {
            healthStatus = .Normalweight
        } else if 25 <= BMI && BMI <= 40 {
            healthStatus = .Overweight
        } else if BMI >= 40.0 {
            healthStatus = .Obesity
        } else {
            healthStatus = .None
        }
        
    }
    
    func getDate() -> String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM"
        
        return formatter.string(from: date)
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
