//
//  AddWorkoutView.swift
//  FlashFitMobileApp
//
//  Created by Gayan Kalinga on 2023-08-14.
//

import SwiftUI

struct AddWorkoutView: View {
    @Environment(\.managedObjectContext) var moc
    //@EnvironmentObject private var workoutVm: WorkoutViewModel
    @ObservedObject var workoutVm =  WorkoutViewModel()
    
    @State var wType: String = ""
    @State var duration: String = ""
    @State var date: Date = Date.now
    @State var calories: String = ""
    @State var weight: String = ""
    
    var body: some View {
        
        GeometryReader{ (proxy : GeometryProxy) in
            VStack(alignment: .trailing) {
                Image("logo")
                    .resizable()
                    .edgesIgnoringSafeArea(.top)
                    //.frame(maxWidth: .infinity)
                    //.frame(height: 250)
                
                VStack (spacing: 20){
                    DatePicker("Select a date", selection: $date, displayedComponents: .date)
                        .accentColor(.orange)
                    
                    EntryField(bindingField: $wType, placeholder: "Workout Type Name", promptText: "", isSecure: false)
                        .textFieldStyle(GradientTextFieldBackground(systemImageString: "figure.run", colorList: [.blue, .green]))
                        .padding(.bottom)
                    
                    TextField("Duration", text: $duration)
                        .padding(.leading)
                        .frame(height: 40)
                        .background(.gray.opacity(0.2))
                        .cornerRadius(10)
                    TextField("Calories Burnt", text: $calories)
                        .padding(.leading)
                        .frame(height: 40)
                        .background(.gray.opacity(0.2))
                        .cornerRadius(10)
                    TextField("Body Weight (Kg)", text: $weight)
                        .padding(.leading)
                        .frame(height: 40)
                        .background(.gray.opacity(0.2))
                        .cornerRadius(10)
                    
                    PrimaryActionButton(actionName: "Add Workout", icon: "plus.circle", disabled: false){
                        workoutVm.addWorkout(moc: moc, type: wType, duration: duration, date: date, calories: calories, weight: weight)
                        wType = ""
                        duration = ""
                        date = Date()
                        calories = ""
                        weight = ""
                    }
                    
                }
                .padding()
            }
            .frame(width: proxy.size.width, height:proxy.size.height , alignment: .topLeading)
        }
        
        /*VStack {
            Image("logo")
                 .resizable()
                 .frame(width: .infinity, height: 250)

            /*VStack (spacing: 20){
                DatePicker("Select a date", selection: $date, displayedComponents: .date)
                    .accentColor(.orange)
                
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
                TextField("Calories Burnt", text: $calories)
                    .padding(.leading)
                    .frame(height: 40)
                    .background(.gray.opacity(0.2))
                    .cornerRadius(10)
                TextField("Body Weight (Kg)", text: $weight)
                    .padding(.leading)
                    .frame(height: 40)
                    .background(.gray.opacity(0.2))
                    .cornerRadius(10)
                
                Button(action: {
                    workoutVm.addWorkout(type: wType, duration: duration, date: date, calories: calories, weight: weight)
                    wType = ""
                    duration = ""
                    date = Date()
                    calories = ""
                    weight = ""
                }, label: {
                    Text("Add")
                        .font(.headline)
                        .foregroundColor(.black)
                        .frame(height: 40)
                        .frame(maxWidth: .infinity)
                        .background(.orange)
                        .cornerRadius(10)
                })
                
            }
            .padding()*/
            
        //.navigationTitle("Workout")
        }*/
    }
}

struct AddWorkoutView_Previews: PreviewProvider {
    static var previews: some View {
        AddWorkoutView()
            .environmentObject(WorkoutViewModel())
    }
}

