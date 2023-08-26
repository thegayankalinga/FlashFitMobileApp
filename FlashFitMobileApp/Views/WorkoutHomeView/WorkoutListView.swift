//
//  WorkoutListView.swift
//  FlashFitMobileApp
//
//  Created by Gayan Kalinga on 2023-08-14.
//

import SwiftUI

struct WorkoutListView: View {
    
    @EnvironmentObject var user: LoggedInUserModel
    @Environment(\.managedObjectContext) var moc
    
    @ObservedObject var viewModel =  WorkoutViewModel()

    var body: some View {
        List{
            ForEach(viewModel.savedWorkouts) { entity in
               // Section(header: Text(entity.workoutType ?? "Unknown")) {
                NavigationLink(destination: WorkoutReocrdFormType.update(entity)) {
                        HStack {
                            VStack{
                                Text("\(dateFormatted(date: entity.date ?? Date.now))")
                                VStack (alignment: .leading, spacing: 5) {
                                    
                                    HStack (spacing: 4){ // calories
                                        Text("Workout Type")
                                        Spacer()
                                        HStack {
                                            Text(entity.workoutTypeNameFromRecord)
                                        }
                                    }
                                    
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
                                    .onAppear(perform: {
                                        viewModel.getWorkoutTypeBySpecificID(id: entity.workoutRecordID, moc: moc)
                                    })
                                    
                                    HStack (spacing: 4){ // calories
                                        Text("Caories Burnt")
                                        Spacer()
                                        HStack {
                                            Text("\((entity.calories), specifier: "%.2f")")
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
                //TODO: Optional force unwrap
                viewModel.deleteWorkout(moc, indexSet: indexSet, userId: user.email!)
                
            })
          }
        .onAppear(perform : {
            //TODO: Optional force unwrap
            viewModel.getWorkouts(moc, userId: user.email!)
        })
            
        var groupedWorkouts: [String: [WorkoutEntity]] {
            Dictionary(grouping: viewModel.savedWorkouts) { entity in
                entity.workoutTypeNameFromRecord
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


