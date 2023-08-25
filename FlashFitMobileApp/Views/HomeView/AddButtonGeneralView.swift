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
            
            Button(action: {
                print("add workout tapped!")
                showAddWorkout.toggle()
            }) {
                HStack {
                    Image(systemName: "dumbbell.fill")
                        .font(.title3)
                    Text("Add Workout")
                        .fontWeight(.semibold)
                        .font(.title3)
                }
                .padding()
                .foregroundColor(.white)
                .background(Color.green)
                .cornerRadius(40)
            }
            
            
            Button(action: {
                print("add meal tapped!")
                showAddMeal.toggle()
            }) {
                HStack {
                    Image(systemName: "cup.and.saucer.fill")
                        .font(.title3)
                    Text("Add Meal")
                        .fontWeight(.semibold)
                        .font(.title3)
                }
                .padding()
                .foregroundColor(.white)
                .background(Color.red)
                .cornerRadius(40)
            }
         
  
        }
        .sheet(isPresented: $showAddMeal){
            AddMealView(viewModel: MealRecordViewModel())
        }
        .sheet(isPresented: $showAddWorkout){
            AddWorkoutView(viewModel: WorkoutViewModel())
                
        }
   
    }
}

struct AddButtonGeneralView_Previews: PreviewProvider {
    static var previews: some View {
        AddButtonGeneralView()
    }
}
