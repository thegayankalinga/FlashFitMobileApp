//
//  MealTypeView.swift
//  FlashFitMobileApp
//
//  Created by Gayan Kalinga on 2023-08-14.
//

import SwiftUI
import PhotosUI
import UIKit

struct MealTypeView: View {
    //TODO: filter by email
    @FetchRequest(sortDescriptors: [SortDescriptor(\.mealTypeName)])
    private var myMealTypes: FetchedResults<MealTypeEntity>
    let column = [GridItem(.adaptive(minimum: 150))]
    @StateObject private var imagePicker = ImagePicker()
    @State private var formType: FormType?
    
    @ObservedObject var mealTypeVM = MealTypeViewModel()
    
    var body: some View {
        NavigationStack {
            
            VStack(alignment: .center) {
                Group{
                    if !myMealTypes.isEmpty{
                        //TODO: Onapear call the function
                        ScrollView{
                            LazyVGrid(columns: column, spacing: 20){
                                ForEach(myMealTypes){ mealType in
                                    Button{
                                        
                                        formType = .update(mealType)
                                    }label: {
                                        TypeCardView(
                                            image: mealType.uiImage,
                                            headingText: mealType.mealType,
                                            iconName: "clock.arrow.circlepath",
                                            subtitleText: "\(mealType.caloriesGain) calorie")
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                        
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

struct MealTypeView_Previews: PreviewProvider {
    static var previews: some View {
        MealTypeView(mealTypeVM: MealTypeViewModel())
    }
}

struct TypeCardView: View{
    
    var image: UIImage
    var headingText: String
    var iconName: String
    var subtitleText: String
    
    var body: some View{
        VStack(alignment: .leading, spacing: 16){
            Image(uiImage: image)
                .resizable()
                .frame(width: 150 , height: 100)
            cardText.padding(.horizontal, 8)
        }
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 24.0))
        .shadow(radius: 8)
    }
    
    
    var cardText: some View{
        VStack(alignment: .leading){
            Text(headingText)
                .font(.headline)
            HStack(spacing: 4.0){
                Image(systemName: iconName)
                Text(subtitleText)
                    .font(.caption2)
            }.foregroundColor(.gray)
                .padding(.bottom, 16)
        }
    }
}

struct TypeCardView_Previews: PreviewProvider {
    static var previews: some View {
        TypeCardView(image: UIImage(systemName: "photo")!, headingText: "Running", iconName: "clock.arrow.circlepath", subtitleText: "50 Calories")
    }
}
