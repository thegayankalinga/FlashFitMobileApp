//
//  WorkoutTypeViewModel.swift
//  FlashFitMobileApp
//
//  Created by Gayan Kalinga on 2023-08-16.
//

import Foundation
import SwiftUI

class WorkoutTypeViewModel: ObservableObject{
    

    @Published var showAddWorkoutSheet = false
    @Published var myWorkoutTypes: [WorkoutTypeEntity] = []
    
 
}
