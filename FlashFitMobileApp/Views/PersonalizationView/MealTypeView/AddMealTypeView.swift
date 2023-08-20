//
//  AddMealTypeView.swift
//  FlashFitMobileApp
//
//  Created by Gayan Kalinga on 2023-08-14.
//

import SwiftUI
import PhotosUI
import CoreData


struct AddMealTypeView: View {
    @EnvironmentObject var user: LoggedInUserModel
    @Environment(\.dismiss) var dismiss
    @Environment(\.managedObjectContext) var moc
   
    
    @ObservedObject var viewModel: AddMealTypeViewModel
    @StateObject var imagePicker  = ImagePicker()
    @FocusState private var isFocused: FocusedField?
    
    enum FocusedField{
        case mealTypeName, caloriesGained
        
    }
    
    var body: some View {
        NavigationStack {
            VStack{
                ScrollView{
                    VStack(alignment: .leading, spacing: 0.0){
       
                        Image("cake-image")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(maxWidth: .infinity, maxHeight: 220, alignment: .top)
                            .clipped()
                        VStack(alignment: .leading){
                            Text("\(viewModel.updating ? "Updating " : "Add Meal Type")")
                                .font(.title)
                                .fontWeight(.bold)
                        }
                        .padding(.top, 25)
                        .padding(.leading, 25)
                        
                        VStack{
                            EntryField(
                                bindingField: $viewModel.mealName,
                                placeholder: "Meal Name",
                                promptText: viewModel.mealTypeNamePrompt,
                                isSecure: false)
                            .focused($isFocused, equals: .mealTypeName)
                            .textFieldStyle(GradientTextFieldBackground(systemImageString: "fork.knife.circle", colorList: [.cyan, .green]))
                            .padding(.bottom)
                            
                            EntryField(
                                bindingField: $viewModel.caloriesGainPerPotion,
                                placeholder: "Calories Gained by Potion",
                                promptText: viewModel.caloriesGainedPrompot,
                                isSecure: false)
                            .numberOnly($viewModel.caloriesGainPerPotion, includeDecimal: true)
                            .focused($isFocused, equals: .caloriesGained)
                            .textFieldStyle(GradientTextFieldBackground(systemImageString: "mouth", colorList: [.blue, .green]))
                            .padding(.bottom)
                            
                            Image(uiImage: viewModel.mealImage)
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
                    //TODO: Optional force unwrap
                    viewModel.getAllMealTypes(email: user.email!, moc: moc)
                    if viewModel.updating{
                        if let id = viewModel.id,
                           let selectedItem = viewModel.myMealTypes.first(where: {$0.imageId == id}){
                            selectedItem.mealTypeName = viewModel.mealName
                            selectedItem.caloriesGained = Double(viewModel.caloriesGainPerPotion) ?? 0
                            selectedItem.userEmail = user.email
                            FileManager().saveImage(with: id, image: viewModel.mealImage)
                            if moc.hasChanges{
                                try? moc.save()
                            }
                        }
                    }else{
                        let newMeal = MealTypeEntity(context: moc)
                        newMeal.typeID = UUID()
                        newMeal.mealTypeName = viewModel.mealName
                        newMeal.caloriesGained = Double(viewModel.caloriesGainPerPotion) ?? 0
                        newMeal.userEmail = user.email
                        newMeal.imageID = UUID().uuidString
                        try? moc.save()
                        FileManager().saveImage(with: newMeal.imageId, image: viewModel.mealImage)
                    }
                    if(!viewModel.isAddMoreChecked){
                        dismiss()
                    }else{
                        viewModel.mealName = ""
                        viewModel.caloriesGainPerPotion = ""
                        viewModel.mealImage = UIImage(systemName: "photo")!
                    }
                    
                    print("saved")
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
                    viewModel.mealImage = newImage
                }
            }
            
        }
        
    }
}

struct AddMealTypeView_Previews: PreviewProvider {
    static var previews: some View {
        AddMealTypeView(viewModel: AddMealTypeViewModel(UIImage(systemName: "photo")!))
    }
}

