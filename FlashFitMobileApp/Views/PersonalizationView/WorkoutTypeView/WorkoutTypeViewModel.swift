//
//  WorkoutTypeViewModel.swift
//  FlashFitMobileApp
//
//  Created by Gayan Kalinga on 2023-08-16.
//

import Foundation
import SwiftUI
import CoreData

class WorkoutTypeViewModel: ObservableObject{
    

    @Published var showAddWorkoutSheet = false
    @Published var myWorkoutTypes: [WorkoutTypeEntity] = []
    
    func predicateEmail() -> String{
        @EnvironmentObject var user: LoggedInUserModel
        return user.email!
    }
}
