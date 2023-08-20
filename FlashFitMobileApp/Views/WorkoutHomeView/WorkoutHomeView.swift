//
//  WorkoutHomeView.swift
//  FlashFitMobileApp
//
//  Created by user233619 on 8/6/23.
//

import SwiftUI
import CoreData

struct WorkoutHomeView: View {
    
    @EnvironmentObject var user: LoggedInUserModel
    @Environment(\.managedObjectContext) var moc
    
    @ObservedObject var workoutVm =  WorkoutViewModel()
    
    @State var date: Date = Date()
    @State private var totalCaloriesForSelectedDate: Double = 0.0
    
    var height:CGFloat = 130
    var width:CGFloat = 130
    var percent: CGFloat = 50 // total calories burned in the selected date
    
    // this value can be changed to let the user to set the target
    var avgCaloryBurnPerDay = 2000.0
    
    var body: some View {
        
        let percent  = (totalCaloriesForSelectedDate / avgCaloryBurnPerDay) * 100
        let progress = 1 - (percent / 100)
        
        // progress
        VStack{
            DatePicker("Pick a date", selection: $date, displayedComponents: .date)
                .accentColor(.orange)
                .padding()
            
            ZStack {
                Color(hex:0xFDB137)
                
                HStack {
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
                }.padding()
                
            }
            .frame(height: 200)
            .cornerRadius(10)
            .padding(.bottom, 10)
            
            // summary
            ZStack {
                Color(hex:0xFDB137)
                Text("Summary")
            }
            .frame(height: 200)
            .cornerRadius(10)
            .padding(.bottom, 10)
            
            NavigationLink("Update Recorded Workouts", destination: WorkoutListView()).accentColor(.orange)
        }
        .navigationTitle("Workout")
        .onAppear {
            getTotalCalories()
        }
        .onChange(of: date) { newValue in
            getTotalCalories()
        }
    }
    
    // calculate total calories burnt in a given date
    func getTotalCalories() {
        totalCaloriesForSelectedDate = workoutVm.getCaloriesForByDay(moc, userId: user.email!, date: date)
        print("Calories", totalCaloriesForSelectedDate)
    }
    
}

struct WorkoutHomeView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutHomeView()
    }
}

