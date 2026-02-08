import UIKit

/// Defines the color palette for each app theme.
/// Add new cases here to support additional themes.
enum Theme: String, CaseIterable {
    case sage // Park MGM-inspired muted sage green

    // MARK: - Backgrounds

    var background: UIColor {
        switch self {
        case .sage: return UIColor(red: 0.36, green: 0.48, blue: 0.42, alpha: 1.0)   // #5C7A6B
        }
    }

    var outputBackground: UIColor {
        switch self {
        case .sage: return cream.withAlphaComponent(0.25)
        }
    }

    // MARK: - Buttons

    var primaryButtonBackground: UIColor {
        switch self {
        case .sage: return darkAccent
        }
    }

    var primaryButtonText: UIColor {
        switch self {
        case .sage: return cream
        }
    }

    var secondaryButtonBackground: UIColor {
        switch self {
        case .sage: return cream
        }
    }

    var secondaryButtonText: UIColor {
        switch self {
        case .sage: return darkAccent
        }
    }

    var subtleButtonBackground: UIColor {
        switch self {
        // Warm sand — lighter than cream, nods to Park MGM's marble/stone tones
        case .sage: return UIColor(red: 0.88, green: 0.85, blue: 0.80, alpha: 1.0)  // #E0D9CC
        }
    }

    var subtleButtonText: UIColor {
        switch self {
        case .sage: return darkAccent
        }
    }

    // MARK: - Text

    var outputText: UIColor {
        switch self {
        case .sage: return cream
        }
    }

    // MARK: - Glass tint (iOS 26+)

    /// The tint color applied to Liquid Glass button materials.
    var glassTint: UIColor {
        switch self {
        case .sage: return darkAccent
        }
    }

    // MARK: - Base colors

    var cream: UIColor {
        switch self {
        case .sage: return UIColor(red: 0.96, green: 0.95, blue: 0.93, alpha: 1.0)   // #F5F2ED
        }
    }

    var darkAccent: UIColor {
        switch self {
        case .sage: return UIColor(red: 0.24, green: 0.36, blue: 0.29, alpha: 1.0)   // #3D5C4A
        }
    }

    // MARK: - Persistence

    private static let storageKey = "SelectedTheme"

    /// The user's currently selected theme, defaults to .sage
    static var current: Theme {
        get {
            guard let raw = UserDefaults.standard.string(forKey: storageKey),
                  let theme = Theme(rawValue: raw) else { return .sage }
            return theme
        }
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: storageKey)
        }
    }
}
