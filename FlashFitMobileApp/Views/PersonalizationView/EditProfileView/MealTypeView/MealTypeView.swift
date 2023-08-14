//
//  MealTypeView.swift
//  FlashFitMobileApp
//
//  Created by Gayan Kalinga on 2023-08-14.
//

import SwiftUI

struct MealTypeView: View {
    
    @ObservedObject var mealTypeVM = MealTypeViewModel()
    
    var body: some View {
        ZStack{
            Text("List of workout types")
            
        }
        .navigationTitle("Workout Types")
        .toolbar {
            Button(action: {
                mealTypeVM.showAddMealSheet.toggle()
            }, label:{
                Text("Add")
            })
            .sheet(isPresented: $mealTypeVM.showAddMealSheet, content: {
                AddMealTypeView()
            })
            
        }
    }
}

struct MealTypeView_Previews: PreviewProvider {
    static var previews: some View {
        MealTypeView()
    }
}
