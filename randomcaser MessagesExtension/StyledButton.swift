import UIKit

/// Defines visual tiers for buttons, controlling their prominence in the UI.
/// Each tier maps to a distinct Liquid Glass style on iOS 26+
/// and a themed opaque background on earlier versions.
enum ButtonTier {
    /// Bold, primary action (e.g. Re-Randomize). Uses prominentGlass on iOS 26+.
    case primary
    /// Standard action (e.g. Copy, Send). Uses glass on iOS 26+.
    case secondary
    /// De-emphasized action (e.g. Go PRO, Restore). Uses lighter glass on iOS 26+.
    case subtle
}

/// A UIButton subclass that applies consistent styling based on its `tier` and the current theme.
/// Automatically uses Liquid Glass on iOS 26+ with themed tint colors,
/// falling back to opaque themed backgrounds on earlier iOS versions.
class StyledButton: UIButton {

    /// The visual tier for this button. Setting this triggers a style update.
    var tier: ButtonTier = .secondary {
        didSet { applyStyle() }
    }

    /// Applies the correct visual treatment based on tier and OS version.
    func applyStyle() {
        let theme = Theme.current

        if #available(iOS 26.0, *) {
            applyGlassStyle(theme: theme)
        } else {
            applyLegacyStyle(theme: theme)
        }
    }

    // MARK: - iOS 26+ Liquid Glass

    @available(iOS 26.0, *)
    private func applyGlassStyle(theme: Theme) {
        let currentTitle = currentTitle

        switch tier {
        case .primary:
            var config = UIButton.Configuration.glass()
            config.title = currentTitle
            config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { attrs in
                var out = attrs
                out.foregroundColor = .white
                return out
            }
            configuration = config
            tintColor = theme.darkAccent

        case .secondary:
            var config = UIButton.Configuration.glass()
            config.title = currentTitle
            config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { [theme] attrs in
                var out = attrs
                out.foregroundColor = theme.darkAccent
                return out
            }
            configuration = config
            tintColor = theme.darkAccent

        case .subtle:
            var config = UIButton.Configuration.prominentGlass()
            config.title = currentTitle
            config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { [theme] attrs in
                var out = attrs
                out.foregroundColor = theme.darkAccent
                return out
            }
            configuration = config
            tintColor = theme.cream
        }

        cornerConfiguration = .capsule()
    }

    // MARK: - Legacy (iOS < 26)

    private func applyLegacyStyle(theme: Theme) {
        switch tier {
        case .primary:
            backgroundColor = theme.primaryButtonBackground
            setTitleColor(theme.primaryButtonText, for: .normal)
        case .secondary:
            backgroundColor = theme.secondaryButtonBackground
            setTitleColor(theme.secondaryButtonText, for: .normal)
        case .subtle:
            backgroundColor = theme.subtleButtonBackground
            setTitleColor(theme.subtleButtonText, for: .normal)
        }

        layer.cornerRadius = 22
        clipsToBounds = true
    }

    // MARK: - Title Sync

    /// Keeps the UIButton.Configuration title in sync when callers use the legacy setTitle API.
    override func setTitle(_ title: String?, for state: UIControl.State) {
        super.setTitle(title, for: state)
        if state == .normal {
            configuration?.title = title
        }
    }
}
