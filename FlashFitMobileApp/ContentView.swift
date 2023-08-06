//
//  ContentView.swift
//  FlashFitMobileApp
//
//  Created by Gayan Kalinga on 2023-08-05.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            TabView{
                HomeScreenView()
                    .tabItem{
                        Label("Home", systemImage: "house.fill")
                    }
                WorkoutHomeView()
                    .tabItem{
                        Label("Workout", systemImage: "heart.fill")
                    }
                HomeScreenView() // todo: popup
                    .tabItem{
                        Label("Add", systemImage: "plus.square.fill")
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
            .navigationTitle("Flash Fit")
            .toolbar{
                ToolbarItem(placement: .navigationBarTrailing){
                    Button{
                        //NavigationLink("Help", destination: HistoryView())
                    } label: {
                        Image(systemName: "questionmark.circle.fill")
                            .font(.system(.title2))
                        
                    }
                }
                
                
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
