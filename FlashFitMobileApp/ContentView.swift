//
//  ContentView.swift
//  FlashFitMobileApp
//
//  Created by Gayan Kalinga on 2023-08-05.
//

import SwiftUI

struct ContentView: View {
    
    @State private var showPopUp = false
    @State private var showMealAddSheet = false
    @State private var showWorkoutAddSheet = false
    //@State private var selectedOption: String? = nil
    @State private var selectedTab: String = "home"
    @State private var previousSelectedTab: String = "pd"
    @State private var sheetContentHeight = CGFloat(0)
    @EnvironmentObject var user: LoggedInUserModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView{
            VStack{
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
                    
                    
                    HomeScreenView()
                        .tabItem {
                            Label("Add", systemImage: "plus.circle.fill")
                        }
                        .tag("add_button")
                    
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
                    
                    if (selectedTab == "add_button" && previousSelectedTab == "mealhome"){
                        self.showMealAddSheet.toggle()
                    }else if (selectedTab == "add_button" && previousSelectedTab == "workouthome"){
                        self.showWorkoutAddSheet.toggle()
                    }else if selectedTab == "add_button"{
                        self.showPopUp.toggle()
                    }
                    print("previousSelectedTab: \(previousSelectedTab)")
                    print(value)
                    selectedTab = value
                }
            }
            .sheet(isPresented: $showMealAddSheet, onDismiss: {
                self.selectedTab = previousSelectedTab
            }) {
                AddMealView(viewModel: MealRecordViewModel())
            }
            .sheet(isPresented: $showWorkoutAddSheet, onDismiss: {
                self.selectedTab = previousSelectedTab
                
            }) {
                AddWorkoutView(viewModel: WorkoutViewModel())
                    
            }
            .sheet(isPresented: $showPopUp, onDismiss: {
                self.selectedTab = previousSelectedTab
                
            }) {
                AddButtonGeneralView()
                    .presentationDetents([.height(150), .fraction(0.2)])
            }
            .padding()
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
