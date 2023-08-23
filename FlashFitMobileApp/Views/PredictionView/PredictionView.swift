//
//  PredictionView.swift
//  FlashFitMobileApp
//
//  Created by user233619 on 8/6/23.
//

import CoreML
import SwiftUI

struct PredictionView: View {
    
    @EnvironmentObject var user: LoggedInUserModel
    @Environment(\.managedObjectContext) var moc
    @ObservedObject var workoutVm =  WorkoutViewModel()
    
    @State private var selectedDate = Date()
    @State private var predictedWeight = 0.0
    @State private var BMI = 0.0
    @State private var healthStatus = ""
    @State private var predictedCalories = 0.0
    @State private var hasExercised = 0
    @State private var suggestion = "No Data Found"
    
    var body: some View {
        VStack {
            Text("Predictions")
                .font(.title3).bold()
                .padding(.leading)
                .padding(.top)
                .frame(alignment: .leading)
            
            DatePicker("Select a Date", selection: $selectedDate, displayedComponents: .date)
                .padding()
                .accentColor(.orange)
            
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .foregroundColor(.orange)
                    .frame(height: 150)
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("Predicted Weight (Kg)")
                        .font(.body)
                    Text("Predicted BMI")
                        .font(.body)
                    Text("Health Status")
                        .font(.body)
                }
                .offset(x: -60, y: 0)
                
                VStack(alignment: .trailing, spacing: 10) {
                    Text("\(predictedWeight != 0 ? String(format: "%.1f", predictedWeight) : "0.0")")
                        .font(.headline)
                    Text("\(predictedWeight != 0 ? String(format: "%.1f", BMI) : "0.0")")
                        .font(.headline)
                    Text("\(predictedWeight != 0 ? healthStatus : "0.0")")
                        .font(.headline)
                }
                .offset(x: 110, y: 0)
            }
            .padding()
            
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .foregroundColor(.orange)
                    .frame(height: 250)
                
                VStack(alignment: .leading, spacing: 10) {
                    HStack{
                        Image(systemName: "stethoscope").padding(5).bold()
                        Text("Suggestions")
                            .font(.headline)
                    }.padding(.bottom)
                    
                    Text("\(suggestion)")
                        .font(.body)
                        .padding(.leading)
                }
                .offset(x: 0, y: -60)
            }
            .padding()
            
            
            Spacer()
            
            PrimaryActionButton(actionName: "Calculate", icon: "chevron.forward", disabled: false, onClick: calculateHealthStatus)
            
        }
    }
    
    // calculate health status
    func calculateHealthStatus(){
        let user = user.email
        do {
            let config = MLModelConfiguration()
            
            let model = try PredicWeightModel(configuration: config)
            
            // future date
            let components = Calendar.current.dateComponents([.hour, .minute], from: selectedDate)
            let hour = (components.hour ?? 0) * 60 * 60
            let minute = (components.minute ?? 0) * 60
            
            // predicted calories
            //TODO: Optional force unwrap
            let calories = calculateAvgCaloriesConsumption(userId: user!)
            
            // user has exercised more than 20 mins
            //TODO: Optional force unwrap
            let exercised = userHasExercised(userId: user!)
            
            let prediction = try model.prediction(Date: String(Double(hour + minute)), calories: calories, walk: Double(exercised))
            
            // predicted weight
            predictedWeight = prediction.weight_oz / 35.27 // oz to kg
            
            // calculate BMI
            //TODO: Optional force unwrap
            BMI = calculateBMI(userId: user!, weight: predictedWeight)
            
            // get suggestions
            suggestion = getSuggestions(BMI: BMI)
            
            // health status
            let status = calculateHealthStatus(BMI: BMI)
            healthStatus = status.rawValue
            
            print("Weight == \(predictedWeight) || BMI == \(BMI) || Status == \(healthStatus)")
        }
        catch{
            // error
        }
        
    }
    
    // TODO: this can be move to DB
    func getSuggestions(BMI: Double) -> String {
        if BMI < 18.5 {
            suggestion = "Consider increasing your calorie intake and engaging in muscle-building exercises"
        } else if 18.5 <= BMI && BMI < 25 {
            suggestion = "Maintain a balanced diet and regular physical activity"
        } else if 25 <= BMI && BMI <= 40 {
            suggestion = "Focus on portion control, balanced diet, and regular exercise"
        } else if BMI >= 40.0 {
            suggestion = "Consult a healthcare professional for personalized advice on diet and exercise"
        }
        return suggestion
    }
    
    // get avg calories consumption for a day
    func calculateAvgCaloriesConsumption(userId: String) -> Double {
        
        // get avg calories count for each day usding workout and meals calories
        // 1 fetch workout and meals list by userId
        let meals: [WorkoutModel] = []
        
        // 2 get avg calories for each day
        let groupedByDate = Dictionary(grouping: meals) { $0.date }
        
        var averageCaloriesPerDay: [Date: Double] = [:]
        
        for (date, meals) in groupedByDate {
            let totalCalories = meals.map(\.calories).reduce(0, +)
            let averageCalories = totalCalories / Double(meals.count)
            averageCaloriesPerDay[date] = averageCalories
        }
        
        // 3 mean of calories & days
        var totalCalories = 0.0
        var totalDays = 0.0
        
        for (_, meals) in averageCaloriesPerDay {
            totalDays += 1
            totalCalories += meals
        }
        
        var xMean = 0
        var yMean = 0
        
        if !groupedByDate.isEmpty{
            xMean = Int(totalDays) / groupedByDate.count;
            yMean = Int(totalCalories) / groupedByDate.count;
        }
        
        var a = 0.0;
        var b = 0.0;
        
        for entry in averageCaloriesPerDay {
            let xDiff = (entry.key.timeIntervalSinceReferenceDate) / Double((60 * 60 * 24) - xMean)
            a += Double((entry.value - Double(yMean)) * xDiff)
            b += xDiff * xDiff
        }
        
        // y = mx + c
        var mSlope = 0.0;
        var cInterceptor = 0.0;
        
        // m = a / b
        if b != 0 {
            mSlope = a / b;
        }
        
        // c = yMean - m * xMean
        cInterceptor = Double(yMean - (Int(mSlope) * xMean));
        
        let predictionDays = selectedDate.timeIntervalSinceReferenceDate / (60 * 60 * 24)
        let predictedCaloryConsumption = mSlope * predictionDays + cInterceptor
        print("Predicted Calories == \(predictedCaloryConsumption)")
        return predictedCaloryConsumption
    }
    
    // check if the avg workout time is more than 20 mins
    // walk = 1 if avg workout time above 20mins
    func userHasExercised(userId: String) -> Int{
        
        workoutVm.getWorkouts(moc, userId: userId)
        
        // get avg calories count for each day usding workout and meals calories
        let workouts: [WorkoutEntity] = workoutVm.savedWorkouts
        
        let groupedByDate = Dictionary(grouping: workouts) { $0.date }
        
        var averageTimePerDay: [Date: Double] = [:]
        
        for (date, workouts) in groupedByDate {
            let totalTime = workouts.map(\.duration).reduce(0, +)
            let averageTime = totalTime / Double(workouts.count)
            averageTimePerDay[date!] = averageTime
        }
        
        // mean of workout duration & days
        var totalTime = 0.0
        var totalDays = 0.0
        
        for (_, workouts) in averageTimePerDay {
            totalDays += 1
            totalTime += workouts
        }
        
        var xMean = 0
        var yMean = 0
        
        if !groupedByDate.isEmpty{
            xMean = Int(totalDays) / groupedByDate.count;
            yMean = Int(totalTime) / groupedByDate.count;
        }
        
        var a = 0.0;
        var b = 0.0;
        
        for entry in averageTimePerDay {
            let xDiff = (entry.key.timeIntervalSinceReferenceDate) / Double((60 * 60 * 24) - xMean)
            a += Double((entry.value - Double(yMean)) * xDiff)
            b += xDiff * xDiff
        }
        
        // y = mx + c
        var mSlope = 0.0;
        var cInterceptor = 0.0;
        
        // m = a / b
        if b != 0 {
            mSlope = a / b;
        }
        
        // c = yMean - m * xMean
        cInterceptor = Double(yMean - (Int(mSlope) * xMean));
        
        let predictionDays = selectedDate.timeIntervalSinceReferenceDate / (60 * 60 * 24)
        let predictedWorkoutDuration = mSlope * predictionDays + cInterceptor
        
        print("Predicted Workout Time  == \(predictedWorkoutDuration)")
        
        var hasExercised = 0
        if predictedWorkoutDuration > 20 {
            hasExercised = 1
        } else {
            hasExercised = 0
        }
        return hasExercised;
    }
    
    // calculate health status by the BMI
    func calculateHealthStatus(BMI: Double) -> HealthStatusEnum {
        if BMI < 18.5 {
            return .Underweight
        } else if 18.5 <= BMI && BMI < 25 {
            return .Normalweight
        } else if 25 <= BMI && BMI <= 40 {
            return .Overweight
        } else if BMI >= 40.0 {
            return .Obesity
        } else {
            return .None
        }
        
    }
    
    func calculateBMI(userId: String, weight: Double) -> Double {
        // todo : fetch user details
        // height
        let height = 164.0 / 100
        
        // calculate BMI
        let BMI = weight / (height * height)
        
        return BMI
    }
    
}

struct PredictionView_Previews: PreviewProvider {
    static var previews: some View {
        PredictionView()
    }
}
