//
//  ProfileHomeView.swift
//  FlashFitMobileApp
//
//  Created by user233619 on 8/6/23.
//

import SwiftUI

struct ProfileHomeView: View {
    
    @State var tabIndex = 0
    
    var body: some View {
        
        VStack {
            
            // header

            // tab view
            HStack(spacing: 0) {
                
                Text("Profile")
                    .foregroundColor(self.tabIndex == 0 ? .black: Color.black.opacity(0.7))
                    //.fontWeight(.bold)
                    .padding(.vertical, 5)
                    .padding(.horizontal, 35)
                    .background(Color.white.opacity(self.tabIndex == 0 ? 0.8 : 0))
                    .cornerRadius(5)
                    .onTapGesture {
                        self.tabIndex = 0
                    }
                
                //Spacer(minLength: 10)
                
                Text("Workout")
                    .foregroundColor(self.tabIndex == 1 ? .black: Color.black.opacity(0.7))
                    //.fontWeight(.bold)
                    .padding(.vertical, 5)
                    .padding(.horizontal, 35)
                    .background(Color.white.opacity(self.tabIndex == 1 ? 0.8 : 0))
                    .cornerRadius(5)
                    .onTapGesture {
                        self.tabIndex = 1
                    }
                
                //Spacer(minLength: 0)
                
                Text("Meal")
                    .foregroundColor(self.tabIndex == 2 ? .black: Color.black.opacity(0.7))
                    //.fontWeight(.bold)
                    .padding(.vertical, 5)
                    .padding(.horizontal, 35)
                    .background(Color.white.opacity(self.tabIndex == 2 ? 0.8 : 0))
                    .cornerRadius(5)
                    .onTapGesture {
                        self.tabIndex = 2
                    }
            }
            .padding(.vertical, 0)
            .background(Color.black.opacity(0.2))
            .cornerRadius(5)
            
            
            TabView (selection: self.$tabIndex) {
                EditProfileView()
                    .tag(0)
                
                VStack {
                    Text("Add workout UI")
                }.tag(1)
                
                VStack {
                    Text("Add meal UI")
                }.tag(2)
                
            }.tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            
            
            Spacer(minLength: 0)
        }
    }
}

struct ProfileHomeView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileHomeView()
    }
}
