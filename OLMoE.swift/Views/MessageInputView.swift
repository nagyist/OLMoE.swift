//
//  MessageInputView.swift
//  OLMoE.swift
//
//  Created by Stanley Jovel on 11/19/24.
//


import SwiftUI

struct MessageInputView: View {
    @Binding var input: String
    @Binding var isGenerating: Bool
    @Binding var stopSubmitted: Bool
    @FocusState.Binding var isTextEditorFocused: Bool
    let isInputDisabled: Bool
    let hasValidInput: Bool
    let respond: () -> Void
    let stop: () -> Void

    var body: some View {
        HStack(alignment: .top, spacing: 15) {
            TextField(
                UIDevice.current.userInterfaceIdiom == .mac ?
                    String(localized: "Message OLMoE (Press Return to send)") :
                    String(localized: "Message OLMoE"),
                text: $input,
                axis: .vertical
            )
                .scrollContentBackground(.hidden)
                .multilineTextAlignment(.leading)
                .lineLimit(10)
                .foregroundColor(Color("TextColor"))
                .font(.body())
                .focused($isTextEditorFocused)
                .onChange(of: isTextEditorFocused) { _, isFocused in
                    if !isFocused {
                        hideKeyboard()
                    }
                }
                .disabled(isInputDisabled)
                .opacity(isInputDisabled ? 0.6 : 1)
                .padding(.vertical, 17.5)
                .onSubmit {
                    #if targetEnvironment(macCatalyst)
                    if hasValidInput {
                        respond()
                    }
                    #endif
                }
                .submitLabel(.send)

            ZStack {
                if isGenerating && !stopSubmitted {
                    Button(action: stop) {
                        Image("StopIcon")
                    }
                    .buttonStyle(.plain)
                    .padding(.top, 12)
                    .padding(.trailing, -12)
                } else {
                    Button(action: respond) {
                        Image("SendIcon")
                    }
                    .buttonStyle(.plain)
                    .disabled(!hasValidInput)
                    .opacity(hasValidInput ? 1 : 0.5)
                    .foregroundColor(hasValidInput ? Color("LightGreen") : Color("TextColor").opacity(0.5))
                    .keyboardShortcut(.defaultAction)
                    .padding(.top, 20)
                }
            }
            .onTapGesture {
                isTextEditorFocused = false
            }
            .font(.system(size: 24))
        }
        .padding([.leading, .trailing], 23)
        .frame(maxWidth: .infinity)
        .frame(minHeight: UIDevice.current.userInterfaceIdiom == .pad ? 80 : 57.5)
        .background(
            RoundedRectangle(cornerRadius: 30)
                .fill(Color("Surface"))
                .foregroundStyle(.thinMaterial)
        )
    }
}

#Preview("Valid Input") {
    @FocusState var isTextEditorFocused: Bool

    MessageInputView(
        input: .constant("Valid Message"),
        isGenerating: .constant(false),
        stopSubmitted: .constant(false),
        isTextEditorFocused: $isTextEditorFocused,
        isInputDisabled: false,
        hasValidInput: true,
        respond: {
            print("Send")
        },
        stop: {
            print("Stop")
        }
    )
    .preferredColorScheme(.dark)
}

#Preview("Long Input") {
    @FocusState var isTextEditorFocused: Bool

    MessageInputView(
        input: .constant("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."),
        isGenerating: .constant(false),
        stopSubmitted: .constant(false),
        isTextEditorFocused: $isTextEditorFocused,
        isInputDisabled: false,
        hasValidInput: true,
        respond: {
            print("Send")
        },
        stop: {
            print("Stop")
        }
    )
    .preferredColorScheme(.dark)
}


#Preview("Generating") {
    @FocusState var isTextEditorFocused: Bool

    MessageInputView(
        input: .constant(""),
        isGenerating: .constant(true),
        stopSubmitted: .constant(false),
        isTextEditorFocused: $isTextEditorFocused,
        isInputDisabled: false,
        hasValidInput: true,
        respond: {
            print("Send")
        },
        stop: {
            print("Stop")
        }
    )
    .preferredColorScheme(.dark)
}

#Preview("Empty Input") {
    @FocusState var isTextEditorFocused: Bool

    MessageInputView(
        input: .constant(""),
        isGenerating: .constant(false),
        stopSubmitted: .constant(false),
        isTextEditorFocused: $isTextEditorFocused,
        isInputDisabled: false,
        hasValidInput: false,
        respond: {
            print("Send")
        },
        stop: {
            print("Stop")
        }
    )
    .preferredColorScheme(.dark)
}
