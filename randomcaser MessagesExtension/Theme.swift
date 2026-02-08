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
        case .redNBlack:   return UIColor(red: 0.72, green: 0.07, blue: 0.20, alpha: 1.0)
        case .robotic:     return .systemGray
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
        case .redNBlack:   return UIColor(red: 0.72, green: 0.07, blue: 0.20, alpha: 1.0)   // #B81234 UGA red
        case .robotic:     return .systemBackground
        }
    }

    var outputBackground: UIColor {
        switch self {
        case .sagePark:    return cream.withAlphaComponent(0.25)
        case .beachClaw:   return UIColor(red: 0.72, green: 0.83, blue: 0.88, alpha: 0.4)  // light blue tint
        case .royalPurple: return cream.withAlphaComponent(0.25)
        case .redNBlack:   return UIColor.black.withAlphaComponent(0.85)
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
        case .redNBlack:   return .black
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

    var actionButtonBackground: UIColor {
        switch self {
        case .sagePark:    return UIColor(red: 0.65, green: 0.62, blue: 0.54, alpha: 1.0) // #A69E8A warm bronze
        case .beachClaw:   return UIColor(red: 0.38, green: 0.60, blue: 0.72, alpha: 1.0) // #6199B8 ocean blue
        case .royalPurple: return UIColor(red: 0.58, green: 0.46, blue: 0.78, alpha: 1.0) // #9475C7 vivid purple
        case .redNBlack:   return darkAccent   // black
        case .robotic:     return .black
        }
    }

    var actionButtonText: UIColor {
        switch self {
        case .sagePark:    return cream
        case .beachClaw:   return cream
        case .royalPurple: return cream
        case .redNBlack:   return cream
        case .robotic:     return .white
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
        case .redNBlack:   return .white
        case .robotic:     return .white
        }
    }

    var darkAccent: UIColor {
        switch self {
        case .sagePark:    return UIColor(red: 0.24, green: 0.36, blue: 0.29, alpha: 1.0) // #3D5C4A
        case .beachClaw:   return UIColor(red: 0.42, green: 0.23, blue: 0.16, alpha: 1.0) // #6B3A2A
        case .royalPurple: return UIColor(red: 0.24, green: 0.16, blue: 0.36, alpha: 1.0) // #3C2A5C
        case .redNBlack:   return .black
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
