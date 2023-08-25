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
    
    @ObservedObject var viewModel: MealRecordViewModel
    @State private var showAlert = false
    @FocusState private var isFocused: FocusedField?
    
    enum FocusedField{
        case caloriesGained, weight    
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
                        
                        LogoShapeView()
                        VStack(alignment: .leading){
                            Text("\(viewModel.updating ? "Updating " : "Add Meal Record")")
                                .font(.title)
                                .fontWeight(.bold)
                        }
                        .padding(.top, 25)
                        .padding(.leading, 25)
                        
                        
                        VStack (alignment: .leading, spacing: 20){
                            
                            DatePicker("Select a date", selection: $viewModel.date, displayedComponents: .date)
                                .accentColor(.orange)
                            
                            
                            VStack{
                                Picker("Select a meal", selection: $viewModel.selectedMealType) {
                                    Text("Select Value").tag(nil as MealTypeEntity?)
                                    ForEach(viewModel.myMealTypes) { option in
                                        HStack{
                                            Image(uiImage: option.uiImage)
                                                .resizable()
                                                .clipShape(Circle())
                                                .scaledToFit()
                                                .frame(width: 32 , height: 32)
                                            Text("Meal: \(option.mealType)")
                                            Text(String(option.caloriesGain))
                                        }.tag(option as MealTypeEntity?)
                                    }
                                }
                                .pickerStyle(.navigationLink)
                                .frame(height: 50)
                            }
                            .onAppear(perform: {
                                //print("Appear")
                                //print(viewModel.selectedMealType)
                                viewModel.getAllMealTypes(email: user.email!, moc: moc)
                                if(!viewModel.updating){
                                    viewModel.calTotalCalories(moc: moc)
                                }
                                if (viewModel.updating){
                                    print("updating")
                                    viewModel.getMealTypeByUUID(moc: moc)
                                    viewModel.getMealTypeByUUID(moc: moc)
                                    
                                }
                            })
                            
                            
                            HStack(alignment: .center){
                                Stepper("No of Meals \(viewModel.noOfPotions) \(viewModel.noOfPotions == 1 ? "Potion" : "Potions") ", value: $viewModel.noOfPotions, in: 1...5){ value in
                                    print(viewModel.noOfPotions)
                                    viewModel.calTotalCalories(moc: moc)
                                }
      
                            }
                            
                            EntryField(bindingField: $viewModel.totalCalories, placeholder: "Total Calories Gained", promptText: "", isSecure: false)
                                .numberOnly($viewModel.totalCalories, includeDecimal: true)
                                .focused($isFocused, equals: .caloriesGained)
                                .textFieldStyle(GradientTextFieldBackground(systemImageString: "mouth", colorList: [.blue, .green]))
                                .padding(.bottom)
                                
                            
                            Divider()
                            
                            EntryField(bindingField: $viewModel.weight, placeholder: "Body Weight in Kilo Gram", promptText: viewModel.weightPrompt, isSecure: false)
                                .numberOnly($viewModel.weight, includeDecimal: true)
                                .focused($isFocused, equals: .weight)
                                .textFieldStyle(GradientTextFieldBackground(systemImageString: "scalemass", colorList: [.blue, .green]))
                                .padding(.bottom)
                            
                            if(!viewModel.updating){
                                Divider()
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
                    actionName: "Save Meal",
                    icon: "plus.circle",
                    disabled: !viewModel.incomplete)
                {
  
                    isFocused = nil
             
                    viewModel.getAllMealRecordsByEmail(email: user.email!, moc: moc)
                        
                    if viewModel.updating{
                        print("updating")
                        print(viewModel.myMealRecords)
                        if let id = viewModel.recordID,
                           let selectedItem = viewModel.myMealRecords.first(where: {$0.mealRecordID == id}){
                            
                            print(selectedItem)
                            selectedItem.recordDate = viewModel.date
                            selectedItem.totalCaloriesGained = Double(viewModel.totalCalories) ?? 0
                            selectedItem.userEmail = user.email
                            selectedItem.weightAtRecord = Double(viewModel.weight) ?? 0.0
                            selectedItem.noOfPotions = Int16(viewModel.noOfPotions)
                            selectedItem.mealTypeID = viewModel.selectedMealType?.mealTypeID
                            selectedItem.mealTypeName = viewModel.selectedMealType?.mealTypeName
                            selectedItem.recordID = viewModel.recordID
                        }
                            
                            if moc.hasChanges{
                                try? moc.save()
                                print("updated")
                                dismiss()
                            }
                        }else{
                            print(viewModel.totalCalories)
                            let newRecord = MealRecordEntity(context: moc)
                            newRecord.recordID = UUID()
                            newRecord.mealTypeName = viewModel.selectedMealType?.mealTypeName
                            newRecord.userEmail = user.email!
                            newRecord.weightAtRecord = Double(viewModel.weight) ?? 0.0
                            newRecord.totalCaloriesGained = Double(viewModel.totalCalories) ?? 0.0
                            newRecord.recordDate = viewModel.date
                            newRecord.noOfPotions = Int16(viewModel.noOfPotions)
                            newRecord.mealTypeID = viewModel.selectedMealType!.mealTypeID
                            try? moc.save()
                            print("saved new")
                        }
                    
                    if(!viewModel.isAddMoreChecked){
                        dismiss()
                    }else{
                        viewModel.noOfPotions = 1
                        viewModel.date = Date.now
                        viewModel.totalCalories = ""
                        viewModel.weight = ""
                        viewModel.selectedMealType = nil
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
                            viewModel.getAllMealRecordsByEmail(email: user.email!, moc: moc)
                            if let id = viewModel.id,
                               let selectedItem = viewModel.myMealRecords.first(where: {$0.mealRecordID == id}){
                                
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

struct AddMealView_Previews: PreviewProvider {
    static var previews: some View {
        AddMealView(viewModel: MealRecordViewModel())
    }
}
