import Foundation
import Combine

@MainActor
class TorrentService: ObservableObject {
    @Published var results: [TorrentItem] = []
    @Published var isLoading = false
    @Published var errorMessage: String? = nil

    func search(query: String) {
        guard !query.trimmingCharacters(in: .whitespaces).isEmpty else { return }

        isLoading = true
        errorMessage = nil
        results = []

        let encoded = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? query
        guard let url = URL(string: "https://apibay.org/q.php?q=\(encoded)") else { return }

        Task {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                let apiItems = try JSONDecoder().decode([APITorrent].self, from: data)

                let mapped: [TorrentItem] = apiItems
                    .filter { $0.id != "0" && (Int($0.seeders) ?? 0) > 0 }
                    .prefix(40)
                    .map { item in
                        let seeds = Int(item.seeders) ?? 0
                        let leechers = Int(item.leechers) ?? 0
                        let encodedName = item.name.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? item.name
                        let magnet = "magnet:?xt=urn:btih:\(item.info_hash)&dn=\(encodedName)"
                        let (label, level): (String, TorrentItem.SafetyLevel)
                        switch item.status {
                        case "vip":     (label, level) = ("TRÈS SAFE", .high)
                        case "trusted": (label, level) = ("SAFE", .medium)
                        default:        (label, level) = ("NON VÉRIFIÉ", .low)
                        }
                        return TorrentItem(
                            id: item.id,
                            name: item.name,
                            seeds: seeds,
                            leechers: leechers,
                            size: Self.formatSize(item.size),
                            magnetLink: magnet,
                            safetyLabel: label,
                            safetyLevel: level
                        )
                    }
                    .sorted { a, b in
                        let rank: (TorrentItem.SafetyLevel) -> Int = {
                            switch $0 { case .high: return 0; case .medium: return 1; case .low: return 2 }
                        }
                        if rank(a.safetyLevel) != rank(b.safetyLevel) { return rank(a.safetyLevel) < rank(b.safetyLevel) }
                        return a.seeds > b.seeds
                    }

                self.results = mapped
                self.isLoading = false
            } catch {
                self.errorMessage = "Erreur : \(error.localizedDescription)"
                self.isLoading = false
            }
        }
    }

    static func formatSize(_ sizeStr: String) -> String {
        guard let size = Double(sizeStr) else { return "N/A" }
        if size >= 1_073_741_824 { return String(format: "%.2f Go", size / 1_073_741_824) }
        if size >= 1_048_576    { return String(format: "%.2f Mo", size / 1_048_576) }
        if size >= 1_024        { return String(format: "%.2f Ko", size / 1_024) }
        return "\(Int(size)) o"
    }
}
