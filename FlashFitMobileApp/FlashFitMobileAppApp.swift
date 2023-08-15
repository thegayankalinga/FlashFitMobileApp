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
            LoginView(loggedInUser: LoggedInUserModel(email: "bg15407@gmail.com", name: "Gayan Kalinga"), data: UserModel(email: "bg15407@gmail.com", name: "Gayan Kalinga", passwordSalt: "", passwordHash: "", genderType: GenderTypeEnum.Male, weightInKilos: 62, heightInCentiMeter: 165, bodyMassIndex: 20, healthStatus: HealthStatusEnum.Normalweight, createdDate: Date.now))
                .environment(\.managedObjectContext, dataController.container.viewContext)
                .onAppear{
                    print(URL.documentsDirectory.path)
                }
        }
    }
}
