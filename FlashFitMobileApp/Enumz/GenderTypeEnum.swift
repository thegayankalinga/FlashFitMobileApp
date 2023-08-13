//
//  GenderTypeEnum.swift
//  FlashFitMobileApp
//
//  Created by Gayan Kalinga on 2023-08-12.
//

import Foundation

public enum GenderTypeEnum: String, Identifiable, CaseIterable{
    case Male = "Male"
    case Female = "Female"
    public var id: Self { self }
}
