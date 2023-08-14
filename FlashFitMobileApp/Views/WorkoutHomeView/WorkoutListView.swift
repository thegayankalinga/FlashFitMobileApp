//
//  WorkoutListView.swift
//  FlashFitMobileApp
//
//  Created by Gayan Kalinga on 2023-08-14.
//

import SwiftUI

struct WorkoutListView: View {
    @Environment(\.managedObjectContext) var moc
    @ObservedObject var workoutVm =  WorkoutViewModel()

    var body: some View {
        List{
            ForEach(workoutVm.savedWorkouts) { entity in
               // Section(header: Text(entity.workoutType ?? "Unknown")) {
                    NavigationLink(destination: EditWorkoutView(entity: entity)) {
                        HStack {
                            VStack{
                                Text("\(dateFormatted(date: entity.date ?? Date.now))")
                                VStack (alignment: .leading, spacing: 5) {
                                    HStack(spacing: 4) { // duration
                                        Text("Duration")
                                        
                                        Spacer()
                                        
                                        Text("\(Int(entity.duration) / 60)")
                                        Text("hrs")
                                            .font(.footnote)
                                            .foregroundColor(.secondary)
                                            .fontWeight(.semibold)
                                        
                                        Text("\(Int(entity.duration) % 60)")
                                        Text("mins")
                                            .font(.footnote)
                                            .foregroundColor(.secondary)
                                            .fontWeight(.semibold)
                                    }
                                    
                                    HStack (spacing: 4){ // calories
                                        Text("Caories Burnt")
                                        Spacer()
                                        HStack {
                                            Text("\((entity.duration), specifier: "%.2f")")
                                            Text("K/Cal")
                                                .font(.footnote)
                                                .foregroundColor(.secondary)
                                                .fontWeight(.semibold)
                                        }
                                    }
                                    .padding(.bottom, 2)
                                }
                            }
                            .font(.caption)
                        }
                    }
                //}
                
            }
            .onDelete(perform: { indexSet in
                workoutVm.deleteWorkout(moc, indexSet: indexSet)
                
            })
            
           /* ForEach(groupedWorkouts.keys.sorted(), id: \.self) { workoutType in
                Section(header: Text(workoutType)) {
                    ForEach(groupedWorkouts[workoutType]!.indices, id: \.self) { index in
                        let entity = groupedWorkouts[workoutType]![index]
                        NavigationLink(destination: EditWorkoutView(entity: entity)) {
                            HStack {
                                VStack{
                                    Text("\(dateFormatted(date: entity.date ?? Date.now))")
                                    VStack (alignment: .leading, spacing: 5) {
                                        HStack(spacing: 4) { // duration
                                            Text("Duration")
                                            
                                            Spacer()
                                            
                                            Text("\(Int(entity.duration) / 60)")
                                            Text("hrs")
                                                .font(.footnote)
                                                .foregroundColor(.secondary)
                                                .fontWeight(.semibold)
                                            
                                            Text("\(Int(entity.duration) % 60)")
                                            Text("mins")
                                                .font(.footnote)
                                                .foregroundColor(.secondary)
                                                .fontWeight(.semibold)
                                        }
                                        
                                        HStack (spacing: 4){ // calories
                                            Text("Caories Burnt")
                                            Spacer()
                                            HStack {
                                                Text("\((entity.duration), specifier: "%.2f")")
                                                Text("K/Cal")
                                                    .font(.footnote)
                                                    .foregroundColor(.secondary)
                                                    .fontWeight(.semibold)
                                            }
                                        }
                                        .padding(.bottom, 2)
                                    }
                                }
                                .font(.caption)
                            }
                        }
                    }
                    
                }
            }
            .onDelete(perform: workoutVm.deleteWorkout)*/
        }
        .onAppear(perform : {
            workoutVm.getWorkouts(moc)
        })
            
        var groupedWorkouts: [String: [WorkoutEntity]] {
            Dictionary(grouping: workoutVm.savedWorkouts) { entity in
                entity.workoutType ?? "Unknown"
            }
        }
    }
    
    func dateFormatted(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMM yyyy"
        return dateFormatter.string(from: date)
    }
}

struct WorkoutListView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutListView()
            .environmentObject(WorkoutViewModel())
    }
}


