import SwiftUI

struct ContentView: View {
    @StateObject private var service = TorrentService()
    @State private var query = ""
    @FocusState private var searchFocused: Bool

    var body: some View {
        ZStack {
            Color(red: 0.02, green: 0.02, blue: 0.02)
                .ignoresSafeArea()

            VStack(spacing: 0) {

                // Header
                VStack(spacing: 16) {
                    Text("QWARTZ")
                        .font(.system(size: 42, weight: .black, design: .default))
                        .foregroundColor(.white)
                        .tracking(-2)
                    Text("ENGINE")
                        .font(.system(size: 14, weight: .heavy))
                        .foregroundColor(Color(red: 0, green: 0.83, blue: 1))
                        .tracking(6)
                }
                .padding(.top, 20)
                .padding(.bottom, 24)

                // Search bar
                HStack(spacing: 0) {
                    TextField("", text: $query, prompt: Text("Rechercher...").foregroundColor(Color(white: 0.4)))
                        .font(.system(size: 17))
                        .foregroundColor(.white)
                        .submitLabel(.search)
                        .focused($searchFocused)
                        .onSubmit { service.search(query: query) }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 14)
                        .background(Color(white: 0.08))
                        .cornerRadius(12, corners: [.topLeft, .bottomLeft])

                    Button(action: { service.search(query: query); searchFocused = false }) {
                        Text("SEARCH")
                            .font(.system(size: 15, weight: .black))
                            .foregroundColor(.black)
                            .padding(.horizontal, 18)
                            .padding(.vertical, 14)
                            .background(Color(red: 0, green: 0.83, blue: 1))
                            .cornerRadius(12, corners: [.topRight, .bottomRight])
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 16)

                // Content
                if service.isLoading {
                    Spacer()
                    VStack(spacing: 12) {
                        ProgressView()
                            .tint(Color(red: 0, green: 0.83, blue: 1))
                            .scaleEffect(1.5)
                        Text("Recherche en cours...")
                            .font(.system(size: 14))
                            .foregroundColor(Color(white: 0.5))
                    }
                    Spacer()

                } else if let error = service.errorMessage {
                    Spacer()
                    VStack(spacing: 8) {
                        Image(systemName: "wifi.slash")
                            .font(.system(size: 36))
                            .foregroundColor(Color(red: 1, green: 0.3, blue: 0.3))
                        Text(error)
                            .font(.system(size: 14))
                            .foregroundColor(Color(white: 0.5))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 32)
                    }
                    Spacer()

                } else if service.results.isEmpty && !query.isEmpty {
                    Spacer()
                    VStack(spacing: 8) {
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 36))
                            .foregroundColor(Color(white: 0.3))
                        Text("Aucun résultat actif")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(Color(white: 0.4))
                    }
                    Spacer()

                } else if service.results.isEmpty {
                    Spacer()
                    VStack(spacing: 8) {
                        Image(systemName: "sparkle.magnifyingglass")
                            .font(.system(size: 48))
                            .foregroundColor(Color(white: 0.2))
                        Text("Lance une recherche")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(Color(white: 0.3))
                    }
                    Spacer()

                } else {
                    // Results count
                    HStack {
                        Text("\(service.results.count) résultat(s) avec seeders actifs")
                            .font(.system(size: 12))
                            .foregroundColor(Color(white: 0.4))
                        Spacer()
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 8)

                    // Results list
                    ScrollView {
                        LazyVStack(spacing: 10) {
                            ForEach(service.results) { item in
                                ResultRowView(item: item)
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.bottom, 20)
                    }
                }
            }
        }
        .preferredColorScheme(.dark)
    }
}

// Helper for per-corner radius
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat
    var corners: UIRectCorner

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}
