//
//  ScrollToBottomButtonView.swift
//  OLMoE.swift
//
//  Created by Stanley Jovel on 3/10/25.
//

import SwiftUI

struct ScrollToBottomButtonView: View {
    @Binding var scrollToBottom: Bool
    var shouldShowScrollButton: () -> Bool

    var body: some View {
        HStack() {
            Spacer()

            VStack() {
                Spacer()

                Button(action: {
                    scrollToBottom = true
                }) {
                    Image(systemName: "arrow.down")
                        .aspectRatio(contentMode: .fit)
                        .padding(15)
                        .foregroundColor(Color("LightGreen"))
                        .background(Color("Surface"))
                        .clipShape(Circle())
                        .font(.system(size: 24))
                }
                .buttonStyle(.plain)
                .opacity(shouldShowScrollButton() ? 1 : 0)
                .transition(.opacity)
                .animation(
                    shouldShowScrollButton()
                    ? .easeIn(duration: 0.1)
                    : .easeOut(duration: 0.3).delay(0.1),
                    value: shouldShowScrollButton())
            }
            .padding([.bottom], 4)
        }
    }
}

#Preview {
    ScrollToBottomButtonView(
        scrollToBottom: .constant(false),
        shouldShowScrollButton: { true }
    )
    .padding()
}

