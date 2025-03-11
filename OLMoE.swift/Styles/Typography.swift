//
//  Typography.swift
//  OLMoE.swift
//
//  Created by Jon Ryser on 2024-11-20.
//


import SwiftUI

extension Font {
    static func title(_ weight: Font.Weight = .regular) -> Font {
        .telegraf(weight, size: 24)
    }

    static func body(_ weight: Font.Weight = .regular) -> Font {
        .manrope(weight, size: 17)
    }

    static func subheader() -> Font {
        .manrope(.bold, size: 17)
    }
}
