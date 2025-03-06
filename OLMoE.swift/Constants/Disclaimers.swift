//
//  Disclaimers.swift
//  OLMoE.swift
//
//  Created by Stanley Jovel on 11/14/24.
//


import Foundation

protocol Disclaimer {
    var title: String { get }
    var text: String { get }
    var headerTextContent: [HeaderTextPair] { get }
    var buttonText: String { get }
}

struct Disclaimers {

    struct FullDisclaimer: Disclaimer {
        let title = "Disclaimer"
        let text = ""
        let buttonText = "Agree"
        let headerTextContent = [
            HeaderTextPair(
                header: "Limitations",
                text: """
                OLMoE is not intended to provide advice and may generate inaccurate or misleading information, or produce offensive or unwelcome outputs.  Never use OLMoE as a provider of critical information or for legal, medical, financial, or other professional advice. Always validate model outputs with your own independent research.
                """),
            HeaderTextPair(
                header: "Privacy and Data Collection",
                text: """
                OLMoE runs locally on your device and Ai2 will not collect your interactions with the app. OLMoE only stores your most recent conversation and you can manually delete each conversation by starting a new thread. Ai2 will receive anonymized app development data though Apple's crash analytics APIs in accordance with our [Privacy Policy](https://allenai.org/privacy-policy/2025-02-19). Please use your discretion and best judgment when sharing any personal, sensitive, or confidential information in your use of the OLMoE app.
                """),
            HeaderTextPair(
                header: "Acceptance",
                text: """
                By pressing the “Agree” button below, I agree to Ai2’s [Terms of Use](https://allenai.org/terms) and [Responsible Use Guidelines](https://allenai.org/responsible-use) for thisOLMoE App. I understand that when prompting OLMoE, I will be interacting with generative artificial intelligence and not a human.
                """),
        ]
    }

    struct ShareDisclaimer: Disclaimer {
        let title = "Sharing Consent"
        let text = """
            When sharing a link to a conversation, you are consenting to share your messages with Ai2 and your conversation will be transmitted and stored on Ai2's servers. Please do not share PII (personally identifiable information) or any other sensitive information in your conversation.

            Once you select “Share” below, your conversation and related interaction data will be retained by Ai2 as described in our [Terms of Use](https://allenai.org/terms/2024-09-25) and [Privacy Policy](https://allenai.org/privacy-policy). By sharing, you agree to allow Ai2 to collect this interaction data for scientific research and educational purposes and to develop or improve this app as well as  the models and underlying technology presented in this app. If you do not want to share your interaction data with Ai2, please press “Cancel” to cancel sharing.
            """
        let buttonText = "Share"
        let headerTextContent = [HeaderTextPair]()
    }
}
