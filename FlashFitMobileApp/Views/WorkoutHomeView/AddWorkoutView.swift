//
//  AddWorkoutView.swift
//  FlashFitMobileApp
//
//  Created by Gayan Kalinga on 2023-08-14.
//

import SwiftUI
struct AddWorkoutView: View {
    @EnvironmentObject var user: LoggedInUserModel
    @Environment(\.managedObjectContext) var moc
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject var viewModel: WorkoutViewModel
    @State private var showAlert = false
    @FocusState private var isFocused: FocusedField?
    
    @State private var stepperDisplayValue = 5.00
    @State private var stepperMessage = ""
    enum FocusedField{
        case caloriesBurned, weightAtRecord
    }
    
    let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()


    
    var body: some View {
        
        NavigationStack {
            VStack{
                ScrollView {
                    VStack(alignment: .leading, spacing: 0.0) {
                        
                        LogoShapeView(heightLimiter: 0.5, logoTypeName: "workout-logo")
                            .frame(minHeight: 160)
                        Spacer()
                        
                        
                        
                        VStack (alignment: .leading, spacing: 20){
                            
                            VStack(alignment: .leading){
                                Text("\(viewModel.updating ? "Updating " : "Add Workout Record")")
                                    .font(.title)
                                    .fontWeight(.bold)
                            }
                            .padding(.top, 25)
    //                        .padding(.leading, 25)
                            
                            DatePicker("Select a date", selection: $viewModel.workoutDate, displayedComponents: .date)
                                .accentColor(.orange)
                            
                            
                            VStack{
                                Picker("Select a Workout Type", selection: $viewModel.selectedWorkoutType) {
                                    Text("Select Value").tag(nil as WorkoutTypeEntity?)
                                    ForEach(viewModel.myWorkoutTypes) { option in
                                        HStack{
                                            Image(uiImage: option.uiImage)
                                                .resizable()
                                                .clipShape(Circle())
                                                .scaledToFit()
                                                .frame(width: 32 , height: 32)
                                            Text("Workout: \(option.workoutName)")
                                            Text(String(option.caloriesBurned))
                                        }.tag(option as WorkoutTypeEntity?)
                                    }
                                }
                                .pickerStyle(.navigationLink)
                                .frame(height: 50)
                            }
                            .onAppear(perform: {
                                //print("Appear")
                                //print(viewModel.selectedMealType)
                                viewModel.getAllWorkoutTypes(email: user.email!, moc: moc)
                                if(!viewModel.updating){
                                    viewModel.calTotalCalorieBurned(moc: moc)
                                }
                                if (viewModel.updating){
                                    print("updating")
                                    viewModel.getWorkoutTypeByUUID(moc: moc)
                                    //viewModel.getMealTypeByUUID(moc: moc)
                                    
                                }
                            })
                            
                            
                            HStack(alignment: .center){
                                Stepper("Duration \(stepperMessage)", value: $viewModel.workoutDuration, in: 1...300, step: 5){ value in
                                    print(viewModel.workoutDuration)
                                    
                                    if(viewModel.workoutDuration < 60){
                                        stepperMessage = "\(viewModel.workoutDuration) minutes"
                                    }else if(viewModel.workoutDuration == 60){
                                        stepperMessage = "\(viewModel.workoutDuration / 60) hour"
                                    }else{
                                        stepperMessage = "\(Int(viewModel.workoutDuration) / 60) hr \(Int(viewModel.workoutDuration) % 60) mins"
                                    }
                                    
                                    viewModel.calTotalCalorieBurned(moc: moc)
                                }
      
                            }
                            
                            EntryField(bindingField: $viewModel.totalCaloriesBurned, placeholder: "Total Calories Burned", promptText: "", isSecure: false)
                                .numberOnly($viewModel.totalCaloriesBurned, includeDecimal: true)
                                .focused($isFocused, equals: .caloriesBurned)
                                .textFieldStyle(GradientTextFieldBackground(systemImageString: "dumbbell", colorList: [.blue, .green]))
                                //.padding(.bottom)
                                
                            
                            // Divider()
                            
                            EntryField(bindingField: $viewModel.weightArRecord, placeholder: "Body Weight in Kilo Gram", promptText: viewModel.weightPrompt, isSecure: false)
                                .numberOnly($viewModel.weightArRecord, includeDecimal: true)
                                .focused($isFocused, equals: .weightAtRecord)
                                .textFieldStyle(GradientTextFieldBackground(systemImageString: "scalemass", colorList: [.blue, .green]))
                                //.padding(.bottom)
                            
                            if(!viewModel.updating){
                               // Divider()
                                Toggle("Add More", isOn: $viewModel.isAddMoreChecked.animation())
                                    .padding(.leading, 25)
                                    .padding(.trailing, 25)
                            }
                            
                        }
                        .padding()
                    }
                    Spacer()
                }
                
                PrimaryActionButton(
                    actionName: "Save Workout",
                    icon: "plus.circle",
                    disabled: !viewModel.incomplete)
                {
  
                    isFocused = nil
             
                    viewModel.getAllWorkoutRecordsByEmail(email: user.email!, moc: moc)
                        
                    if viewModel.updating{
                        print("updating")
                        print(viewModel.savedWorkouts)
                        if let id = viewModel.recordID,
                           let selectedItem = viewModel.savedWorkouts.first(where: {$0.workoutRecordID == id}){
                            
                            print(selectedItem)
                            selectedItem.date = viewModel.workoutDate
                            selectedItem.calories = Double(viewModel.totalCaloriesBurned) ?? 0
                            selectedItem.userID = user.email
                            selectedItem.weight = Double(viewModel.weightArRecord) ?? 0.0
                            selectedItem.duration = viewModel.workoutDuration
                            selectedItem.workoutTypeId = viewModel.selectedWorkoutType?.workoutTypeID
                            selectedItem.workoutTypeName = viewModel.workoutTypeName
                            selectedItem.id = viewModel.recordID
                        }
                            
                            if moc.hasChanges{
                                try? moc.save()
                                print("updated")
                                dismiss()
                            }
                        }else{
                            print(viewModel.totalCaloriesBurned)
                            let newRecord = WorkoutEntity(context: moc)
                            newRecord.id = UUID()
                            newRecord.workoutTypeName = viewModel.selectedWorkoutType?.workoutTypeName
                            newRecord.userID = user.email!
                            newRecord.weight = Double(viewModel.weightArRecord) ?? 0.0
                            newRecord.calories = Double(viewModel.totalCaloriesBurned) ?? 0.0
                            newRecord.date = viewModel.workoutDate
                            newRecord.duration = viewModel.workoutDuration
                            newRecord.workoutTypeId = viewModel.selectedWorkoutType!.workoutTypeID
                            try? moc.save()
                            print("saved new")
                        }
                    
                    if(!viewModel.isAddMoreChecked){
                        dismiss()
                    }else{
                        viewModel.workoutDuration = 5
                        viewModel.workoutDate = Date.now
                        viewModel.totalCaloriesBurned = ""
                        viewModel.weightArRecord = ""
                        viewModel.selectedWorkoutType = nil
                    }
                        
                    
                        
                    }
                    .opacity(viewModel.incomplete ? 1 : 0.6)
                    .padding(.bottom, 25)

                }
            .edgesIgnoringSafeArea(.all)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    SheetCloseButton(disabled: false){
                        dismiss()
                    }
                }
                if viewModel.updating{
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button{
                            viewModel.getAllWorkoutRecordsByEmail(email: user.email!, moc: moc)
                            if let id = viewModel.id,
                               let selectedItem = viewModel.myWorkoutTypes.first(where: {$0.workoutTypeID == id}){
                                
                                moc.delete(selectedItem)
                                try? moc.save()
                            }
                            dismiss()
                        }label: {
                            HStack{
                                Image(systemName: "trash")
                            }
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.red)
                    }
                }
                
                ToolbarItem(placement: .keyboard) {
                    Button{
                        isFocused = nil
                    }label: {
                        Image(systemName: "keyboard.chevron.compact.down")
                    }
                    
                }
            }
            }
        
        }
}
/*struct AddWorkoutView: View {
    
    @Environment(\.managedObjectContext) var moc
    @EnvironmentObject var user: LoggedInUserModel
    
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
                        
                        //TODO: Optional force unwrap
                    }
                    
                }
                .padding()
            }
            .frame(width: proxy.size.width, height:proxy.size.height , alignment: .topLeading)
        }
    }
}*/

struct AddWorkoutView_Previews: PreviewProvider {
    static var previews: some View {
        AddWorkoutView(viewModel: WorkoutViewModel())
            .environmentObject(WorkoutViewModel())
    }
}

