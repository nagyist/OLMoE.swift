//
//  InfoText.swift
//  OLMoE.swift
//
//  Created by Thomas Jones on 11/19/24.
//

enum InfoText {

    static let content = [
        HeaderTextPair(
            header: "What is the OLMoE App?",
            text: """
                This application allows you to interact with Ai2's OLMoE model, a Mixture-of-Experts language model that can run completely on-device.
                """),
        HeaderTextPair(
            header: "What type of data is used to train the models?",
            text: """
                OLMoE is pre-trained on the Ai2 [OLMoE-mix-0924](https://huggingface.co/datasets/allenai/OLMoE-mix-0924) dataset, including a diverse mix of web content, academic publications, code, math, and encyclopedic materials, and fine-tuned on the [Tulu 3 preview](https://huggingface.co/datasets/allenai/tulu-v3.1-mix-preview-4096-OLMoE) dataset.
                """),
        HeaderTextPair(
            header: "How up-to-date is the training data?",
            text: """
                The OLMoE-Instruct model is trained on the [OLMoE-mix dataset](https://huggingface.co/datasets/allenai/OLMoE-mix-0924), which consists of training data collected up until December 2023. Accordingly, the OLMoE-Instruct model only includes events or publications before that date.
                """),

        HeaderTextPair(
            header:
                "How accurate and reliable is the generated content on this app?",
            text: """
                OLMoE is built for research and educational purposes. It is not intended to be highly accurate or reliable, but rather as a research tool and a way to help the community better understand how LLMs are created and how they operate. When interacting with OMLoE, always use your best judgment, fact-check important information, and consider the context when interpreting content generated in this app.
                """),

        HeaderTextPair(
            header:
                "What data does Ai2 collect about me?",
            text: """
                OLMoE runs locally on your device and your interactions with the app will not be shared with Ai2. Ai2 will receive anonymized app development data though Apple's crash analytics APIs in accordance with our [Privacy Policy](https://allenai.org/privacy-policy).
                """),

        HeaderTextPair(
            header: "",
            text: """
                Please do not include PII (personally identifiable information) in model prompts or elsewhere in this app.
                """),

        HeaderTextPair(
            header: "Open Source Licenses",
            text: """
                LlamaCPP
                Copyright (c) 2023-2024 The ggml authors
                Licensed under the MIT License.
                You may obtain a copy of the license at:
                [LlamaCPP Repository](https://github.com/ggerganov/llama.cpp)

                ggml
                Copyright (c) 2023-2024 The ggml authors
                Licensed under the MIT License.
                You may obtain a copy of the license at:
                [ggml Repository](https://github.com/ggerganov/ggml)

                MarkdownUI
                Copyright (c) 2020 Guillermo Gonzalez
                Licensed under the MIT License.
                You may obtain a copy of the license at:
                [MarkdownUI Repository](https://github.com/gonzalezreal/swift-markdown-ui)

                HighlightSwift
                Copyright (c) Stefan Blos
                Licensed under the MIT License.
                You may obtain a copy of the license at:
                [HighlightSwift Repository](https://github.com/appstefan/HighlightSwift)
                """)
    ]
}
