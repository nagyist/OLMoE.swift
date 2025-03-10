//
//  BotChatBubbleView.swift
//  OLMoE.swift
//
//  Created by Stanley Jovel on 3/4/25.
//

import SwiftUI
import MarkdownUI

public struct BotChatBubble: View {
    var text: String
    var maxWidth: CGFloat
    var isGenerating: Bool = false
    var hideCopyButton: Bool = false

    private var copyButtonIsVisible: Bool {
        !hideCopyButton && !isGenerating && text != "..."
    }
    // State for tracking copy feedback
    @State private var showCopyFeedback = false

    var generatingDot: String {
        if isGenerating && !text.isEmpty {
            return " [•](GeneratingDot)"
        } else {
            return ""
        }
    }

    public var body: some View {
        HStack(alignment: .top, spacing: 18) {
            // Bot profile picture
            Image("BotProfilePicture")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 18, height: 18)
                .padding(5)
                .background(Color("AccentColor"))
                .clipShape(Circle())

            if isGenerating && text.isEmpty {
                TypingIndicator()
            } else {
                VStack(alignment: .leading) {
                    // Markdown content with styling
                    Markdown("""
                        \(text)\(generatingDot)
                        """
                    )
                        .padding(.top, -2)
                        .background(Color("BackgroundColor"))
                        .frame(alignment: .leading)
                        .font(.body())
                        // Style for links
                        .markdownTextStyle(\.link) {
                            ForegroundColor(Color("AccentColor"))
                        }
                        // Style for inline code
                        .markdownTextStyle(\.code) {
                            FontFamilyVariant(.monospaced)
                            FontSize(.em(0.85))
                            BackgroundColor(Color("Surface").opacity(0.35))
                        }
                        // Style for code blocks with copy functionality
                        .markdownBlockStyle(\.codeBlock) { configuration in
                            configuration.label
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(Color("Surface").opacity(0.35))
                                .markdownTextStyle {
                                    FontFamilyVariant(.monospaced)
                                    FontSize(.em(0.85))
                                }
                                .markdownMargin(top: 8, bottom: 8)
                                .contextMenu {
                                    Button(action: {
                                        UIPasteboard.general.string = configuration.content
                                        let generator = UIImpactFeedbackGenerator(style: .light)
                                        generator.impactOccurred()
                                    }) {
                                        Label("Copy Code", systemImage: "doc.on.doc")
                                    }
                                }
                        }
                        .textSelection(.enabled) // Enable text selection for manual copying

                    // Copy button
                    if copyButtonIsVisible {
                        Button(action: {
                            copyFullText()
                        }) {
                            HStack(spacing: 4) {
                                Image(systemName: showCopyFeedback ? "checkmark" : "doc.on.doc")
                                    .font(.body())
                                if showCopyFeedback {
                                    Text("Copied")
                                        .font(.body())
                                }
                            }
                            .padding(.top, 1)
                            .background(Color.clear)
                            .foregroundColor(Color("AccentColor"))
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
            }
            Spacer()
        }
        .padding([.leading], 12)
    }

    // Copy the full text to clipboard with feedback
    private func copyFullText() {
        UIPasteboard.general.string = text

        // Show feedback
        withAnimation {
            showCopyFeedback = true
        }

        // Provide haptic feedback
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()

        // Hide feedback after delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation {
                showCopyFeedback = false
            }
        }
    }
}

#Preview {
    ScrollView {
        VStack(spacing: 20) {
            BotChatBubble(
                text: "",
                maxWidth: UIScreen.main.bounds.width,
                isGenerating: true
            )

            BotChatBubble(
                text: "...",
                maxWidth: UIScreen.main.bounds.width
            )

            BotChatBubble(
                text: "This text is being generated and may span multiple lin",
                maxWidth: UIScreen.main.bounds.width,
                isGenerating: true
            )

            BotChatBubble(
                text: "This is a longer message that spans multiple lines to demonstrate how the bubble handles longer content and wraps text appropriately.",
                maxWidth: UIScreen.main.bounds.width
            )

            BotChatBubble(
                text: "Welcome Message!",
                maxWidth: UIScreen.main.bounds.width,
                hideCopyButton: true
            )
        }
        .padding(.vertical, 20)
        .background(Color("BackgroundColor"))
        .preferredColorScheme(.dark)
    }
}
