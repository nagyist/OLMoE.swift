//
//  ToolbarButton.swift
//  OLMoE.swift
//
//  Created by Stanley Jovel on 2/6/25.
//

import SwiftUI

struct ToolbarButton: View {
    let action: () -> Void
    let imageName: String

    var body: some View {
        Button(action: action) {
            Image(systemName: imageName)
                #if targetEnvironment(macCatalyst)
                    .foregroundColor(Color("MacIconColor"))
                #else
                    .foregroundColor(Color("TextColor"))
                #endif
        }
        .buttonStyle(.plain)
        .background(Color.clear)
    }
}
