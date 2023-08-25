//
//  ContentView.swift
//  FlashFitMobileApp
//
//  Created by Gayan Kalinga on 2023-08-05.
//

import SwiftUI

struct ContentView: View {
    
    @State private var showPopUp = false
    //@State private var selectedOption: String? = nil
    @State private var selectedTab: String = "home"
    @State private var previousSelectedTab: String = "pd"
    
    var body: some View {
        NavigationView {
            VStack{
                TabView(selection: $selectedTab){
                    HomeScreenView()
                        .tabItem{
                            Label("Home", systemImage: "house.fill")
                        }
                        .tag("home")
                    
                    
                    WorkoutHomeView()
                        .onAppear() {
                            print("workout tapped")
                            self.previousSelectedTab = "workouthome"
                        }
                        .tabItem{
                            Label("Workout", systemImage: "dumbbell.fill")
                                
                        }
                        .tag("workouthome")
    
                    
                    PopoverView(selectedOption: $previousSelectedTab)
                        .tabItem {
                            Label("Add", systemImage: "plus.circle.fill")
                        }
                        .tag("add_button")
                        .sheet(isPresented: $showPopUp) {
                            PopoverView(selectedOption: $previousSelectedTab)
                        }
                    
                    
                    MealHomeView()
                        .onAppear() {
                            print("meal tapped")
                            self.previousSelectedTab = "mealhome"
                        }
                        .tabItem{
                            Label("Meal", systemImage: "cup.and.saucer.fill")
                        }
                        .tag("mealhome")
                    ReportView()
                        .tabItem{
                            Label("Report", systemImage: "doc.text.below.ecg.fill")
                        }
                        .tag("report")
                }
                .onChange(of: selectedTab){ value in
                    print("previousSelectedTab: \(previousSelectedTab)")
                    print(value)
                    selectedTab = value
                }
                .padding()
            }.padding(.top)
        }
    }
}

// TODO *****
struct PopoverView: View {
    @Binding var selectedOption: String
    
    var body: some View {
        //AddWorkoutView()
        if(selectedOption == "workouthome"){
            AddWorkoutView()
        }else if(selectedOption == "mealhome"){
            AddMealView()
        }else{
            AddMealView()
        }
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
