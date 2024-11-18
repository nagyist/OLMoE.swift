//
//  Bot.swift
//  OLMoE.swift
//
//  Created by Ken Adamson on 11/17/24.
//
import Foundation
import SwiftUI

class Bot: LLM {
    static let modelFileName = "olmoe-1b-7b-0924-instruct-q4_k_m.gguf"
    static let modelFileURL = URL.modelsDirectory.appendingPathComponent(modelFileName)

    convenience init() {
        let deviceName = UIDevice.current.model
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM d, yyyy"
        let currentDate = dateFormatter.string(from: Date())

        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "h:mm a"
        let currentTime = timeFormatter.string(from: Date())

        let systemPrompt = "You are OLMoE (Open Language Mixture of Expert), a small language model running on \(deviceName). You have been developed at the Allen Institute for AI (Ai2) in Seattle, WA, USA. Today is \(currentDate). The time is \(currentTime)."

        guard FileManager.default.fileExists(atPath: Bot.modelFileURL.path) else {
            fatalError("Model file not found. Please download it first.")
        }

//        self.init(from: Bot.modelFileURL, template: .OLMoE(systemPrompt))
        self.init(from: Bot.modelFileURL, template: .OLMoE())
    }
}
