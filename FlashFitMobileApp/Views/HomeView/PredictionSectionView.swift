//
//  PredictionSectionView.swift
//  FlashFitMobileApp
//
//  Created by user233619 on 8/6/23.
//

import SwiftUI

struct PredictionSectionView: View {
    var body: some View {
        
        VStack {
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
                            Text("Over Weight")
                                .font(.subheadline)
                                .fontWeight(.medium)
                            Text("55.8Kg")
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
        }
 
    }
    
    func getDate() -> String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM"
        
        return formatter.string(from: date)
    }
}

struct PredictionSectionView_Previews: PreviewProvider {
    static var previews: some View {
        PredictionSectionView()
    }
}
