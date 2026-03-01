import Foundation

// MARK: - API Response Model
struct APITorrent: Codable {
    let id: String
    let name: String
    let info_hash: String
    let seeders: String
    let leechers: String
    let size: String
    let status: String
    let category: String
}

// MARK: - App Model
struct TorrentItem: Identifiable {
    let id: String
    let name: String
    let seeds: Int
    let leechers: Int
    let size: String
    let magnetLink: String
    let safetyLabel: String
    let safetyLevel: SafetyLevel

    enum SafetyLevel {
        case high, medium, low
    }
}
