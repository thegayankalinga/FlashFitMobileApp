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

    @EnvironmentObject var user: LoggedInUserModel
    @Environment(\.managedObjectContext) var moc
    
    let column = [GridItem(.adaptive(minimum: 150))]
    @StateObject private var imagePicker = ImagePicker()
    @State private var formType: WorkoutFormType?
    
    @ObservedObject var viewModel = WorkoutTypeViewModel()
    
    var body: some View {
        NavigationStack {
            
            VStack(alignment: .center) {
                Group{
                    if !viewModel.myWorkoutTypes.isEmpty{
                        //TODO: Onapear call the function
                        ScrollView{
                            LazyVGrid(columns: column, spacing: 20){
                                ForEach(viewModel.myWorkoutTypes){ type in
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
            .onAppear(perform: loadWorkoutData)
            .navigationTitle("Workout")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing){
                    Button(action: {
                        viewModel.showAddWorkoutSheet.toggle()
                        
                    }, label:{
                        if !viewModel.myWorkoutTypes.isEmpty{
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
    
    
    func loadWorkoutData(){
       
        print("Loading workout data")
        
        let fetchRequest: NSFetchRequest<WorkoutTypeEntity> = WorkoutTypeEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "userEmail == %@", user.email!)
        
        do {
            let context = moc // Replace with your actual managed object context
            let data = try context.fetch(fetchRequest)
            

                viewModel.myWorkoutTypes = data.map{$0}

            
        } catch {
            print("Error checking for value existence: \(error)")
        }
        
    }

}





struct WorkoutTypeView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutTypeView()
    }
}
