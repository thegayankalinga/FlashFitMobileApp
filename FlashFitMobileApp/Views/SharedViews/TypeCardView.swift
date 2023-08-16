//
//  TypeCardView.swift
//  FlashFitMobileApp
//
//  Created by Gayan Kalinga on 2023-08-16.
//

import Foundation
import SwiftUI

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
