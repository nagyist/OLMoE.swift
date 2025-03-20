//
//  UnsupportedDeviceView.swift
//  OLMoE.swift
//
//  Created by Ken Adamson on 11/17/24.
//


import SwiftUI
import os
import UIKit

struct UnsupportedDeviceView: View {
    @State private var showWebView = false
    let proceedAnyway: () -> Void
    let proceedMocked: () -> Void

    @State private var minButtonWidth: CGFloat = 100
    @State private var notSupportedWidth: CGFloat = 100

    var body: some View {
        let availableMemoryInGB = Double(os_proc_available_memory()) / (1024 * 1024 * 1024)
        let formattedMemory = String(format: "%.2f", availableMemoryInGB)

        GeometryReader { geometry in
            ScrollView {
                VStack(spacing: 30) {
                    Image("Exclamation")
                        .foregroundColor(Color("AccentColor"))
                        .frame(width: 44, height: 40)

                    Text("Device not supported")
                        .id(UUID())
                        .font(.title(.medium))
                        .background(GeometryReader { geometry in
                            Color.clear.onAppear {
                                notSupportedWidth = geometry.size.width + 24
                            }
                        })
                        .multilineTextAlignment(.center)
                    
                    VStack() {
                        Text("This app needs 8GB of RAM.")
                            .multilineTextAlignment(.center)
                            .font(.body(.bold))
                        if availableMemoryInGB > 0 {
                            Text("This device has \(formattedMemory)GB available.")
                                .multilineTextAlignment(.center)
                                .font(.body())
                        }
                    }
                    Text("OLMoE can run locally on iPhone 15 Pro/Max, iPhone 16 models, iPad Pro 4th Gen and newer, or iPad Air 5th Gen and newer.")
                        .multilineTextAlignment(.center)
                        .font(.body())

                    Text("However, you can try using OLMoE at the Ai2 Playground. This option does not download the model file to your device, but instead submits user input to a hosted version of OLMoE to remotely generate responses.")
                        .multilineTextAlignment(.center)
                        .font(.body())

                    Button("Try OLMoE at the Ai2 Playground") {
                        showWebView = true
                    }
                    .buttonStyle(.PrimaryButton)
                    .background(GeometryReader { geometry in
                        Color.clear.onAppear {
                            minButtonWidth = geometry.size.width - 24
                        }
                    })
                    .padding(.top, 12)
                    .sheet(isPresented: $showWebView, onDismiss: nil) {
                        SheetWrapper {
                            WebViewWithBanner(
                                url: URL(string: AppConstants.Model.playgroundURL)!,
                                onDismiss: { showWebView = false }
                            )
                        }
                        .interactiveDismissDisabled(false)
                    }

                    if FeatureFlags.allowDeviceBypass {
                        Button("Proceed Anyway") {
                            proceedAnyway()
                        }
                        .buttonStyle(PrimaryButton(minWidth: minButtonWidth))
                        .padding(.vertical, 5)
                    }

                    if FeatureFlags.allowMockedModel {
                        Button("Proceed With Mocked Model") {
                            proceedMocked()
                        }
                        .id(UUID())
                        .buttonStyle(PrimaryButton(minWidth: minButtonWidth))
                        .padding(.vertical, 5)
                    }

                }
                .frame(minHeight: geometry.size.height)
                .frame(maxWidth: 512)
                .padding(.horizontal, 24)
            }
            .frame(maxWidth: .infinity)
            .frame(height: geometry.size.height)
        }
        .background(Color("BackgroundColor"))
    }
}

#Preview("Unsupported Device View") {
    UnsupportedDeviceView(
        proceedAnyway: {
            print("Proceeding anyway")
        },
        proceedMocked: {
            print("Proceeding with mocked model")
        }
    )
    .preferredColorScheme(.dark)
    .background(Color("BackgroundColor"))
}
