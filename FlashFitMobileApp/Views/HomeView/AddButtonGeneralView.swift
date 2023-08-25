//
//  AddButtonGeneralView.swift
//  FlashFitMobileApp
//
//  Created by Gayan Kalinga on 2023-08-25.
//

import Foundation
import SwiftUI

struct AddButtonGeneralView: View{
    @EnvironmentObject var user: LoggedInUserModel
    @State private var showAddMeal = false
    @State private var showAddWorkout = false
 
    
    var body: some View{
        HStack{
            Button("Workout"){
                
                showAddWorkout.toggle()
                
            }
            Button("Meal"){
                
                showAddMeal.toggle()

            }
        }
        .sheet(isPresented: $showAddMeal){
            AddMealView(userEmail: user.email!)
        }
        .sheet(isPresented: $showAddWorkout){
            AddWorkoutView()
                
        }
   
    }
}
