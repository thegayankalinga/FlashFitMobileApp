//
//  EditMealView.swift
//  FlashFitMobileApp
//
//  Created by Gayan Kalinga on 2023-08-14.
//

import SwiftUI

struct EditMealView: View {
    
    @EnvironmentObject var user: LoggedInUserModel
    @Environment(\.managedObjectContext) var moc
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject var mealVm =  MealViewModel()
    
    @State private var id: UUID
    @State private var userId: String = ""
    @State private var mType: UUID
    @State private var potions: String = ""
    @State private var date: Date = Date.now
    @State private var calories: String = ""
    @State private var weight: String = ""
    
    @State var tempVar: String = "change this"
    
    var entity: MealRecordEntity
    
    init(entity: MealRecordEntity) {
        self.entity = entity
        _id = State(initialValue: entity.recordID ?? UUID())
        _userId = State(initialValue: entity.userEmail!)
        _mType = State(initialValue: entity.mealTypeID!)
        _potions = State(initialValue: String(entity.noOfPotions))
        _date = State(initialValue: entity.recordDate ?? Date())
        _weight = State(initialValue: String(entity.weightAtRecord))
        _calories = State(initialValue: String(entity.totalCaloriesGained))
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

            TextField("Meal Type Name", text: $tempVar) //TODO: Set meal type name
                .padding(.leading)
                .frame(height: 40)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
            
            TextField("No of Potions", text: $potions)
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
                entity.recordID = id
                entity.userEmail = userId
                entity.noOfPotions = Int16(potions) ?? 0
                entity.recordDate = date
                entity.mealTypeID = mType //TODO: set meal type
                entity.totalCaloriesGained = Double(calories) ?? 0.0
                entity.weightAtRecord = Double(weight) ?? 0.0
                
                mealVm.updateMeal(moc, entity: self.entity)
                
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
        .navigationTitle("Update Meal")
    }
}

struct EditMealView_Previews: PreviewProvider {
    static var previews: some View {
        EditMealView(entity: MealRecordEntity())
            .environmentObject(MealViewModel())
    }
}
