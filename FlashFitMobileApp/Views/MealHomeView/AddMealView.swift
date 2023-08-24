//
//  AddMealView.swift
//  FlashFitMobileApp
//
//  Created by Gayan Kalinga on 2023-08-14.
//

import SwiftUI

struct AddMealView: View {
    
    @Environment(\.managedObjectContext) var moc
    @EnvironmentObject var user: LoggedInUserModel
    
    @ObservedObject var mealVm =  MealViewModel()
    
    @State var mType: String = ""
    @State var noOfPotions: String = ""
    @State var date: Date = Date.now
    @State var calories: String = ""
    @State var weight: String = ""
    
    var body: some View {
        GeometryReader{ (proxy : GeometryProxy) in
            VStack(alignment: .trailing) {
                Image("meal")
                    .resizable()
                    .edgesIgnoringSafeArea(.top)
                    .frame(height: 220)
                
                VStack (spacing: 20){
                    DatePicker("Select a date", selection: $date, displayedComponents: .date)
                        .accentColor(.orange)
                    
                    TextField("Meal Type", text: $mType)
                        .padding(.leading)
                        .frame(height: 40)
                        .background(.gray.opacity(0.2))
                        .cornerRadius(10)
                    
                    TextField("No Of Potions", text: $noOfPotions)
                        .padding(.leading)
                        .frame(height: 40)
                        .background(.gray.opacity(0.2))
                        .cornerRadius(10)
                    
                    TextField("Calories Gained", text: $calories)
                        .padding(.leading)
                        .frame(height: 40)
                        .background(.gray.opacity(0.2))
                        .cornerRadius(10)
                    
                    TextField("Body Weight (Kg)", text: $weight)
                        .padding(.leading)
                        .frame(height: 40)
                        .background(.gray.opacity(0.2))
                        .cornerRadius(10)
                    
                    PrimaryActionButton(actionName: "Submit Meal", icon: "plus.circle", disabled: false){
                        
                        //TODO: Optional force unwrap
                        //TODO: Chnage UUID ***
                        mealVm.addMeal(moc: moc, type: UUID(), potions: Int16(noOfPotions)!, date: date, calories: calories, weight: weight, userId: user.email!)
                        mType = ""
                        noOfPotions = ""
                        date = Date()
                        calories = ""
                        weight = ""
                    }
                    
                }
                .padding()
            }
            .frame(width: proxy.size.width, height:proxy.size.height , alignment: .topLeading)
        }    }
}

struct AddMealView_Previews: PreviewProvider {
    static var previews: some View {
        AddMealView()
            .environmentObject(MealViewModel())
    }
}
