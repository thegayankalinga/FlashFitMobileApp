//
//  AddMealView.swift
//  FlashFitMobileApp
//
//  Created by Gayan Kalinga on 2023-08-14.
//

import SwiftUI
import UIKit

struct AddMealView: View {
    
    var email: String

    @FetchRequest(fetchRequest: MealTypeEntity.fetchRequest()) var fetchedMealTypes: FetchedResults<MealTypeEntity>

    init(userEmail: String) {
        self.email = userEmail
        _fetchedMealTypes = FetchRequest<MealTypeEntity>(fetchRequest: MealTypeEntity.getSpecifiedMealsTypes(findEmail: email))
     
    }
    
    @Environment(\.managedObjectContext) var moc
    @EnvironmentObject var user: LoggedInUserModel
    @Environment(\.dismiss) var dismiss
    @ObservedObject var mealVm =  MealViewModel()
    
    @State var mType: String = ""
    @State var noOfPotions: Int = 1
    @State var date: Date = Date.now
    @State var calories: String = ""
    @State var weight: String = ""
    @State var updating = false
    @State var selectedMealType: MealTypeEntity?
    
    
    @FocusState private var isFocused: FocusedField?
    
    enum FocusedField{
        case mealTypeName, caloriesGained
        
    }
    
    let formatter: NumberFormatter = {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            return formatter
        }()
    
    var body: some View {
       
            NavigationStack {
                

    

                ScrollView {
                    VStack(alignment: .leading, spacing: 0.0) {
                                
                                LogoShapeView()
                                VStack(alignment: .leading){
                                    Text("\(updating ? "Updating " : "Add Meal Record")")
                                        .font(.title)
                                        .fontWeight(.bold)
                                }
                                .padding(.top, 25)
                 
                                
                                VStack (alignment: .leading, spacing: 20){
                                    
                                        DatePicker("Select a date", selection: $date, displayedComponents: .date)
                                            .accentColor(.orange)
                                    //items, id: \.value
                                    
                                        Picker("Select a meal", selection: $selectedMealType) {
                                            
                                            Text("No Option").tag(Optional<MealTypeEntity>(nil))
                                            ForEach(fetchedMealTypes, id: \.self) { option in
                                                // 2
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
                                        Stepper("No of Meals \(noOfPotions) \(noOfPotions == 1 ? "Potion" : "Potions") ", value: $noOfPotions, in: 1...5)
                    
                                        }
                                    Text("Calories Gained \((selectedMealType?.caloriesGain ?? 0.0) * Double(noOfPotions)) Kcal")
                                        
                                    Divider()
                                    
                                    EntryField(bindingField: $weight, placeholder: "Body Weight in Kilo Gram", promptText: "", isSecure: false)
                                        .numberOnly($weight, includeDecimal: true)
                                        .focused($isFocused, equals: .caloriesGained)
                                        .textFieldStyle(GradientTextFieldBackground(systemImageString: "scalemass", colorList: [.blue, .green]))
                                        .padding(.bottom)
                                    
                                   
                                    
                                }
                                .padding()
                            }
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
                            
     
                        .edgesIgnoringSafeArea(.all)
                }
                PrimaryActionButton(actionName: "Save Meal", icon: "plus.circle", disabled: false){
                        print(selectedMealType)
                    //TODO: Optional force unwrap
                    //TODO: Chnage UUID ***
//                    mealVm.addMeal(moc: moc, type: UUID(), potions: Int16(noOfPotions)!, date: date, calories: calories, weight: weight, userId: user.email!)
//                    mType = ""
//                    noOfPotions = ""
//                    date = Date()
//                    calories = ""
//                    weight = ""
                }.padding(.bottom, 25)
          
            }
            }
}

struct AddMealView_Previews: PreviewProvider {
    static var previews: some View {
        AddMealView(userEmail: "bg15407@gmail.com")
            .environmentObject(MealViewModel())
    }
}
