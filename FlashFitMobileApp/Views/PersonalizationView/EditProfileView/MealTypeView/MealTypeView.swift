//
//  MealTypeView.swift
//  FlashFitMobileApp
//
//  Created by Gayan Kalinga on 2023-08-14.
//

import SwiftUI
import PhotosUI

struct MealTypeView: View {
    @FetchRequest(sortDescriptors: [SortDescriptor(\.mealTypeName)])
    private var myMealTypes: FetchedResults<MealTypeEntity>
    
    @StateObject private var imagePicker = ImagePicker()
    
    
    @ObservedObject var mealTypeVM = MealTypeViewModel()
    
    var body: some View {
        NavigationStack {
            
            VStack(alignment: .center) {
                Group{
                    if !myMealTypes.isEmpty{
                        
                    }else{
                        Text("No Meal Types Yet...")
                        Button(action: {
                            mealTypeVM.showAddMealSheet.toggle()
                        }, label:{
                            HStack{
                                Image(systemName: "plus")
                                Text("Add Meal")
                            }
                        })
                        .buttonStyle(.borderedProminent)
                        .padding()
                    }
                }
                
            }
            .navigationTitle("Meals")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing){
                    Button(action: {
                        mealTypeVM.showAddMealSheet.toggle()
                        
                    }, label:{
                        if !myMealTypes.isEmpty{
                            Text("Add")
                        }
                    })
                    .sheet(isPresented: $mealTypeVM.showAddMealSheet, content: {
                        AddMealTypeView(viewModel: AddMealTypeViewModel(UIImage(systemName: "photo")!))
                    })
                }
//                ToolbarItem(placement: .navigationBarTrailing){
//                    PhotosPicker("New Image", selection: $imagePicker.imageSelection, matching: .images, photoLibrary: .shared())
//                }
                
                
        }
        }
    }
}

struct MealTypeView_Previews: PreviewProvider {
    static var previews: some View {
        MealTypeView()
    }
}
