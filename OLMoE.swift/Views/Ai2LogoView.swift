//
//  Ai2LogoView.swift
//  OLMoE.swift
//
//  Created by Jon Ryser on 2025-03-06.
//

import SwiftUI

/// A reusable view for displaying the Ai2 logo across the app
struct Ai2LogoView: View {
    /// The height of the logo image (defaults to 21 to match Ai2Logo)
    var height: CGFloat = 21

    /// Whether to apply the bottom padding for macCatalyst
    var applyMacCatalystPadding: Bool = false

    /// Custom top padding (nil means no custom padding)
    var topPadding: CGFloat? = 0

    /// Custom bottom padding (nil means no custom padding)
    var bottomPadding: CGFloat? = 0

    /// Custom leading padding (nil means no custom padding)
    var leadingPadding: CGFloat? = 0

    /// Custom trailing padding (nil means no custom padding)
    var trailingPadding: CGFloat? = 0

    /// Bottom padding amount for macCatalyst (only used if applyMacCatalystPadding is true)
    var macCatalystBottomPadding: CGFloat = 20

    var body: some View {
        let imageView = Image("Ai2 Logo")
            .resizable()
            .scaledToFit()
            .frame(height: height)

        return imageView
            .padding(.top, topPadding)
            .padding(.bottom, bottomPadding)
            .padding(.leading, leadingPadding)
            .padding(.trailing, trailingPadding)
            .modifier(ConditionalMacCatalystPadding(isEnabled: applyMacCatalystPadding, bottomPadding: macCatalystBottomPadding))
    }
}

/// Modifier that applies bottom padding only on macCatalyst
struct ConditionalMacCatalystPadding: ViewModifier {
    let isEnabled: Bool
    let bottomPadding: CGFloat

    func body(content: Content) -> some View {
        #if targetEnvironment(macCatalyst)
        if isEnabled {
            content.padding(.bottom, bottomPadding)
        } else {
            content
        }
        #else
        content
        #endif
    }
}

#Preview("Ai2LogoView - Standard") {
    VStack(spacing: 30) {
        Ai2LogoView()
    }
    .padding()
    .background(Color("SheetsBackgroundColor"))
}

#Preview("Ai2LogoView - Header") {
    VStack(spacing: 30) {
        Ai2LogoView(height: 30)
    }
    .padding()
    .background(Color("SheetsBackgroundColor"))
}

#Preview("Ai2LogoView - Custom") {
    VStack(spacing: 30) {
        Ai2LogoView(height: 62, topPadding: 20, bottomPadding: 10, leadingPadding: 12, trailingPadding: 12)
    }
    .padding()
    .background(Color("SheetsBackgroundColor"))
}
