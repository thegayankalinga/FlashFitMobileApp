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
        VStack(alignment: .center ,spacing: 20) {
            Text("Select Type to Add")
                .font(.headline)
                .padding(.top, 20)
            HStack{
             
                Button(action: {
                    print("add workout tapped!")
                    showAddWorkout.toggle()
                }) {
                    HStack {
                        Image(systemName: "dumbbell.fill")
                            .font(.title3)
                        Text("Workout")
                            .fontWeight(.semibold)
                            .font(.title3)
                    }
                    .padding()
                    .foregroundColor(.white)
                    .frame(width: 180)
                    .background(CustomColors.primaryColor)
                    .cornerRadius(40)
                    
                }
                
                
                
                Button(action: {
                    print("add meal tapped!")
                    showAddMeal.toggle()
                }) {
                    HStack {
                        Image(systemName: "cup.and.saucer.fill")
                            .font(.title3)
                        Text("Meal")
                            .fontWeight(.semibold)
                            .font(.title3)
                    }
                    .padding()
                    .foregroundColor(.white)
                    .frame(width: 180)
                    .background(CustomColors.secondaryColor)
                    .cornerRadius(40)
                    .frame(width: 180)
                }
                
                
             
      
            }
            
            .edgesIgnoringSafeArea(.all)
            .padding()
            

            .sheet(isPresented: $showAddMeal){
                AddMealView(viewModel: MealRecordViewModel())
            }
            .sheet(isPresented: $showAddWorkout){
                AddWorkoutView(viewModel: WorkoutViewModel())
                    
        }
        }
        .padding(40)
        .background(LinearGradient(colors: [CustomColors.backgroundGray, CustomColors.gradientLower], startPoint: .topLeading, endPoint: .bottomTrailing))
   
    }
}

struct AddButtonGeneralView_Previews: PreviewProvider {
    static var previews: some View {
        AddButtonGeneralView()
    }
}
