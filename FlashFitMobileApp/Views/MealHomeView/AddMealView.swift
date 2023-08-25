//
//  AddMealView.swift
//  FlashFitMobileApp
//
//  Created by Gayan Kalinga on 2023-08-14.
//

import SwiftUI
import UIKit
import CoreData

struct AddMealView: View {
    @EnvironmentObject var user: LoggedInUserModel
    @Environment(\.managedObjectContext) var moc
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject var viewModel: AddMealRecordViewModel
    @State private var showAlert = false
    @FocusState private var isFocused: FocusedField?
    
    var email: String
    enum FocusedField{
        case caloriesGained
        
    }
    
    let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()

    
    @FetchRequest(fetchRequest: MealTypeEntity.fetchRequest()) var fetchedMealTypes: FetchedResults<MealTypeEntity>
    
    init(userEmail: String) {
        self.email = userEmail
        _fetchedMealTypes = FetchRequest<MealTypeEntity>(fetchRequest: MealTypeEntity.getSpecifiedMealsTypes(findEmail: email))
       viewModel = AddMealRecordViewModel()
    }
    
    
    var body: some View {
        
        NavigationStack {
            VStack{
                ScrollView {
                    VStack(alignment: .leading, spacing: 0.0) {
                        
                        LogoShapeView()
                        VStack(alignment: .leading){
                            Text("\(viewModel.updating ? "Updating " : "Add Meal Record")")
                                .font(.title)
                                .fontWeight(.bold)
                        }
                        .padding(.top, 25)
                        
                        
                        VStack (alignment: .leading, spacing: 20){
                            
                            DatePicker("Select a date", selection: $viewModel.date, displayedComponents: .date)
                                .accentColor(.orange)
                            
                            
                            Picker("Select a meal", selection: $viewModel.selectedMealType) {
                                
                                Text("No Option").tag(Optional<MealTypeEntity>(nil))
                                ForEach(fetchedMealTypes, id: \.self) { option in
                                    
                                    HStack{
                                        Image(uiImage: option.uiImage)
                                            .resizable()
                                            .clipShape(Circle())
                                            .scaledToFit()
                                            .frame(width: 32 , height: 32)
                                        Text("Meal: \(option.mealType)")
                                        Text(String(option.caloriesGain))
                                        
                                        
                                        
                                    }.tag(Optional(option))
                                }
                            }
                            .pickerStyle(.navigationLink)
                            .frame(height: 50)
                            
                            HStack(alignment: .center){
                                Stepper("No of Meals \(viewModel.noOfPotions) \(viewModel.noOfPotions == 1 ? "Potion" : "Potions") ", value: $viewModel.noOfPotions, in: 1...5)
                                
                            }
                            Text("Calories Gained \((viewModel.selectedMealType?.caloriesGain ?? 0.0) * Double(viewModel.noOfPotions)) Kcal")
                            
                            Divider()
                            
                            EntryField(bindingField: $viewModel.weight, placeholder: "Body Weight in Kilo Gram", promptText: viewModel.weightPrompt, isSecure: false)
                                .numberOnly($viewModel.weight, includeDecimal: true)
                                .focused($isFocused, equals: .caloriesGained)
                                .textFieldStyle(GradientTextFieldBackground(systemImageString: "scalemass", colorList: [.blue, .green]))
                                .padding(.bottom)
                            
                            
                            
                        }
                        .padding()
                    }
                    
                    
                    
                    
                }
                PrimaryActionButton(actionName: "Save Meal", icon: "plus.circle", disabled: !viewModel.incomplete){
                    print("save button clicked")
                    isFocused = nil
                    
                    if viewModel.updating{
                        print("updating")
                        if let id = viewModel.id,
                           let selectedItem = viewModel.myMealRecords.first(where: {$0.mealRecordID == id}){
                            selectedItem.recordDate = viewModel.date
                            selectedItem.totalCaloriesGained = Double(viewModel.calories) ?? 0
                            selectedItem.userEmail = user.email
                            selectedItem.weightAtRecord = Double(viewModel.weight) ?? 0.0
                            selectedItem.noOfPotions = Int16(viewModel.noOfPotions)
                            selectedItem.mealTypeID = viewModel.selectedMealType?.mealTypeID
                            selectedItem.recordID = viewModel.recordID
                            
                            if moc.hasChanges{
                                try? moc.save()
                                print("updated")
                                dismiss()
                            }
                        }else{
                            print("adding")
                            let newRecord = MealRecordEntity(context: moc)
                            newRecord.recordID = UUID()
                            newRecord.userEmail = email
                            newRecord.weightAtRecord = Double(viewModel.weight) ?? 0.0
                            newRecord.totalCaloriesGained = Double(viewModel.calories) ?? 0.0
                            newRecord.recordDate = viewModel.date
                            newRecord.noOfPotions = Int16(viewModel.noOfPotions)
                            newRecord.mealTypeID = viewModel.selectedMealType!.mealTypeID
                            try? moc.save()
                            print("saved")
                        }
                        
                        
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

struct AddMealView_Previews: PreviewProvider {
    static var previews: some View {
        AddMealView(userEmail: "bg15407@gmail.com")
            .environmentObject(MealViewModel())
    }
}
