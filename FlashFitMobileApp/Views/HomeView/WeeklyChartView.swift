//
//  WeeklyChartView.swift
//  FlashFitMobileApp
//
//  Created by user233619 on 8/6/23.
//

import SwiftUI
import Charts

struct WeeklyChartView: View {
    
    // todo: fetch from DB
    let dayByContent: [WeeklyActivity] = [
        .init(date: Date.from(year: 2023, month: 1, day: 1), workoutDuration: 10),
        .init(date: Date.from(year: 2023, month: 1, day: 2), workoutDuration: 14),
        .init(date: Date.from(year: 2023, month: 1, day: 3), workoutDuration: 40),
        .init(date: Date.from(year: 2023, month: 1, day: 4), workoutDuration: 50),
        .init(date: Date.from(year: 2023, month: 1, day: 5), workoutDuration: 20),
        .init(date: Date.from(year: 2023, month: 1, day: 6), workoutDuration: 50),
        .init(date: Date.from(year: 2023, month: 1, day: 7), workoutDuration: 10)
    ]
    
    var body: some View {
        VStack (alignment: .leading){
            
            HStack{
                Image(systemName: "flame.fill")
                Text("Weekly Activity")
                    .font(.footnote)
                    .padding(.bottom, 1)
            }
            
            let total = dayByContent.reduce(0) {$0 + $1.workoutDuration}
            
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
}

struct WeeklyChartView_Previews: PreviewProvider {
    static var previews: some View {
        WeeklyChartView()
    }
}

struct WeeklyActivity: Identifiable {
    let id = UUID()
    let date: Date
    let workoutDuration: Double
}

extension Date {
    static func from(year:Int, month:Int, day:Int) -> Date{
        let components = DateComponents(year: year, month: month, day: day)
        return Calendar.current.date(from: components)!
    }
}

