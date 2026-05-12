import SwiftUI

extension Color {
    static let kpPrimary = Color(red: 29/255, green: 154/255, blue: 152/255)
    static let kpPrimarySoft = Color(red: 218/255, green: 241/255, blue: 239/255)
    static let kpBackground = Color(red: 244/255, green: 241/255, blue: 234/255)
    static let kpCard = Color.white
    static let kpText = Color(red: 51/255, green: 51/255, blue: 51/255)
    static let kpSecondaryText = Color(red: 110/255, green: 103/255, blue: 96/255)
    static let kpBorder = Color(red: 227/255, green: 221/255, blue: 212/255)
    static let kpAccentPeach = Color(red: 247/255, green: 225/255, blue: 206/255)
}

extension Font {
    static func kpRounded(size: CGFloat, weight: Weight = .regular) -> Font {
        .system(size: size, weight: weight, design: .rounded)
    }
}

struct KPCard<Content: View>: View {
    let fillColor: Color
    let content: Content

    init(fillColor: Color = .kpCard, @ViewBuilder content: () -> Content) {
        self.fillColor = fillColor
        self.content = content()
    }

    var body: some View {
        content
            .padding(18)
            .background(fillColor)
            .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .stroke(Color.kpBorder, lineWidth: 1)
            )
            .shadow(color: Color.black.opacity(0.03), radius: 12, x: 0, y: 6)
    }
}

struct PrimaryButton: View {
    let title: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.kpRounded(size: 18, weight: .semibold))
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(Color.kpPrimary)
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        }
        .buttonStyle(.plain)
    }
}

struct SecondaryButton: View {
    let title: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.kpRounded(size: 16, weight: .semibold))
                .frame(maxWidth: .infinity)
                .frame(height: 52)
                .background(Color.kpCard)
                .foregroundStyle(Color.kpText)
                .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .stroke(Color.kpBorder, lineWidth: 1)
                )
        }
        .buttonStyle(.plain)
    }
}

struct SectionCard: View {
    let title: String
    let items: [String]

    var body: some View {
        KPCard {
            VStack(alignment: .leading, spacing: 12) {
                Text(title)
                    .font(.kpRounded(size: 17, weight: .semibold))
                    .foregroundStyle(Color.kpText)

                ForEach(items, id: \.self) { item in
                    HStack(alignment: .top, spacing: 10) {
                        Circle()
                            .fill(Color.kpPrimary)
                            .frame(width: 7, height: 7)
                            .padding(.top, 7)

                        Text(item)
                            .font(.kpRounded(size: 15))
                            .foregroundStyle(Color.kpSecondaryText)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}
