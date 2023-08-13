//
//  AddWorkoutTypeView.swift
//  FlashFitMobileApp
//
//  Created by user233619 on 8/12/23.
//

import SwiftUI

struct AddWorkoutTypeView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack{
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }, label: {
                Image(systemName: "xmark")
                    .font(.body)
                    .foregroundColor(.black)
            })
                       
            Text("add form")
        }
        .toolbar{
            ToolbarItem(placement: .navigationBarTrailing){
                Button{
                    //NavigationLink("Help", destination: HelpView())
                } label: {
                    Image(systemName: "xmark")
                        .foregroundColor(.black)
                        .font(.system(.title2))
                }
            }
        }
        .padding()
    }
}

struct AddWorkoutTypeView_Previews: PreviewProvider {
    static var previews: some View {
        AddWorkoutTypeView()
    }
}
