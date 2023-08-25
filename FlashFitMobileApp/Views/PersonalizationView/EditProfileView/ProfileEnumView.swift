//
//  ProfileEnumView.swift
//  FlashFitMobileApp
//
//  Created by Gayan Kalinga on 2023-08-25.
//

import SwiftUI

enum ProfileEnumFormType: Identifiable, View{
    case new(UIImage)
    case update(UserModelEntity)
    
    var id: String{
        switch self{
        case .new:
            return "new"
        case .update:
            return "update"
        }
    }
    
    var body: some View{
        switch self{
        case .new(let uiImage):
            return EditProfileView(viewModel: EditProfileViewModel(uiImage))
        case .update(let userModelEntity):
            return  EditProfileView(viewModel: EditProfileViewModel(userModelEntity))
        }
    }
}
