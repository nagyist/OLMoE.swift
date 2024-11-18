//
//  BotView.swift
//  OLMoE.swift
//
//  Created by Ken Adamson on 11/17/24.
//


import SwiftUI

struct BotView: View {
    @StateObject var bot: Bot
    @State var input = ""
    @State private var textEditorHeight: CGFloat = 40
    @State private var isGenerating = false
    @State private var scrollToBottom = false
    @State private var isSharing = false
    @State private var shareURL: URL?
    @State private var showShareSheet = false
    @FocusState private var isTextEditorFocused: Bool

    init(_ bot: Bot) {
        _bot = StateObject(wrappedValue: bot)
    }

    func respond() {
        isGenerating = true
        Task {
            let originalInput = input
            input = "" // Clear the input after sending
            await bot.respond(to: originalInput)
            scrollToBottom = true
            await MainActor.run {
                isGenerating = false
            }
        }
    }

    func stop() {
        bot.stop()
        input = "" // Clear the input
        isGenerating = false
        Task { @MainActor in
            await bot.clearHistory()
            bot.setOutput(to: "")
        }
    }

    func shareConversation() {
        isSharing = true
        Task {
            do {
                let apiKey = Configuration.apiKey
                let apiUrl = "https://ziv3vcg14i.execute-api.us-east-1.amazonaws.com/prod"

                let modelName = "olmoe-1b-7b-0924-instruct-q4_k_m"
                let systemFingerprint = "\(modelName)-\(AppInfo.shared.appId)"

                let messages = bot.history.map { chat in
                    ["role": chat.role == .user ? "user" : "assistant", "content": chat.content]
                }

                let payload: [String: Any] = [
                    "model": modelName,
                    "system_fingerprint": systemFingerprint,
                    "created": Int(Date().timeIntervalSince1970),
                    "messages": messages
                ]

                let jsonData = try JSONSerialization.data(withJSONObject: payload)

                var request = URLRequest(url: URL(string: apiUrl)!)
                request.httpMethod = "POST"
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                request.setValue(apiKey, forHTTPHeaderField: "x-api-key")
                request.httpBody = jsonData

                let (data, response) = try await URLSession.shared.data(for: request)

                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                    let responseString = String(data: data, encoding: .utf8)!
                    if let jsonData = responseString.data(using: .utf8),
                       let jsonResult = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any],
                       let body = jsonResult["body"] as? String,
                       let bodyData = body.data(using: .utf8),
                       let bodyJson = try JSONSerialization.jsonObject(with: bodyData, options: []) as? [String: Any],
                       let urlString = bodyJson["url"] as? String,
                       let url = URL(string: urlString) {
                        await MainActor.run {
                            self.shareURL = url
                            self.showShareSheet = true
                        }
                        print("Conversation shared successfully")
                    } else {
                        print("Failed to parse response")
                    }
                } else {
                    print("Failed to share conversation")
                }
            } catch {
                print("Error sharing conversation: \(error)")
            }

            await MainActor.run {
                isSharing = false
            }
        }
    }

    var body: some View {
        GeometryReader { geometry in
            contentView(in: geometry)
        }
        .sheet(isPresented: $showShareSheet, content: {
            if let url = shareURL {
                ActivityViewController(activityItems: [url])
            }
        })
    }

    private func contentView(in geometry: GeometryProxy) -> some View {
        ZStack {
            Color("BackgroundColor")
                .edgesIgnoringSafeArea(.all)

            VStack(alignment: .leading) {
                if !bot.output.isEmpty || isGenerating || !bot.history.isEmpty {
                    ScrollViewReader { proxy in
                        ScrollView {
                            VStack(alignment: .leading, spacing: 10) {
                                // Display history
                                ForEach(bot.history, id: \.content) { chat in
                                    if chat.content != bot.output {
                                        Text(chat.role == .user ? "User: " : "Bot: ")
                                            .fontWeight(.bold)
                                            .foregroundColor(Color("TextColor"))
                                        + Text(chat.content)
                                            .foregroundColor(Color("TextColor"))
                                    }
                                }
                                .opacity(0.5)
                                .font(.manrope().monospaced())

                                // Display current output
                                Text(bot.output)
                                    .monospaced()
                                    .foregroundColor(Color("TextColor"))
                                    .id("bottomID") // Unique ID for scrolling
                                Color.clear.frame(height: 1).id("bottomID2")

                            }
                        }
                        .onChange(of: bot.output) { _ in
                            if isGenerating {
                                withAnimation {
                                    proxy.scrollTo("bottomID", anchor: .bottom)
                                }
                            } else {
                                withAnimation {
                                    proxy.scrollTo("bottomID2", anchor: .bottom)
                                }
                            }

                        }
                        .onChange(of: scrollToBottom) { newValue in
                            if newValue {
                                withAnimation {
                                    proxy.scrollTo("bottomID", anchor: .bottom)
                                }
                                scrollToBottom = false
                            }
                        }
                        .gesture(TapGesture().onEnded({
                            isTextEditorFocused = false
                        }))
                    }
                } else {
                    ZStack {
                        VStack{
                            Spacer()
                                .frame(height: geometry.size.height * 0.1)
                            Image("Splash")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: min(geometry.size.width - 160, 290))
                            Spacer()
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                Spacer()

                HStack(alignment: .bottom, spacing: 8) {
                    ZStack(alignment: .topLeading) {
                        TextEditor(text: $input)
                            .frame(height: max(40, textEditorHeight))
                            .scrollContentBackground(.hidden)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .foregroundStyle(.thinMaterial)
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color("TextColor").opacity(0.2), lineWidth: 1)
                            )
                            .foregroundColor(Color("TextColor"))
                            .font(.manrope())
                            .focused($isTextEditorFocused)
                            .onChange(of: isTextEditorFocused, { _, isFocused in
                                if isFocused {
                                    textEditorHeight = 120
                                } else {
                                    textEditorHeight = 40
                                    self.hideKeyboard()
                                }
                            })

                        if input.isEmpty {
                            Text("Message")
                                .padding([.horizontal], 4)
                                .padding([.vertical], 8)
                                .foregroundColor(.gray)
                        }

                    }
                    VStack(spacing: 8) {
                        Button(action: {
                            isTextEditorFocused = false
                            shareConversation()
                        }) {
                            Image(systemName: "square.and.arrow.up")
                                .foregroundColor(Color("TextColor"))
                                .font(.system(size: 24))
                                .frame(width: 40, height: 40)
                        }
                        .disabled(isSharing || bot.history.isEmpty)
                        Button(action: {
                            isTextEditorFocused = false
                            respond()
                        }) {
                            HStack {
                                if isGenerating {
                                    SpinnerView(color: Color("AccentColor"))
                                } else {
                                    Image(systemName: "paperplane.fill")
                                }
                            }
                            .foregroundColor(Color("AccentColor"))
                            .font(.system(size: 24))
                            .frame(width: 40, height: 40)
                        }
                        .disabled(isGenerating) // Disable the button when generating
                        Button(action: {
                            isTextEditorFocused = false
                            stop()
                        }) {
                            Image(systemName: "trash.fill")
                                .foregroundColor(Color("TextColor"))
                                .font(.system(size: 24))
                                .frame(width: 40, height: 40)
                        }
                    }
                }
                .padding(.horizontal)
                .frame(maxWidth: .infinity)
            }
            .padding()
        }
        .sheet(isPresented: $showShareSheet, content: {
            if let url = shareURL {
                ActivityViewController(activityItems: [url])
            }
        })
        .gesture(TapGesture().onEnded({
            isTextEditorFocused = false
        }))
    }
}
