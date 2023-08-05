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
