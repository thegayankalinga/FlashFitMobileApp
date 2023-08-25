//
//  MealsReportView.swift
//  FlashFitMobileApp
//
//  Created by user233619 on 8/20/23.
//

import SwiftUI
import Charts

struct MealsReportView: View {
    
    @EnvironmentObject var user: LoggedInUserModel
    @Environment(\.managedObjectContext) var moc
    
    //@ObservedObject var mealVm =  MealViewModel()
    @ObservedObject var viewModel = AddMealRecordViewModel()
    
    @State var date: Date = Date()
    @State private var totalCaloriesForSelectedDate: Double = 0.0
    @State private var totalMeals: Int = 0
    @State var dailyData: [MealRecordEntity] = []
    
    var height:CGFloat = 130
    var width:CGFloat = 130
    var percent: CGFloat = 50 // total calories gained in the selected date
    
    // this value can be changed to let the user to set the target
    var avgCaloryGainPerDay = 2000.0
    
    var body: some View {
        let percent  = (totalCaloriesForSelectedDate / avgCaloryGainPerDay) * 100
        
        VStack (alignment: .leading, spacing: 20){
            
            DatePicker("Pick a date", selection: $date, displayedComponents: .date)
                .accentColor(.orange)
                .padding()
            
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 170))], spacing: 20) {
                ZStack{
                    Rectangle()
                        .frame(width: 170, height: 170)
                        .foregroundColor(Color(hex:0xFDB137))
                        .cornerRadius(10)
                    
                    VStack (alignment: .leading, spacing: 30){
                        HStack {
                            Image(systemName: "flame.fill")
                            Text("Calories Gain")
                                .font(.footnote)
                        }
                        
                        VStack (alignment: .leading, spacing: 3){
                            HStack{
                                Text("\(totalCaloriesForSelectedDate, specifier: "%.2f")")
                                    .font(.subheadline)
                                    .fontWeight(.bold)
                                Text("K/Cal")
                                    .font(.footnote)
                                    .foregroundColor(.secondary)
                                    .fontWeight(.semibold)
                            }
                        }
                    }
                }
                .foregroundColor(.black)
                
                ZStack{
                    Rectangle()
                        .frame(width: 170, height: 170)
                        .foregroundColor(Color(hex:0xFDB137))
                        .cornerRadius(10)
                    
                    VStack (alignment: .leading, spacing: 30){
                        HStack {
                            Image(systemName: "cup.and.saucer.fill")
                            Text("No of Meals")
                                .font(.footnote)
                        }
                        
                        VStack (alignment: .leading, spacing: 3){
                            HStack{
                                Text("\(totalMeals)")
                                    .font(.subheadline)
                                    .fontWeight(.bold)
                                Text("Meal")
                                    .font(.footnote)
                                    .foregroundColor(.secondary)
                                    .fontWeight(.semibold)
                            }
                        }
                    }
                }
                .foregroundColor(.black)
            }
            
            // summary
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
                        BarMark(x: .value("Meal ", "day.mealTypeID" ?? ""), //TODO: meal type name
                                y: .value("Calories (kcal)", day.totalCaloriesGained)
                        )
                        .foregroundStyle(Color.orange)
                        .cornerRadius(6)
                    }
                }
                .frame(height: 150)
                .chartXAxis {
                    /* AxisMarks(values: mealVm.savedDailyMeals.map {$0.mealTypeID ?? UUID}) { type in //TODO:                             AxisValueLabel()
                     } */
                    AxisMarks(values: viewModel.savedDailyMeals.map {_ in "mealid" ?? "Unknown"}) { type in
                        AxisValueLabel()
                    }
                }
            }
            .frame(height: 200)
            .cornerRadius(10)
            .padding(.bottom, 10)
        }
        .onAppear {
            getTotalCalories()
            getTotalMeals()
            getSummaryData()        
        }
        .onChange(of: date) { newValue in
            getTotalCalories()
            getTotalMeals()
            getSummaryData()            
        }
    }
    
    // calculate total calories burnt in a given week
    func getTotalCalories() {
        totalCaloriesForSelectedDate = viewModel.getCaloriesForByDay(moc, userId: user.email!, date: date)
    }
    
    func getSummaryData() {
        viewModel.getDailyMeals(moc, userId: user.email!, date: date)
    }
    
    func getTotalMeals() {
        totalMeals = viewModel.getTotalMealsByDay(moc, userId: user.email!, date: date)
    }
}

struct MealsReportView_Previews: PreviewProvider {
    static var previews: some View {
        MealsReportView()
    }
}
