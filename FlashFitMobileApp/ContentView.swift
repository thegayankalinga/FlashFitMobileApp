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
    @State private var sheetContentHeight = CGFloat(0)
    @EnvironmentObject var user: LoggedInUserModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        TabView(selection: $selectedTab){
    
    
                    HomeScreenView()
                        .onAppear() {
                            print("home")
                            self.previousSelectedTab = "home"
                        }
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
    
                    
            PopoverView(selectedOption: $previousSelectedTab, userEmail: user.email!)
                        .tabItem {
                            Label("Add", systemImage: "plus.circle.fill")
                        }
                        .tag("add_button")
                        .sheet(isPresented: $showPopUp) {
                            PopoverView(selectedOption: $previousSelectedTab, userEmail: user.email!)
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
                        .onAppear() {
                            print("report")
                            self.previousSelectedTab = "report"
                        }
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
            }
        }



// TODO *****
struct PopoverView: View {
    @Binding var selectedOption: String
    var userEmail: String
    
    var body: some View {
        //AddWorkoutView()
        if(selectedOption == "workouthome"){
            AddWorkoutView()
        }else if(selectedOption == "mealhome"){
            AddMealView(userEmail: userEmail)
        }else{
            AddButtonGeneralView()
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
