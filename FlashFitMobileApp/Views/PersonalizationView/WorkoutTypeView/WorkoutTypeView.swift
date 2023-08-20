//
//  WorkoutTypeView.swift
//  FlashFitMobileApp
//
//  Created by user233619 on 8/12/23.
//

import SwiftUI

struct WorkoutTypeView: View {
    //TODO: filter by email

    @FetchRequest(sortDescriptors: [])
    private var myWorkoutTypes: FetchedResults<WorkoutTypeEntity>
    
    let column = [GridItem(.adaptive(minimum: 150))]
    @StateObject private var imagePicker = ImagePicker()
    @State private var formType: WorkoutFormType?
    
    @ObservedObject var viewModel = WorkoutTypeViewModel()
    
    var body: some View {
        NavigationStack {
            
            VStack(alignment: .center) {
                Group{
                    if !myWorkoutTypes.isEmpty{
                        //TODO: Onapear call the function
                        ScrollView{
                            LazyVGrid(columns: column, spacing: 20){
                                ForEach(myWorkoutTypes){ type in
                                    Button{
                                        
                                        formType = .update(type)
                                    }label: {
                                        TypeCardView(
                                            image: type.uiImage,
                                            headingText: type.workoutName,
                                            iconName: "clock.arrow.circlepath",
                                            subtitleText: "\(type.caloriesBurned) calorie")
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                        
                    }else{
                        Text("No Workout Types Yet...")
                        Button(action: {
                            viewModel.showAddWorkoutSheet.toggle()
                        }, label:{
                            HStack{
                                Image(systemName: "plus")
                                Text("Add Workout")
                            }
                        })
                        .buttonStyle(.borderedProminent)
                        .padding()
                    }
                }
                
            }
            .navigationTitle("Workout")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing){
                    Button(action: {
                        viewModel.showAddWorkoutSheet.toggle()
                        
                    }, label:{
                        if !myWorkoutTypes.isEmpty{
                            Text("Add")
                        }
                    })
                    .sheet(isPresented: $viewModel.showAddWorkoutSheet, content: {
                        AddWorkoutTypeView(viewModel: AddWorkoutTypeViewModel(UIImage(systemName: "photo")!))
                    })
                }
//                ToolbarItem(placement: .navigationBarTrailing){
//                    PhotosPicker("New Image", selection: $imagePicker.imageSelection, matching: .images, photoLibrary: .shared())
//                }
                
                
        }
            .onChange(of: imagePicker.uiImage){ newImage in
                if let newImage {
                    formType = .new(newImage)
                }
            }
            .sheet(item: $formType){ formType in
                formType
            }
        }
    }

}


struct WorkoutTypeView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutTypeView()
    }
}
