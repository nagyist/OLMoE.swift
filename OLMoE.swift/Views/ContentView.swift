//
//  ContentView.swift
//  OLMoE.swift
//
//  Created by Luca Soldaini on 2024-09-16.
//

import SwiftUI

struct ViewHeightKey: PreferenceKey {
    static var defaultValue: CGFloat { 0 }
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = max(value, nextValue())
    }
}

// Add this struct to handle the UIActivityViewController
struct ActivityViewController: UIViewControllerRepresentable {
    let activityItems: [Any]
    let applicationActivities: [UIActivity]? = nil

    func makeUIViewController(context: UIViewControllerRepresentableContext<ActivityViewController>) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: activityItems, applicationActivities: applicationActivities)
        return controller
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: UIViewControllerRepresentableContext<ActivityViewController>) {}
}

struct ContentView: View {
    @StateObject private var downloadManager = BackgroundDownloadManager.shared
    @State private var bot: Bot?
    @State private var showDisclaimerPage : Bool = true
    @State private var disclaimerPageIndex: Int = 0

    var body: some View {
        VStack {
            if let bot = bot {
                BotView(bot)
            } else {
                ModelDownloadView()
            }
        }
        .onChange(of: downloadManager.isModelReady) { newValue in
            if newValue && bot == nil {
                initializeBot()
            }
        }
        .popover(isPresented: $showDisclaimerPage) {
            let page = Disclaimer.pages[disclaimerPageIndex]
            DisclaimerPage(
                title: page.title,
                message: page.text,
                confirm: DisclaimerPage.PageButton(
                    text: page.buttonText,
                    onDismiss: {
                        nextInfoPage()
                    })
            )
            .presentationBackground(Color("BackgroundColor"))
        }
        .onAppear(perform: checkModelAndInitializeBot)
    }

    private func nextInfoPage() {
        disclaimerPageIndex = min(Disclaimer.pages.count, disclaimerPageIndex + 1)
        if disclaimerPageIndex >= Disclaimer.pages.count {
            disclaimerPageIndex = 0
            showDisclaimerPage = false
        }
    }

    private func checkModelAndInitializeBot() {
        if FileManager.default.fileExists(atPath: Bot.modelFileURL.path) {
            downloadManager.isModelReady = true
            initializeBot()
        }
    }

    private func initializeBot() {
        bot = Bot()
    }
}
