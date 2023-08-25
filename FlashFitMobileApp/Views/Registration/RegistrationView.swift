//
//  RegistrationView.swift
//  FlashFitMobileApp
//
//  Created by Gayan Kalinga on 2023-08-12.
//

import SwiftUI

struct RegistrationView: View {
    
    
    @ObservedObject var registrationVM = RegistrationViewModel()
    

    var body: some View {

        NavigationStack(path: $registrationVM.navigationPath) {
            
            RegistrationFirstView(registrationVM: registrationVM )
            .navigationDestination(for: Int.self) { i in
                RegistrationSecondView(registrationVM: registrationVM)
            }
            .navigationDestination(for: String.self) { _ in
                RegistrationThirdView(registrationVM: registrationVM)
            }
            
        }

    }
}

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView()
        
    }
}




