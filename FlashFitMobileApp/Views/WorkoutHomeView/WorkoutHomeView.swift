//
//  WorkoutHomeView.swift
//  FlashFitMobileApp
//
//  Created by user233619 on 8/6/23.
//

import SwiftUI
import CoreData

struct WorkoutHomeView: View {
    
    //@EnvironmentObject private var workoutVm: WorkoutViewModel
    @Environment(\.managedObjectContext) var moc
    @ObservedObject var workoutVm =  WorkoutViewModel()
    
    @State var date: Date = Date()
    
    var body: some View {
        VStack{
        
            DatePicker("Pick a date", selection: $date, displayedComponents: .date)
                .accentColor(.orange)
                .padding()
            
            ZStack {
                Color(hex:0xFDB137)
                Text("Burnt")
            }
            .frame(height: 150)
            .cornerRadius(10)
            .padding(.bottom, 10)
            
            ZStack {
                Color(hex:0xFDB137)
                Text("Summary")
            }
            .frame(height: 150)
            .cornerRadius(10)
            .padding(.bottom, 10)
            
            NavigationLink("Update Recorded Workouts", destination: WorkoutListView())
        }
        .navigationTitle("Workout")
    }
}

struct WorkoutHomeView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutHomeView()
            .environmentObject(WorkoutViewModel())
    }
}

