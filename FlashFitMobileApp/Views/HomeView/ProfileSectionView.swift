//
//  ProfileSectionView.swift
//  FlashFitMobileApp
//
//  Created by user233619 on 8/6/23.
//

import SwiftUI

struct ProfileSectionView: View {
    
    @EnvironmentObject var user: LoggedInUserModel
    
    var body: some View {
        HStack {
            NavigationLink(destination: ProfileHomeView( viewModel: EditProfileViewModel(UIImage(imageLiteralResourceName: "profile picture")))) {
                
                Image(uiImage: user.userImage ?? UIImage(imageLiteralResourceName: "profile picture"))
                    .resizable()
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
                    .padding(.trailing, 2)
            }
            
            VStack(alignment: .leading) {
                Text(user.name!) //todo: from db
                    .font(.subheadline)
                    .fontWeight(.bold)
                
                Text(getTodayDate())
                    .font(.caption)
            }
            
            Spacer()
            
        }
    }
    
    func getTodayDate() -> String{
        let format = DateFormatter()
        format.dateFormat = "MMMM d, yyyy"
        let today = Date()
        return format.string(from: today)
    }
}

struct ProfileSectionView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileSectionView()
    }
}
