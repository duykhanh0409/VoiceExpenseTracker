//
//  VoiceInputParser.swift
//  VoiceExpenseTracker
//
//  Data Layer — implements VoiceParserProtocol

import Foundation

struct VoiceInputParser: VoiceParserProtocol {

    func parse(_ transcript: String) -> Expense? {
        let tokens = transcript
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .lowercased()
            .components(separatedBy: .whitespaces)
            .filter { !$0.isEmpty }

        guard !tokens.isEmpty else { return nil }

        // Find amount: search last → first
        guard let (amountIdx, amount) = findAmount(in: tokens) else { return nil }

        // Remaining tokens → title
        var titleTokens = tokens
        titleTokens.remove(at: amountIdx)
        let title = titleTokens.map { $0.capitalized }.joined(separator: " ")
        let finalTitle = title.isEmpty ? "Expense" : title

        let category = inferCategory(from: titleTokens)

        return Expense(title: finalTitle, amount: amount, category: category)
    }

    // MARK: - Amount Parsing

    private func findAmount(in tokens: [String]) -> (index: Int, amount: Double)? {
        for i in stride(from: tokens.count - 1, through: 0, by: -1) {
            if let amount = parseAmount(tokens[i]) {
                return (i, amount)
            }
        }
        return nil
    }

    private func parseAmount(_ token: String) -> Double? {
        // Strip commas: "50,000" → "50000"
        let clean = token.replacingOccurrences(of: ",", with: "")

        if clean.hasSuffix("k"), let n = Double(clean.dropLast())  { return n * 1_000 }
        if clean.hasSuffix("tr"), let n = Double(clean.dropLast(2)){ return n * 1_000_000 }
        if clean.hasSuffix("m"), let n = Double(clean.dropLast())  { return n * 1_000_000 }

        return Double(clean)
    }

    // MARK: - Category Inference

    private func inferCategory(from tokens: [String]) -> ExpenseCategory {
        let text = tokens.joined(separator: " ")

        let map: [(keywords: [String], category: ExpenseCategory)] = [
            (["coffee","cà","phê","trà","tea","juice","boba","drink","latte","espresso","nước","sinh tố"], .beverage),
            (["lunch","dinner","breakfast","food","ăn","cơm","phở","bún","bánh","mì","pizza","burger","sushi","meal","restaurant"], .food),
            (["grab","taxi","uber","gojek","be","bus","xe","xăng","fuel","gas","train","metro","flight","fly"], .transport),
            (["shop","mall","clothes","quần","áo","mua","buy","shopee","lazada","amazon","giày","túi"], .shopping),
        ]

        for entry in map {
            if entry.keywords.contains(where: { text.contains($0) }) {
                return entry.category
            }
        }
        return .other
    }
}
