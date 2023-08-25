//
//  WorkoutTypeView.swift
//  FlashFitMobileApp
//
//  Created by user233619 on 8/12/23.
//

import SwiftUI
import CoreData


struct WorkoutTypeView: View {
    //TODO: filter by email
    
    var email: String

  
    @FetchRequest(fetchRequest: WorkoutTypeEntity.fetchRequest()) var fetchedWorkoutTypes: FetchedResults<WorkoutTypeEntity>

    init(userEmail: String) {
        self.email = userEmail
        _fetchedWorkoutTypes = FetchRequest<WorkoutTypeEntity>(fetchRequest: WorkoutTypeEntity.getSpecifiedWorkoutTypes(findEmail: email))
        
    }


    @Environment(\.managedObjectContext) var moc
    @EnvironmentObject var user: LoggedInUserModel
    let column = [GridItem(.adaptive(minimum: 150))]
    @StateObject private var imagePicker = ImagePicker()
    @State private var formType: WorkoutFormType?
    
    @StateObject var viewModel = AddWorkoutTypeViewModel(UIImage(systemName: "photo")!)
    

    
    var body: some View {
       
        NavigationStack {
            
            VStack(alignment: .center) {
                Group{
                    
                    if !fetchedWorkoutTypes.isEmpty{
                        ScrollView{
                            LazyVGrid(columns: column, spacing: 20){
                                ForEach(fetchedWorkoutTypes){ type in
                                    
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
                        //.padding(.horizontal)
                        
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
//            .onAppear(perform: {
//                @FetchRequest(
//                    entity: WorkoutTypeEntity.entity(),
//                    sortDescriptors: [NSSortDescriptor(key: "calorieBurnPerMin", ascending: true)],
//                    predicate: NSPredicate(format: "userEmail == %@", userEmail)
//                ) var myWorkoutTypes: FetchedResults<WorkoutTypeEntity>
//            })
            .navigationTitle("Workout")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing){
                    Button(action: {
                        viewModel.showAddWorkoutSheet.toggle()
                        
                    }, label:{
                        if !fetchedWorkoutTypes.isEmpty{
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
        WorkoutTypeView(userEmail: "bg15407@gmail.com")
    }
}
