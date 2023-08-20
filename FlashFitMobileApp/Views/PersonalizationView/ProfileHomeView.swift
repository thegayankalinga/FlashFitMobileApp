//
//  ProfileHomeView.swift
//  FlashFitMobileApp
//
//  Created by user233619 on 8/6/23.
//

import SwiftUI

struct ProfileHomeView: View {
    
    @State private var tabIndex = 0
    @EnvironmentObject var user: LoggedInUserModel


    var body: some View {
        
        NavigationStack {
            VStack {
                // tab view
                Picker(selection: $tabIndex, label: Text("")) {
                    Text("Profile").tag(0)
                    Text("Workout").tag(1)
                    Text("Meal").tag(2)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                switch tabIndex {
                case 0:
                    EditProfileView()
                case 1:
                   // todo
                    WorkoutTypeView(userEmail: user.email!)
                case 2:
                    //todo
                    MealTypeView()
                default:
                    EmptyView()
                }
      
                Spacer(minLength: 0)
            }
            .environmentObject(user)
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
            .padding(.top, 20)
        .background(Color(UIColor.secondarySystemBackground))
        }
        //.background(Color(#colorLiteral(red: 0.9607843137, green: 0.9607843137, blue: 0.9607843137, alpha: 1))) // #F5F5F5
        
    }
}

struct ProfileHomeView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileHomeView()
    }
}
