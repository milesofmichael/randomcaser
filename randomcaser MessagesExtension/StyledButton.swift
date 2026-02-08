import UIKit

/// Defines visual tiers for buttons, controlling their prominence in the UI.
/// Each tier maps to a distinct Liquid Glass style on iOS 26+
/// and a themed opaque background on earlier versions.
enum ButtonTier {
    /// Bold, primary action (e.g. Re-Randomize). Uses prominentGlass on iOS 26+.
    case primary
    /// Standard action (e.g. Copy, Send). Uses glass on iOS 26+.
    case secondary
    /// Vibrant themed action (e.g. Switch Theme, Go PRO). Uses prominentGlass with theme tint on iOS 26+.
    case action
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

        if theme.isGlassNative {
            // Robotic theme: system glass with minimal tinting
            switch tier {
            case .primary:
                var config = UIButton.Configuration.prominentGlass()
                config.title = currentTitle
                config.baseForegroundColor = .white
                applyMultilineLayout(to: &config)
                configuration = config
                tintColor = nil
            case .secondary:
                var config = UIButton.Configuration.glass()
                config.title = currentTitle
                config.baseForegroundColor = .label
                applyMultilineLayout(to: &config)
                configuration = config
                tintColor = nil
            case .action:
                var config = UIButton.Configuration.prominentGlass()
                config.title = currentTitle
                config.baseForegroundColor = .white
                applyMultilineLayout(to: &config, bold: true)
                configuration = config
                tintColor = .black
            }
        } else {
            // Themed glass: apply custom tint colors per tier
            switch tier {
            case .primary:
                var config = UIButton.Configuration.prominentGlass()
                config.title = currentTitle
                config.baseForegroundColor = .white
                applyMultilineLayout(to: &config)
                configuration = config
                tintColor = theme.darkAccent

            case .secondary:
                var config = UIButton.Configuration.prominentGlass()
                config.title = currentTitle
                config.baseForegroundColor = theme.darkAccent
                applyMultilineLayout(to: &config)
                configuration = config
                tintColor = .white

            case .action:
                var config = UIButton.Configuration.prominentGlass()
                config.title = currentTitle
                config.baseForegroundColor = theme.actionButtonText
                applyMultilineLayout(to: &config, bold: true)
                configuration = config
                tintColor = theme.actionButtonBackground
            }
        }

        cornerConfiguration = .capsule()
    }

    /// Configures a button configuration for centered, word-wrapping multiline text
    /// with compact vertical padding suited for the iMessage tray.
    private func applyMultilineLayout(to config: inout UIButton.Configuration, bold: Bool = false) {
        config.titleLineBreakMode = .byWordWrapping
        config.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12)
        config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var out = incoming
            let paragraph = NSMutableParagraphStyle()
            paragraph.alignment = .center
            out.paragraphStyle = paragraph
            if bold {
                out.font = UIFont.boldSystemFont(ofSize: UIFont.buttonFontSize)
            }
            return out
        }
    }

    // MARK: - Legacy (iOS < 26)

    private func applyLegacyStyle(theme: Theme) {
        // Use UIButton.Configuration for pre-glass iOS (15+) to get
        // multiline centered text with compact padding and avoid deprecation warnings.
        var config = UIButton.Configuration.filled()
        config.title = currentTitle
        config.cornerStyle = .capsule
        let isBold = tier == .action
        applyMultilineLayout(to: &config, bold: isBold)

        switch tier {
        case .primary:
            config.baseBackgroundColor = theme.primaryButtonBackground
            config.baseForegroundColor = theme.primaryButtonText
        case .secondary:
            config.baseBackgroundColor = theme.secondaryButtonBackground
            config.baseForegroundColor = theme.secondaryButtonText
        case .action:
            config.baseBackgroundColor = theme.actionButtonBackground
            config.baseForegroundColor = theme.actionButtonText
        }

        configuration = config
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
