//
//  PredictionView.swift
//  FlashFitMobileApp
//
//  Created by user233619 on 8/6/23.
//

import CoreML
import SwiftUI

struct PredictionView: View {
    
    @State private var selectedDate = Date()
    @State private var predictedWeight = 0.0
    @State private var BMI = 0.0
    @State private var healthStatus = ""
    @State private var predictedCalories = 0.0
    @State private var hasExercised = 0
    
    var body: some View {
        VStack{
            DatePicker("Pick a Date", selection: $selectedDate, displayedComponents: .date)
                .padding()

            if predictedWeight != 0 {                
                HStack {
                    Text("Predicted Weight:")
                    Text(String(format: "%.2f", predictedWeight))
                }
                HStack{
                    Text("BMI Value:")
                    Text(String(format: "%.2f", BMI))
                }
                HStack{
                    Text("Predicted Health Status:")
                    Text(String(format: "%.2f", healthStatus))
                }
            }
            
            Button("Calculate", action: calculateHealthStatus)
                .padding()
        }
    }
    
    // calculate health status
    func calculateHealthStatus(){
        var user = "testing"
        do{
            let config = MLModelConfiguration()
            
            let model = try PredicWeightModel(configuration: config)
            
            // future date
            let components = Calendar.current.dateComponents([.hour, .minute], from: selectedDate)
            let hour = (components.hour ?? 0) * 60 * 60
            let minute = (components.minute ?? 0) * 60
            
            // predicted calories
            //calculateAvgCaloriesConsumption(userId: user)
            
            // user has exercised more than 20mins
            userHasExercised()
            
            let prediction = try model.prediction(Date: String(Double(hour + minute)), calories: predictedCalories, walk: Double(hasExercised))
            
            // predicted weight
            predictedWeight = prediction.weight_oz / 35.27 // oz to kg
            
            // calculate BMI
            BMI = calculateBMI(userId: user, weight: predictedWeight)
            
            // health status
            calculateHealthStatus(BMI: BMI)
            
            predictedWeight = 77.05
            BMI = 85
            healthStatus = "Over Weight"
            
        }
        catch{
            // error
        }
        
    }
    
    // get avg calories consumption for a day
    // walk = 1 if avg workout time above 20mins
    /*func calculateAvgCaloriesConsumption(userId: String) {
        
        // get avg calories count for each day usding workout and meals calories
        // 1 get workout and meals list by userId
        var groupedByDate: [String] = []
        
        // 2 get avg calories for each day
        
        // 3 mean of calories
        var totalCalories = 100.0
        
        // 4 mean of days
        var totalDays = 45.0
        
        var xMean = Int(totalDays) / groupedByDate.count;
        var yMean = Int(totalCalories) / groupedByDate.count;
        
        var a = 0;
        var b = 0;
        
        /*for entry in groupedByDate {
            let xDiff = entry.date.timeIntervalSinceReferenceDate / (60 * 60 * 24) - xMean
            a += (entry.calories - yMean) * xDiff
            b += xDiff * xDiff
        }*/
        
        predictedCalories = 58.6
             
    }*/
    
    // check if the avg workout time is more than 20 mins
    func userHasExercised(){
        let avgWorkoutTime = 42
        if avgWorkoutTime > 20 {
            hasExercised = 1
        } else {
            hasExercised = 0
        }
    }
    
    // calculate health status by the BMI
    func calculateHealthStatus(BMI: Double){
        if BMI < 18.5 {
            healthStatus = "Under Weight"
        } else if 18.5 <= BMI && BMI < 25 {
            healthStatus = "Normal"
        } else if 25 <= BMI && BMI <= 40 {
            healthStatus = "Over Weight"
        } else if BMI >= 40.0 {
            healthStatus = "Obese"
        }
    }
    
    func calculateBMI(userId: String, weight: Double) -> Double {
        // fetch user details
        
        
        // height
        let height = 164.0

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
