//
//  ContentView.swift
//  FlashFitMobileApp
//
//  Created by Gayan Kalinga on 2023-08-05.
//

import SwiftUI

struct ContentView: View {
    
    @State private var showPopUp = false
    @State private var selectedOption: String? = nil
    
    var body: some View {
        NavigationView {
            VStack{
                TabView{
                    HomeScreenView()
                        .tabItem{
                            Label("Home", systemImage: "house.fill")
                        }
                    WorkoutHomeView()
                        .tabItem{
                            Label("Workout", systemImage: "dumbbell.fill")
                        }
    
                    
                    PopoverView(selectedOption: $selectedOption)
                        .tabItem {
                            Label("Add", systemImage: "plus.circle.fill")
                        }
                        .sheet(isPresented: $showPopUp) {
                            PopoverView(selectedOption: $selectedOption)
                        }
                    
                    
                    MealHomeView()
                        .tabItem{
                            Label("Meal", systemImage: "cup.and.saucer.fill")
                        }
                    ReportView()
                        .tabItem{
                            Label("Report", systemImage: "doc.text.below.ecg.fill")
                        }
                }
                .padding()
            }.padding(.top)
        }
    }
}

// TODO *****
struct PopoverView: View {
    @Binding var selectedOption: String?
    
    var body: some View {
        //AddWorkoutView()
        AddMealView()
      /*  VStack {
            HStack{
                Button(action: {
                    selectedOption = "w"
                    
                }) {
                    Text("Workout")
                }
               // Spacer()
                Button(action: {
                    selectedOption = "m"
                }) {
                    Text("Meal")
                }
            }.padding()
        }
        .foregroundColor(.black)
        .frame(width: 300, height: 150)
        .background(.orange) */
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
