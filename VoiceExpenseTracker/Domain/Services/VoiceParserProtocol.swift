//
//  VoiceParserProtocol.swift
//  VoiceExpenseTracker
//
//  Domain Layer — pure Swift

protocol VoiceParserProtocol {
    /// Convert a raw transcript string into a structured Expense.
    /// Returns nil if the transcript cannot be parsed.
    func parse(_ transcript: String) -> Expense?
}
