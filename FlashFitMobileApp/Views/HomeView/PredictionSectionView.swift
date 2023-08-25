//
//  PredictionSectionView.swift
//  FlashFitMobileApp
//
//  Created by user233619 on 8/6/23.
//

import SwiftUI

struct PredictionSectionView: View {
    
    @EnvironmentObject var user: LoggedInUserModel
    @Environment(\.managedObjectContext) var moc
    
    @State var healthStatus : String = ""
    
    init() {
        _healthStatus = State(initialValue: calculateHealthStatus().rawValue)
    }
    
    var body: some View {
        Text("")
       /* VStack {
            NavigationLink(destination: PredictionView()) {
                HStack (alignment: .top) {
                    VStack (alignment: .leading, spacing: 30) {
                        HStack {
                            Image(systemName: "figure.walk")
                            Text("Health Prediction")
                                .font(.footnote)
                                .padding(.bottom, 5)
                        }
                        
                        VStack (alignment: .leading, spacing: 3) {
                            Text(healthStatus)
                                .font(.subheadline)
                                .fontWeight(.medium)
                            Text("\((user.weight!), specifier: "%.2f")")
                                .font(.caption)
                        }
                    }
                    
                    Spacer()
                    
                    Text("\(getDate())")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding()
                .foregroundColor(.black)
            }
        }*/
 
    }
    
    func getDate() -> String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM"
        
        return formatter.string(from: date)
    }
    
    func calculateHealthStatus() -> HealthStatusEnum {
        let height = user.height! / 100
        
        let BMI = 56.0
        //user.weight! / (height * height)
        
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
}

//struct PredictionSectionView_Previews: PreviewProvider {
//    static var previews: some View {
//        PredictionSectionView()
//    }
//}
