import UIKit

/// Defines the color palette for each app theme.
/// PRO users can switch between all themes via the theme picker menu.
enum Theme: String, CaseIterable {
    case sagePark   = "sagePark"   // Park MGM-inspired muted sage green (default)
    case beachClaw  = "beachClaw"  // Earthy orange + light blue
    case royalPurple = "royalPurple" // Light/dark purple
    case redNBlack  = "redNBlack"  // Red and black on lighter red
    case robotic    = "robotic"    // Pure system glass, black/white

    // MARK: - Display

    /// Human-readable name shown in the theme picker UIMenu.
    var displayName: String {
        switch self {
        case .sagePark:    return "Sage Park"
        case .beachClaw:   return "Beach Claw"
        case .royalPurple: return "Royal Purple"
        case .redNBlack:   return "Red n Black"
        case .robotic:     return "Robotic"
        }
    }

    /// Single swatch color for the theme picker menu circle icon.
    var previewColor: UIColor {
        switch self {
        case .sagePark:    return UIColor(red: 0.36, green: 0.48, blue: 0.42, alpha: 1.0)
        case .beachClaw:   return UIColor(red: 0.83, green: 0.64, blue: 0.45, alpha: 1.0)
        case .royalPurple: return UIColor(red: 0.48, green: 0.37, blue: 0.65, alpha: 1.0)
        case .redNBlack:   return UIColor(red: 0.83, green: 0.38, blue: 0.35, alpha: 1.0)
        case .robotic:     return .systemGray
        }
    }

    /// Alternate app icon asset name. nil = use default icon.
    var iconName: String? {
        switch self {
        case .sagePark:    return nil
        case .beachClaw:   return "AppIcon-BeachClaw"
        case .royalPurple: return "AppIcon-RoyalPurple"
        case .redNBlack:   return "AppIcon-RedNBlack"
        case .robotic:     return "AppIcon-Robotic"
        }
    }

    /// When true, buttons use unmodified system glass (no custom tinting).
    /// Only the Robotic theme enables this.
    var isGlassNative: Bool {
        return self == .robotic
    }

    // MARK: - Backgrounds

    var background: UIColor {
        switch self {
        case .sagePark:    return UIColor(red: 0.36, green: 0.48, blue: 0.42, alpha: 1.0)   // #5C7A6B
        case .beachClaw:   return UIColor(red: 0.83, green: 0.64, blue: 0.45, alpha: 1.0)   // #D4A373
        case .royalPurple: return UIColor(red: 0.48, green: 0.37, blue: 0.65, alpha: 1.0)   // #7B5EA7
        case .redNBlack:   return UIColor(red: 0.83, green: 0.38, blue: 0.35, alpha: 1.0)   // #D4615A
        case .robotic:     return .systemBackground
        }
    }

    var outputBackground: UIColor {
        switch self {
        case .sagePark:    return cream.withAlphaComponent(0.25)
        case .beachClaw:   return cream.withAlphaComponent(0.25)
        case .royalPurple: return cream.withAlphaComponent(0.25)
        case .redNBlack:   return cream.withAlphaComponent(0.25)
        case .robotic:     return .secondarySystemBackground
        }
    }

    // MARK: - Buttons

    var primaryButtonBackground: UIColor {
        switch self {
        case .sagePark:    return darkAccent
        case .beachClaw:   return darkAccent
        case .royalPurple: return darkAccent
        case .redNBlack:   return darkAccent
        case .robotic:     return darkAccent
        }
    }

    var primaryButtonText: UIColor {
        switch self {
        case .sagePark:    return cream
        case .beachClaw:   return cream
        case .royalPurple: return cream
        case .redNBlack:   return cream
        case .robotic:     return cream
        }
    }

    var secondaryButtonBackground: UIColor {
        switch self {
        case .sagePark:    return cream
        case .beachClaw:   return cream
        case .royalPurple: return cream
        case .redNBlack:   return UIColor(red: 0.69, green: 0.23, blue: 0.18, alpha: 1.0) // #B03A2E
        case .robotic:     return cream
        }
    }

    var secondaryButtonText: UIColor {
        switch self {
        case .sagePark:    return darkAccent
        case .beachClaw:   return darkAccent
        case .royalPurple: return darkAccent
        case .redNBlack:   return cream
        case .robotic:     return darkAccent
        }
    }

    var subtleButtonBackground: UIColor {
        switch self {
        case .sagePark:    return UIColor(red: 0.88, green: 0.85, blue: 0.80, alpha: 1.0) // #E0D9CC
        case .beachClaw:   return UIColor(red: 0.72, green: 0.83, blue: 0.88, alpha: 1.0) // #B7D3E0
        case .royalPurple: return UIColor(red: 0.84, green: 0.78, blue: 0.93, alpha: 1.0) // #D5C7ED
        case .redNBlack:   return UIColor(red: 0.88, green: 0.85, blue: 0.80, alpha: 1.0) // fallback sand
        case .robotic:     return .systemGray5
        }
    }

    var subtleButtonText: UIColor {
        switch self {
        case .sagePark:    return darkAccent
        case .beachClaw:   return darkAccent
        case .royalPurple: return darkAccent
        case .redNBlack:   return darkAccent
        case .robotic:     return .label
        }
    }

    // MARK: - Text

    var outputText: UIColor {
        switch self {
        case .sagePark:    return cream
        case .beachClaw:   return cream
        case .royalPurple: return cream
        case .redNBlack:   return cream
        case .robotic:     return .label
        }
    }

    // MARK: - Glass tint (iOS 26+)

    /// The tint color applied to Liquid Glass button materials.
    var glassTint: UIColor {
        switch self {
        case .sagePark:    return darkAccent
        case .beachClaw:   return darkAccent
        case .royalPurple: return darkAccent
        case .redNBlack:   return darkAccent
        case .robotic:     return .clear // unused; native glass skips custom tinting
        }
    }

    // MARK: - Base colors

    var cream: UIColor {
        switch self {
        case .sagePark:    return UIColor(red: 0.96, green: 0.95, blue: 0.93, alpha: 1.0) // #F5F2ED
        case .beachClaw:   return UIColor(red: 1.00, green: 0.98, blue: 0.88, alpha: 1.0) // #FEFAE0
        case .royalPurple: return UIColor(red: 0.95, green: 0.94, blue: 0.98, alpha: 1.0) // #F3EFFA
        case .redNBlack:   return UIColor(red: 0.98, green: 0.91, blue: 0.90, alpha: 1.0) // #FAE8E6
        case .robotic:     return .white
        }
    }

    var darkAccent: UIColor {
        switch self {
        case .sagePark:    return UIColor(red: 0.24, green: 0.36, blue: 0.29, alpha: 1.0) // #3D5C4A
        case .beachClaw:   return UIColor(red: 0.42, green: 0.23, blue: 0.16, alpha: 1.0) // #6B3A2A
        case .royalPurple: return UIColor(red: 0.24, green: 0.16, blue: 0.36, alpha: 1.0) // #3C2A5C
        case .redNBlack:   return UIColor(red: 0.10, green: 0.10, blue: 0.10, alpha: 1.0) // #1A1A1A
        case .robotic:     return .black
        }
    }

    // MARK: - Persistence

    private static let storageKey = "SelectedTheme"

    /// The user's currently selected theme, defaults to .sagePark.
    /// Handles migration from the legacy "sage" raw value.
    static var current: Theme {
        get {
            guard let raw = UserDefaults.standard.string(forKey: storageKey) else { return .sagePark }
            // Migrate legacy "sage" → "sagePark"
            if raw == "sage" { return .sagePark }
            return Theme(rawValue: raw) ?? .sagePark
        }
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: storageKey)
        }
    }
}
