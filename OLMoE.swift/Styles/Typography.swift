//
//  Typography.swift
//  OLMoE.swift
//
//  Created by Jon Ryser on 2024-11-20.
//


import SwiftUI

extension Font {
    static func title(_ weight: Font.Weight = .medium) -> Font {
        .telegraf(weight, size: 24)
    }

    static func body(_ weight: Font.Weight = .medium) -> Font {
        .manrope(weight, size: 17)
    }

    static func subheader() -> Font {
        .manrope(.medium, size: 22)
    }
}
