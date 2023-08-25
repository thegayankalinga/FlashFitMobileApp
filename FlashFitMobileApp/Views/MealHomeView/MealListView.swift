//
//  MealListView.swift
//  FlashFitMobileApp
//
//  Created by Gayan Kalinga on 2023-08-14.
//

import SwiftUI

struct MealListView: View {
    
    @EnvironmentObject var user: LoggedInUserModel
    @Environment(\.managedObjectContext) var moc
    
    @ObservedObject var mealVm =  MealViewModel()
    
    var body: some View {
        
        VStack (alignment: .center){

            List{
                ForEach(mealVm.savedMeals) { entity in
                    NavigationLink(destination: EditMealView(entity: entity)) {
                        HStack {
                            VStack{
                                Text("\(dateFormatted(date: entity.recordDate ?? Date.now))")
                                VStack (alignment: .leading, spacing: 5) {
                                    
                                    HStack (spacing: 4){ // meal type
                                        Text("Meal Type")
                                        Spacer()
                                        HStack {
                                            Text("No type name")
                                        }
                                    }
                                                                    
                                    HStack (spacing: 4){ // calories
                                        Text("Caories Gained")
                                        Spacer()
                                        HStack {
                                            Text("\((entity.caloriesGainTotal), specifier: "%.2f")")
                                            Text("K/Cal")
                                                .font(.footnote)
                                                .foregroundColor(.secondary)
                                                .fontWeight(.semibold)
                                        }
                                    }
                                    .padding(.bottom, 2)
                                    
                                    HStack(spacing: 4) { // potions
                                        Text("No of Potions")
                                        Spacer()
                                        Text("\(Int(entity.noOfPotions))")
                                    }
                                }
                            }
                            .font(.caption)
                        }
                    }
                    //}
                    
                }
                .onDelete(perform: { indexSet in

                    mealVm.deleteMeal(moc, indexSet: indexSet, userId: user.email!)
                })
            }
            .onAppear(perform : {
                mealVm.getMeals(moc, userId: user.email!)
            })
            
            var groupedWorkouts: [String: [MealRecordEntity]] {
                Dictionary(grouping: mealVm.savedMeals) { entity in
                    entity.mealTypeID?.uuidString ?? UUID().uuidString
                }
            }
        }
        .navigationTitle("Meal Summery")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    func dateFormatted(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        return dateFormatter.string(from: date)
    }
}

struct MealListView_Previews: PreviewProvider {
    static var previews: some View {
        MealListView()
            .environmentObject(MealViewModel())
    }
}
