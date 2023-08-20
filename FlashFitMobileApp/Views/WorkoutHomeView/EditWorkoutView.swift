//
//  EditWorkoutView.swift
//  FlashFitMobileApp
//
//  Created by Gayan Kalinga on 2023-08-14.
//

import SwiftUI

struct EditWorkoutView: View {

    
    @EnvironmentObject var user: LoggedInUserModel
    @Environment(\.managedObjectContext) var moc
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject var workoutVm =  WorkoutViewModel()
    
    @State private var id: UUID
    @State private var userId: String = ""
    @State private var wType: String = ""
    @State private var duration: String = ""
    @State private var date: Date = Date.now
    @State private var calories: String = ""
    @State private var weight: String = ""
    
    var entity: WorkoutEntity
    
    init(entity: WorkoutEntity) {
        self.entity = entity
        _id = State(initialValue: entity.id ?? UUID())
        //_userId = State(initialValue: entity.userID ?? "")
        _wType = State(initialValue: entity.workoutType ?? "")
        _duration = State(initialValue: String(entity.duration))
        _date = State(initialValue: entity.date ?? Date())
        _weight = State(initialValue: String(entity.weight))
        _calories = State(initialValue: String(entity.calories))
    }
    
    var body: some View {
        VStack (spacing: 20){
            DatePicker("Select a date", selection: $date, displayedComponents: .date)
                .accentColor(.orange)
            
            Text("ID \(id)") // todo: remove
                .padding(.leading)
                .frame(height: 40)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)

            TextField("Workout Type Name", text: $wType)
                .padding(.leading)
                .frame(height: 40)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
            
            TextField("Duration", text: $duration)
                .padding(.leading)
                .frame(height: 40)
                .background(.gray.opacity(0.2))
                .cornerRadius(10)
            
            TextField("Calories", text: $calories)
                .padding(.leading)
                .frame(height: 40)
                .background(.gray.opacity(0.2))
                .cornerRadius(10)
            
            TextField("Body Weight", text: $weight)
                .padding(.leading)
                .frame(height: 40)
                .background(.gray.opacity(0.2))
                .cornerRadius(10)
            
            
            Button(action: {
                //let updatedEntity = WorkoutEntity(context:workoutVm.container.viewContext)
                
                entity.id = id
                entity.userID = userId
                entity.duration = Double(duration) ?? 0.0
                entity.date = date
                entity.workoutType = wType
                entity.calories = Double(calories) ?? 0.0
                entity.weight = Double(weight) ?? 0.0
                
                workoutVm.updateWorkout(entity: self.entity)
                
                dismiss()
                
            }, label: {
                Text("Update")
                    .font(.headline)
                    .foregroundColor(.black)
                    .frame(height: 40)
                    .frame(maxWidth: .infinity)
                    .background(.orange)
                    .cornerRadius(10)
            })
            
        }
        .padding()
        .navigationTitle("Update Workout")
    }
}

struct EditWorkoutView_Previews: PreviewProvider {
    static var previews: some View {
        EditWorkoutView(entity: WorkoutEntity())
            .environmentObject(WorkoutViewModel())
        
    }
}


//struct EditWorkoutView_Previews: PreviewProvider {
//    static var previews: some View {
//        EditWorkoutView()
//    }
//}
