//
//  DataController.swift
//  FlashFitMobileApp
//
//  Created by Gayan Kalinga on 2023-08-12.
//

import CoreData
import Foundation

class DataController: ObservableObject{
    
    //Data Models
    let container = NSPersistentContainer(name: "FlashFitMobileApp")
    
    
    //Load Data
    init(){
        container.loadPersistentStores{ description, error in
            
            if let error = error{
                print("Core data failed to load: \(error.localizedDescription)")
            }
            
        }
    }
    
    
}
