//
//  AddMealTypeView.swift
//  FlashFitMobileApp
//
//  Created by Gayan Kalinga on 2023-08-14.
//

import SwiftUI

struct AddMealTypeView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                VStack(alignment: .leading){
                    Image("morning-workout")
                        .resizable()
                        .frame(width: 200, height: 200)
                    
                }
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 24.0))
                .shadow(radius: 8)
                
                
            }
            .clipShape(RoundedRectangle(cornerRadius: 24.0))
            .shadow(radius: 8)
            .padding(30)
                .navigationTitle("Add Meal Type")
                .toolbar(content: {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        SheetCloseButton(disabled: false){
                                    dismiss()
                                }
                    }
            })
        }
    }
}

struct AddMealTypeView_Previews: PreviewProvider {
    static var previews: some View {
        AddMealTypeView()
    }
}

