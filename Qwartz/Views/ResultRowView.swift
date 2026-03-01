import SwiftUI

struct ResultRowView: View {
    let item: TorrentItem
    @State private var showCopied = false
    @State private var showMagnetSheet = false

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // Safety badge
            SafetyBadge(label: item.safetyLabel, level: item.safetyLevel)

            // File name
            Text(item.name)
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(.white)
                .lineLimit(3)
                .fixedSize(horizontal: false, vertical: true)

            // Seeds & size
            HStack(spacing: 12) {
                Label("\(item.seeds) SEEDS", systemImage: "arrow.up.circle.fill")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(Color(red: 0, green: 1, blue: 0.53))
                Text("•")
                    .foregroundColor(.gray)
                Text(item.size)
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
                Spacer()
            }

            // Action buttons
            HStack(spacing: 10) {
                // Open in torrent app
                Button(action: openMagnet) {
                    Label("TÉLÉCHARGER", systemImage: "arrow.down.circle.fill")
                        .font(.system(size: 13, weight: .black))
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(Color(red: 0, green: 0.83, blue: 1))
                        .cornerRadius(10)
                }

                // Copy magnet link
                Button(action: copyMagnet) {
                    Label(showCopied ? "COPIÉ !" : "MAGNET", systemImage: showCopied ? "checkmark" : "link")
                        .font(.system(size: 13, weight: .black))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(showCopied ? Color.green.opacity(0.7) : Color(red: 1, green: 0.3, blue: 0.3))
                        .cornerRadius(10)
                }
            }
        }
        .padding(16)
        .background(Color(white: 0.067))
        .cornerRadius(15)
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(Color(white: 0.13), lineWidth: 1)
        )
    }

    private func openMagnet() {
        guard let url = URL(string: item.magnetLink) else { return }
        UIApplication.shared.open(url)
    }

    private func copyMagnet() {
        UIPasteboard.general.string = item.magnetLink
        withAnimation { showCopied = true }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation { showCopied = false }
        }
    }
}
