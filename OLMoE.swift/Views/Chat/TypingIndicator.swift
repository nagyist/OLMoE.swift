//
//  TypingIndicator.swift
//  OLMoE.swift
//
//  Created by Stanley Jovel on 3/10/25.
//

import SwiftUI

public struct TypingIndicator: View {
    @State private var opacities: [Double] = [0.25, 0.25, 0.25]
    private let animationDuration: Double = 0.7

    public var body: some View {
        HStack(spacing: 7) {
            ForEach(0..<3) { index in
                Circle()
                    .fill(Color(UIColor.label))
                    .frame(width: 7, height: 7)
                    .opacity(opacities[index])
            }
        }
        .padding(.top, 9)
        .onAppear {
            animateDots()
        }
    }

    private func animateDots() {
        let delay = animationDuration / 3

        // Animate each dot with a slight delay
        for i in 0..<3 {
            withAnimation(Animation.easeInOut(duration: animationDuration)
                .repeatForever(autoreverses: true)
                .delay(delay * Double(i))) {
                opacities[i] = 1.0
            }
        }
    }
}
