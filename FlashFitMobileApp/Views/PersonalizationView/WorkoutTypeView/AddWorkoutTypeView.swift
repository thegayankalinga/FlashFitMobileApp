//
//  AddWorkoutTypeView.swift
//  FlashFitMobileApp
//
//  Created by user233619 on 8/12/23.
//

import SwiftUI
import PhotosUI
import CoreData

struct AddWorkoutTypeView: View {
    @EnvironmentObject var user: LoggedInUserModel
    @Environment(\.dismiss) var dismiss
    @Environment(\.managedObjectContext) var moc
    
    @ObservedObject var viewModel: AddWorkoutTypeViewModel
    @StateObject var imagePicker = ImagePicker()
    @FocusState private var isFocused: FocusedField?
    
    enum FocusedField{
        case workoutTypeName, calorieBurnedPerMin
        
    }
    
    
    
    
    var body: some View {
        NavigationStack{
            VStack{
                
                ScrollView{
                    VStack(alignment: .leading, spacing: 0.0){
       
                        Image("yoga-image")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(maxWidth: .infinity, maxHeight: 220, alignment: .top)
                            .clipped()
                        VStack(alignment: .leading){
                            Text("\(viewModel.updating ? "Updating " : "Add Workout Type")")
                                .font(.title)
                                .fontWeight(.bold)
                        }
                        .padding(.top, 25)
                        .padding(.leading, 25)
                        
                        VStack{
                            EntryField(
                                bindingField: $viewModel.workoutName,
                                placeholder: "Workout Name",
                                promptText: viewModel.workoutNamePrompt,
                                isSecure: false)
                            .focused($isFocused, equals: .workoutTypeName)
                            .textFieldStyle(GradientTextFieldBackground(systemImageString: "fork.knife.circle", colorList: [.cyan, .green]))
                            .padding(.bottom)
                            
                            EntryField(
                                bindingField: $viewModel.caloriesBurnedPerMin,
                                placeholder: "Calories Gained by Potion",
                                promptText: viewModel.caloriesBurnedPrompt,
                                isSecure: false)
                            .numberOnly($viewModel.caloriesBurnedPerMin, includeDecimal: true)
                            .focused($isFocused, equals: .calorieBurnedPerMin)
                            .textFieldStyle(GradientTextFieldBackground(systemImageString: "mouth", colorList: [.blue, .green]))
                            .padding(.bottom)
                            
                            Image(uiImage: viewModel.workoutImage)
                                .resizable()
                                .scaledToFit()
                            
                            HStack{
                                if viewModel.updating {
                                    PhotosPicker("Chage Image",
                                                 selection: $imagePicker.imageSelection,
                                                 matching: .images,
                                                 photoLibrary: .shared())
                                    
                                }else{
                                    PhotosPicker("Select Image",
                                                 selection: $imagePicker.imageSelection,
                                                 matching: .images,
                                                 photoLibrary: .shared())
                                    
                                }
                            }
                            .padding(.bottom, 15)
                            
                            Divider()
                            Toggle("Add More", isOn: $viewModel.isAddMoreChecked.animation())
                                .padding(.leading, 25)
                                .padding(.trailing, 25)
                            
                            
                        }
                        .padding(25)
                        
                        
                    }
                    .edgesIgnoringSafeArea(.all)
                    
                    Spacer()
                    
                }
                
                
                PrimaryActionButton(actionName: "Save", icon: "checkmark", disabled: viewModel.incomplete){
                    isFocused = nil
                    
                    //TODO: optional force unwrap
                    viewModel.getAllWorkoutTypes(email: user.email!, moc: moc)
                    if viewModel.updating{
                        if let id = viewModel.id,
                           let selectedItem = viewModel.myWorkoutTypes.first(where: {$0.imageId == id}){
                            selectedItem.workoutTypeName = viewModel.workoutName
                            selectedItem.calorieBurnPerMin = Double(viewModel.caloriesBurnedPerMin) ?? 0
                            selectedItem.userEmail = user.email
                            FileManager().saveImage(with: id, image: viewModel.workoutImage)
                            if moc.hasChanges{
                                try? moc.save()
                            }
                        }
                    }else{
                        let newItem = WorkoutTypeEntity(context: moc)
                        newItem.workoutTypeName = viewModel.workoutName
                        newItem.calorieBurnPerMin = Double(viewModel.caloriesBurnedPerMin) ?? 0
                        newItem.userEmail = user.email
                        newItem.imageID = UUID().uuidString
                        try? moc.save()
                        FileManager().saveImage(with: newItem.imageId, image: viewModel.workoutImage)
                    }
                    if(!viewModel.isAddMoreChecked){
                        dismiss()
                    }else{
                        viewModel.workoutName = ""
                        viewModel.caloriesBurnedPerMin = ""
                        viewModel.workoutImage = UIImage(systemName: "photo")!
                    }
                    
                    print("workout saved")
                }
                .padding(.bottom, 25)
                
            }
            .edgesIgnoringSafeArea(.all)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    SheetCloseButton(disabled: false){
                        dismiss()
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
            .onChange(of: imagePicker.uiImage){ newImage in
                if let newImage{
                    viewModel.workoutImage = newImage
                }
            }
        }
    }
}

struct AddWorkoutTypeView_Previews: PreviewProvider {
    static var previews: some View {
        AddWorkoutTypeView(viewModel: AddWorkoutTypeViewModel(UIImage(systemName: "photo")!))
    }
}
