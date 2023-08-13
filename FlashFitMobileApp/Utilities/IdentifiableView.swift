//
//  IdentifiableView.swift
//  FlashFitMobileApp
//
//  Created by Gayan Kalinga on 2023-08-12.
//

import Foundation
import SwiftUI

struct IdentifiableView: Identifiable {
    let view: AnyView
    let id = UUID()
}
