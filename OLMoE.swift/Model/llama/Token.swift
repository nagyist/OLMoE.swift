//
//  Kind.swift
//  OLMoE.swift
//
//  Created by Ken Adamson on 11/17/24.
//

import llama

public typealias Token = llama_token

extension Token {
    enum Kind {
        case end
        case couldBeEnd
        case normal
    }
}
