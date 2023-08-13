//
//  NumberOnlyViewModifier.swift
//  FlashFitMobileApp
//
//  Created by Gayan Kalinga on 2023-08-13.
//

import Foundation
import SwiftUI
import Combine

struct NumbersOnlyViewModifier: ViewModifier{
    @Binding var text: String
    var includeDecimal: Bool
    
    func body(content: Content) -> some View {
        content
            .keyboardType(includeDecimal ? . decimalPad : .numberPad)
            .onReceive(Just(text)){ newValue in
                var numbers = "0123456789"
                
                let decimalSeparator: String = Locale.current.decimalSeparator ?? "."

                if includeDecimal{
                    numbers += decimalSeparator
                }
                
                if newValue.components(separatedBy: decimalSeparator).count-1 > 1{
                    let filtered = newValue
                    self.text = String(filtered.dropLast())
                }else{
                    let filtered = newValue.filter {numbers.contains($0)}
                    if filtered != newValue {
                        self.text = filtered
                    }
                }
                
            }
    }
}

extension View{
    func numberOnly(_ text: Binding<String>, includeDecimal: Bool = false) -> some View{
        self.modifier(NumbersOnlyViewModifier(text: text, includeDecimal: includeDecimal))
    }
}
