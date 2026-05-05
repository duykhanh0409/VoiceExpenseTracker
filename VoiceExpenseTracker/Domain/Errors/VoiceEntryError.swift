//
//  VoiceEntryError.swift
//  VoiceExpenseTracker
//
//  Domain Layer — pure Swift, no framework imports

import Foundation

enum VoiceEntryError: LocalizedError, Equatable {
    case parseFailure(String)
    case recognitionUnavailable
    case permissionDenied
    case noSpeechDetected
    case audioEngineFailure(String)

    var errorDescription: String? {
        switch self {
        case .parseFailure(let text):    return "Không hiểu: \"\(text)\""
        case .recognitionUnavailable:    return "Nhận diện giọng nói không khả dụng"
        case .permissionDenied:          return "Chưa cấp quyền microphone"
        case .noSpeechDetected:          return "Không nghe thấy gì, hãy thử lại"
        case .audioEngineFailure(let r): return "Lỗi audio: \(r)"
        }
    }
}
