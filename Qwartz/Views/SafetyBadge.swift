import SwiftUI

struct SafetyBadge: View {
    let label: String
    let level: TorrentItem.SafetyLevel

    var badgeColor: Color {
        switch level {
        case .high:   return Color(red: 0, green: 1, blue: 0.53)
        case .medium: return Color(red: 0.64, green: 0.2, blue: 1)
        case .low:    return Color(white: 0.25)
        }
    }

    var textColor: Color {
        switch level {
        case .high:  return .black
        case .medium: return .white
        case .low:   return Color(white: 0.6)
        }
    }

    var body: some View {
        Text(label)
            .font(.system(size: 9, weight: .black))
            .foregroundColor(textColor)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(badgeColor)
            .cornerRadius(4)
    }
}
