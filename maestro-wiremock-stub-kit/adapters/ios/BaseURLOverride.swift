import Foundation
import UIKit

/// Простая точка настройки base URL для сетевого слоя
enum APIConfig {
    static func baseURL() -> URL {
        // Приоритет: аргументы запуска -> переменные окружения -> UserDefaults -> prod
        let args = ProcessInfo.processInfo.arguments
        if let baseFromArgsIndex = args.firstIndex(of: "BASE_URL"), baseFromArgsIndex+1 < args.count {
            if let url = URL(string: args[baseFromArgsIndex+1]) { return url }
        }
        if let envBase = ProcessInfo.processInfo.environment["BASE_URL"], let url = URL(string: envBase) {
            return url
        }
        if let udBase = UserDefaults.standard.string(forKey: "BASE_URL"), let url = URL(string: udBase) {
            return url
        }
        // PROD fallback
        return URL(string: "https://api.example.com")!
    }

    static var isE2E: Bool {
        ProcessInfo.processInfo.arguments.contains("IS_E2E")
    }
}
