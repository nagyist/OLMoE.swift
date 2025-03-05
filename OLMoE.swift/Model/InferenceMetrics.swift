//
//  InferenceMetrics.swift
//  OLMoE.swift
//
//  Created by Stanley Jovel on 3/4/25.
//

import Foundation

public struct InferenceMetrics {
    var inferenceTokenCount: Int32 = 0
    var inputTokenCount: Int32 = 0
    var totalTokens: Int32 = 0

    var startTime: TimeInterval = 0
    var endTime: TimeInterval = 0

    var inferenceTokensPerSecond: Double {
        self.tokensPerSecond(count: inferenceTokenCount)
    }

    func tokensPerSecond(count: Int32) -> Double {
        guard endTime > startTime else { return 0 }
        let duration = endTime - startTime
        return Double(count) / duration
    }

    mutating func start() {
        startTime = ProcessInfo.processInfo.systemUptime
        totalTokens = 0
        inferenceTokenCount = 0
    }

    mutating func recordToken() {
        inferenceTokenCount += 1
    }

    mutating func stop() {
        endTime = ProcessInfo.processInfo.systemUptime
        totalTokens = inputTokenCount + inferenceTokenCount
    }
}
