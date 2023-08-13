//
//  WorkoutTypeView.swift
//  FlashFitMobileApp
//
//  Created by user233619 on 8/12/23.
//

import SwiftUI

struct WorkoutTypeView: View {
    
    @State var showSheet: Bool = false
    
    var body: some View {
        ZStack{
            Text("List of workout types")
            
        }
        .navigationTitle("Workout Types")
        .toolbar {
            Button(action: {
                showSheet.toggle()
            }, label:{
                Text("Add")
            })
            .sheet(isPresented: $showSheet, content: {
                AddWorkoutTypeView()
            })
            
        }
        
    }
}
struct WorkoutTypeView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutTypeView()
    }
}
