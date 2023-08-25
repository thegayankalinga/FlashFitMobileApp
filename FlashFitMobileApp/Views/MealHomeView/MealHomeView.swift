//
//  MealHomeView.swift
//  FlashFitMobileApp
//
//  Created by user233619 on 8/6/23.
//

import SwiftUI
import Charts
import CoreData

struct MealHomeView: View {
    
    @EnvironmentObject var user: LoggedInUserModel
    @Environment(\.managedObjectContext) var moc
    
    //@ObservedObject var mealVm =  MealViewModel()
    @ObservedObject var viewModel =  MealRecordViewModel()
    @State var date: Date = Date()
    @State private var totalCaloriesForSelectedDate: Double = 0.0
    @State var dailyData: [MealRecordEntity] = []
    
    var height:CGFloat = 130
    var width:CGFloat = 130
    var percent: CGFloat = 50 // total calories gained in the selected date
    
    // this value can be changed to let the user to set the target
    var avgCaloryGainPerDay = 2000.0
    
    var columns = Array(repeating: GridItem(.flexible(), spacing: 20), count: 2)
    
    var body: some View {
        let percent  = (totalCaloriesForSelectedDate / avgCaloryGainPerDay) * 100
        let progress = 1 - (percent / 100)
        
        VStack (alignment: .leading){
            Text("Meal Summary")
                .font(.title3).bold()
                .padding(.leading)
            
            DatePicker("Pick a date", selection: $date, displayedComponents: .date)
                .accentColor(.orange)
                .padding()
            
            // progress
            VStack(alignment: .leading){
                HStack{
                    Image(systemName: "flame.fill")
                    Text("Gained Calories")
                        .font(.footnote)
                        .padding(.bottom, 1)
                }
                
                ZStack {
                    Color(hex:0xFDB137)
                    ZStack{
                        Circle()
                            .stroke(Color.white ,style: StrokeStyle(lineWidth: 8))
                            .frame(width: width, height: height)
                        Circle()
                            .trim(from: CGFloat(progress), to: 1)
                            .stroke(Color.orange, style: StrokeStyle(lineWidth: 8, lineCap: .round, lineJoin: .round, miterLimit: .infinity, dash: [20,0], dashPhase: 0))
                            .rotationEffect(.degrees(90))
                            .rotation3DEffect(.degrees(180), axis: (x: 1, y: 0, z: 0))
                            .frame(width: width, height: height)
                        VStack{
                            Text("\(totalCaloriesForSelectedDate, specifier: "%.1f")").font(.title2).bold()
                            Text("K/Cal").font(.caption).bold().padding(0.5)
                        }
                    }
                    
                }
                .frame(height: 200)
                .cornerRadius(10)
                .padding(.bottom, 10)
                
            }
            // summary
            VStack (alignment: .leading){
                HStack{
                    Image(systemName: "flame.fill")
                    Text("Daily Activity")
                        .font(.footnote)
                        .padding(.bottom, 1)
                }
                
                ZStack {
                    Color(hex:0xF5F5F5)
                    Chart {
                        ForEach(viewModel.savedDailyMeals) { day in
                            BarMark(x: .value("Meal",
                                              day.mealTypeNameFromRecord),
                                    y: .value("Calories (kcal)", day.totalCaloriesGained)
                            )
                            .foregroundStyle(Color.orange)
                            .cornerRadius(6)
                        }
                    }
                    .frame(height: 150)
                    .chartXAxis {
                     
                        AxisMarks(values: viewModel.savedDailyMeals.map {$0.mealTypeNameFromRecord}) { type in
                            AxisValueLabel()
                        }
                    }
                }
                .frame(height: 200)
                .cornerRadius(10)
                .padding(.bottom, 10)
            }
            
            NavigationLink("Update Recorded Meals", destination: MealListView(viewModel: MealRecordViewModel()).accentColor(.orange))
        }
        .navigationTitle("Meals")
        .onAppear {
            getTotalCalories()
            getSummaryData()
            viewModel.getAllMealTypes(email: user.email!, moc: moc)
           
        }
        .onChange(of: date) { newValue in
            getTotalCalories()
            getSummaryData()
        }
        
    }
    
    // calculate total calories burnt in a given date
    func getTotalCalories() {
        totalCaloriesForSelectedDate = viewModel.getCaloriesForByDay(moc, userId: user.email!, date: date)
        print("Calories", totalCaloriesForSelectedDate)
    }
    
    func getSummaryData() {
        viewModel.getDailyMeals(moc, userId: user.email!, date: date)
    }
    
}

struct MealHomeView_Previews: PreviewProvider {
    static var previews: some View {
        MealHomeView()
    }
}
