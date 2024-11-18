//
//  Context.swift
//  OLMoE.swift
//
//  Created by Ken Adamson on 11/17/24.
//
import llama

public class Context {
    // Encapsulate the pointer
    private let _pointer: OpaquePointer

    // Expose a read-only pointer
    public var pointer: OpaquePointer {
        return _pointer
    }

    public init(_ model: Model, _ params: llama_context_params) {
        self._pointer = llama_new_context_with_model(model, params)
    }

    deinit {
        llama_free(_pointer)
    }

    public func decode(_ batch: llama_batch) {
        guard llama_decode(_pointer, batch) == 0 else {
            fatalError("llama_decode failed")
        }
    }
}

