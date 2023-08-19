//
//  FlashFitMobileAppApp.swift
//  FlashFitMobileApp
//
//  Created by Gayan Kalinga on 2023-08-05.
//

import SwiftUI

@main
struct FlashFitMobileAppApp: App {
    @StateObject private var dataController = DataController()
    
    var body: some Scene {
        WindowGroup {
            LoginView(loggedInUser: LoggedInUserModel())
                .environment(\.managedObjectContext, dataController.container.viewContext)
                .onAppear{
                    print(URL.documentsDirectory.path)
                }
        }
    }
}
