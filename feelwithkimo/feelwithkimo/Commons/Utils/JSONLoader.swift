//
//  JSONLoader.swift
//  feelwithkimo
//
//  Created by jonathan calvin sutrisna on 24/11/25.
//

import Foundation

struct JSONLoader {
    // MARK: - Public API
    static func load<T: Decodable>(
        _ type: T.Type,
        from fileName: String,
        fallback fallbackFileName: String? = nil
    ) -> T? {
        // Try primary file
        if let result = decodeJSON(type, from: fileName) {
            return result
        }

        // Try fallback file if primary fails
        if let fallbackName = fallbackFileName {
            print("Falling back to \(fallbackName) because \(fileName) failed to decode.")
            return decodeJSON(type, from: fallbackName)
        }

        return nil
    }

    // MARK: - Internal JSON Decoder Logic
    private static func decodeJSON<T: Decodable>(_ type: T.Type, from fileName: String) -> T? {
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "json") else {
            print("JSON file not found: \(fileName).json")
            return nil
        }

        do {
            let data = try Data(contentsOf: url)
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            logDecodingError(error, fileName: fileName)
            return nil
        }
    }

    // MARK: - Logger
    private static func logDecodingError(_ error: Error, fileName: String) {
        print("Failed to decode \(fileName):")
        print("Error: \(error)")

        guard let decodingError = error as? DecodingError else { return }

        switch decodingError {
        case .keyNotFound(let key, let context):
            print("   Missing key: \(key.stringValue) - \(context.debugDescription)")
        case .typeMismatch(let type, let context):
            print("   Type mismatch: \(type) - \(context.debugDescription)")
        case .valueNotFound(let type, let context):
            print("   Value not found: \(type) - \(context.debugDescription)")
        case .dataCorrupted(let context):
            print("   Data corrupted: \(context.debugDescription)")
        @unknown default:
            print("   Unknown decoding error")
        }
    }
}
