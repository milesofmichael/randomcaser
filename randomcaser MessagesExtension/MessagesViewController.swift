//
//  MessagesViewController.swift
//  randomcaser MessagesExtension
//
//  Created by Michael Miles on 11/12/19.
//  Copyright © 2019 Michael Miles. All rights reserved.
//

import UIKit
import Messages
import StoreKit

enum CharCase: CaseIterable {
    case upper
    case lower
}

class MessagesViewController: MSMessagesAppViewController {

    // MARK: - Outlets (connected in storyboard)

    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var outputLabel: UILabel!
    @IBOutlet weak var randomizeButton: StyledButton!
    @IBOutlet weak var sendMessageButton: StyledButton!
    @IBOutlet weak var addToMessageButton: StyledButton!
    @IBOutlet weak var copyToClipboardButton: StyledButton!
    @IBOutlet weak var goProButton: StyledButton!
    @IBOutlet weak var restorePurchaseButton: StyledButton!

    // MARK: - Properties

    /// Scroll view wrapping all content; created programmatically in setupScrollLayout().
    private var scrollView: UIScrollView!

    /// Theme picker button shown to PRO users, created programmatically.
    private var switchThemeButton: StyledButton!

    /// Pending title-revert timers per button, so they can be cancelled on re-press or new input.
    private var titleRevertWorkItems: [UIButton: DispatchWorkItem] = [:]

    let defaults = UserDefaults.standard
    var isProUser = false

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - UI Setup

    func setupUI() {
        // Let Liquid Glass adapt naturally on iOS 26+; force light on older versions
        if #unavailable(iOS 26.0) {
            overrideUserInterfaceStyle = .light
        }

        // Create the Switch Theme button programmatically
        switchThemeButton = StyledButton(type: .system)
        switchThemeButton.setTitle("🎨 Themes", for: .normal)
        switchThemeButton.tier = .action

        // Assign button visual tiers
        randomizeButton.tier = .primary
        copyToClipboardButton.tier = .secondary
        addToMessageButton.tier = .secondary
        sendMessageButton.tier = .secondary
        goProButton.tier = .action
        restorePurchaseButton.tier = .action

        // Build the scroll view + vertical stack layout programmatically
        setupScrollLayout()

        inputTextField.addTarget(self, action: #selector(textDidChange(_:)), for: UIControl.Event.editingChanged)

        applyTheme(Theme.current)
        applyCornerStyling()

        // Update Go PRO button text
        goProButton.setTitle("Go PRO - Support Us + Unlock All Themes -- One-Time Purchase, No Subscription!", for: .normal)

        // Show/hide buttons based on PRO status
        if isProUser {
            goProButton.isHidden = true
            restorePurchaseButton.isHidden = true
            switchThemeButton.isHidden = false
            configureSwitchThemeMenu()
        } else {
            goProButton.isHidden = false
            restorePurchaseButton.isHidden = false
            switchThemeButton.isHidden = true
        }
    }

    /// Tears down the storyboard layout and rebuilds it as a scrollable vertical stack.
    /// The storyboard is only used for view instantiation and IBOutlet/IBAction connections.
    private func setupScrollLayout() {
        // Remove views from storyboard hierarchy
        view.subviews.forEach { $0.removeFromSuperview() }
        view.removeConstraints(view.constraints)

        let elements: [UIView] = [
            inputTextField, outputLabel,
            randomizeButton, sendMessageButton,
            addToMessageButton, copyToClipboardButton,
            switchThemeButton,
            goProButton, restorePurchaseButton
        ]

        // Scroll view — allows content to scroll in compact iMessage tray
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.keyboardDismissMode = .onDrag
        scrollView.alwaysBounceVertical = true
        view.addSubview(scrollView)
        self.scrollView = scrollView

        // Vertical stack — holds all elements in a single column
        let stackView = UIStackView(arrangedSubviews: elements)
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.alignment = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(stackView)

        elements.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }

        let guide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: guide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: guide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: guide.bottomAnchor),

            stackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 6),
            stackView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor, constant: 14),
            stackView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor, constant: -14),
            stackView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -6),

            stackView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor, constant: -28),

            inputTextField.heightAnchor.constraint(equalToConstant: 48),
            outputLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 44),
            randomizeButton.heightAnchor.constraint(greaterThanOrEqualToConstant: 44),
            copyToClipboardButton.heightAnchor.constraint(greaterThanOrEqualToConstant: 44),
            addToMessageButton.heightAnchor.constraint(greaterThanOrEqualToConstant: 44),
            sendMessageButton.heightAnchor.constraint(greaterThanOrEqualToConstant: 44),
            switchThemeButton.heightAnchor.constraint(greaterThanOrEqualToConstant: 44),
            goProButton.heightAnchor.constraint(greaterThanOrEqualToConstant: 44),
            restorePurchaseButton.heightAnchor.constraint(greaterThanOrEqualToConstant: 44),
        ])
    }

    /// Applies the theme's color palette to the root view and content elements.
    /// Buttons style themselves via StyledButton.applyStyle() based on their tier.
    func applyTheme(_ theme: Theme) {
        view.backgroundColor = theme.background

        outputLabel.backgroundColor = theme.outputBackground
        outputLabel.textColor = theme.outputText

        // Buttons self-style from their tier + the current theme
        let buttons: [StyledButton] = [
            randomizeButton, copyToClipboardButton,
            addToMessageButton, sendMessageButton,
            goProButton, restorePurchaseButton,
            switchThemeButton
        ].compactMap { $0 }
        buttons.forEach { $0.applyStyle() }
    }

    /// Applies rounded corners using the modern cornerConfiguration API on iOS 26+
    /// or the classic layer.cornerRadius on earlier versions.
    private func applyCornerStyling() {
        // Remove default rounded rect border so custom corner radius takes effect,
        // then add left padding. Don't set rightView — it conflicts with clearButton.
        inputTextField.borderStyle = .none
        inputTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 1))
        inputTextField.leftViewMode = .always

        if #available(iOS 26.0, *) {
            inputTextField.cornerConfiguration = .capsule()
        } else {
            inputTextField.layer.cornerRadius = 24
            inputTextField.clipsToBounds = true
        }

        // UILabel doesn't fully support cornerConfiguration, so use layer directly
        outputLabel.layer.cornerRadius = 24
        outputLabel.clipsToBounds = true
    }

    // MARK: - Theme Picker

    /// Configures the Switch Theme button with a UIMenu dropdown listing all themes.
    /// Each menu item shows a colored circle swatch and a checkmark for the active theme.
    private func configureSwitchThemeMenu() {
        let currentTheme = Theme.current

        let actions = Theme.allCases.map { theme in
            UIAction(
                title: theme.displayName,
                image: circleImage(color: theme.previewColor, size: 22),
                state: theme == currentTheme ? .on : .off
            ) { [weak self] _ in
                Theme.current = theme
                print("Theme switched to: \(theme.displayName)")
                // Delay ALL UI updates until menu dismiss animation finishes
                // so the entire theme flips at once (including this button).
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    self?.applyTheme(theme)
                    self?.configureSwitchThemeMenu()
                    self?.updateAppIcon(for: theme)
                }
            }
        }

        switchThemeButton.menu = UIMenu(title: "", children: actions)
        switchThemeButton.showsMenuAsPrimaryAction = true
    }

    /// Renders a filled circle UIImage in the given color, used as a swatch in the theme menu.
    private func circleImage(color: UIColor, size: CGFloat) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: size, height: size))
        return renderer.image { ctx in
            color.setFill()
            ctx.cgContext.fillEllipse(in: CGRect(x: 0, y: 0, width: size, height: size))
        }
    }

    /// Stub for switching the app icon to match the selected theme.
    /// iMessage extensions don't have access to UIApplication.shared,
    /// so this logs the intent and is ready to uncomment if a containing app is added.
    private func updateAppIcon(for theme: Theme) {
        let iconName = theme.iconName ?? "Default"
        print("App icon would switch to: \(iconName)")
        // Uncomment when a containing app provides UIApplication access:
        // UIApplication.shared.setAlternateIconName(theme.iconName) { error in
        //     if let error { print("Icon switch failed: \(error.localizedDescription)") }
        // }
    }

    // MARK: - Conversation Handling

    override func willBecomeActive(with conversation: MSConversation) {
        isProUser = true

        setupUI()

        if let savedString = defaults.string(forKey: "Initial Text") {
            inputTextField.text = savedString
            outputLabel.text = randomizeCase(inputText: savedString)
        } else {
            print("Saved string == nil")
        }
    }

    override func didBecomeActive(with conversation: MSConversation) {
        // Hide iMessage-only buttons when not in a conversation context
        if activeConversation == nil {
            sendMessageButton.isHidden = true
            addToMessageButton.isHidden = true
        }
    }

    override func didResignActive(with conversation: MSConversation) {
        if let text = inputTextField.text {
            if text.isEmpty {
                defaults.set(nil, forKey: "Initial Text")
            } else {
                defaults.set(text, forKey: "Initial Text")
            }
        } else {
            defaults.set(nil, forKey: "Initial Text")
        }

        if isProUser {
            defaults.set(true, forKey: "Is Pro User")
        }
    }

    override func didTransition(to presentationStyle: MSMessagesAppPresentationStyle) {
        if presentationStyle == .expanded {
            inputTextField.becomeFirstResponder()
        }
    }

    // MARK: - Randomcasing Method

    private func randomizeCase(inputText: String) -> String {
        var output = ""

        for char in inputText {
            let random = CharCase.allCases.randomElement()
            switch random {
            case .upper:
                let upper = char.uppercased()
                output.append(upper)
            case .lower:
                let lower = char.lowercased()
                output.append(lower)
            case .none:
                fatalError("random enum was empty")
            }
        }

        return output
    }

    // MARK: - Button Actions

    @IBAction func randomizeButtonPressed(_ sender: Any) {
        cancelAllTitleReverts()
        sendMessageButton.setTitle("Send Message", for: .normal)
        addToMessageButton.setTitle("Add to Message Box", for: .normal)
        copyToClipboardButton.setTitle("Copy to Clipboard", for: .normal)
        outputLabel.text = randomizeCase(inputText: outputLabel.text ?? "rAndOmIZeD rEsULt AppEArS hERe")
    }

    @IBAction func sendMessagePressed(_ sender: Any) {
        if let text = outputLabel.text {
            if text == "rAndOmIZeD rEsULt AppEArS hERe" {
                noTextPopup()
                return
            }
            activeConversation?.sendText(text) { error in
                print(error?.localizedDescription ?? "Message sent successfully")
            }
            flashTitle("Sent!", on: sendMessageButton, revertTo: "Send Message")
        } else {
            flashTitle("Error", on: sendMessageButton, revertTo: "Send Message")
        }
        if self.presentationStyle == .expanded {
            self.requestPresentationStyle(.compact)
        }
    }

    @IBAction func addToMessageButtonPressed(_ sender: Any) {
        if let text = outputLabel.text {
            if text == "rAndOmIZeD rEsULt AppEArS hERe" {
                noTextPopup()
                return
            }
            activeConversation?.insertText(text) { error in
                print(error?.localizedDescription ?? "Message added to message box")
            }
            flashTitle("Added!", on: addToMessageButton, revertTo: "Add to Message Box")
        } else {
            flashTitle("Error", on: addToMessageButton, revertTo: "Add to Message Box")
        }
        if self.presentationStyle == .expanded {
            self.requestPresentationStyle(.compact)
        }
    }

    @IBAction func copyButtonPressed(_ sender: Any) {
        let pasteboard = UIPasteboard.general
        if let text = outputLabel.text {
            if text == "rAndOmIZeD rEsULt AppEArS hERe" {
                noTextPopup()
                return
            }
            pasteboard.string = text
            flashTitle("Copied!", on: copyToClipboardButton, revertTo: "Copy to Clipboard")
        } else {
            flashTitle("Error Copying", on: copyToClipboardButton, revertTo: "Copy to Clipboard")
        }
        if self.presentationStyle == .expanded {
            self.requestPresentationStyle(.compact)
        }
    }

    /// Temporarily shows feedback text on a button, then cross-dissolves back
    /// to the original title after 3 seconds. Cancels any pending revert for that button.
    private func flashTitle(_ temporary: String, on button: StyledButton, revertTo original: String) {
        titleRevertWorkItems[button]?.cancel()
        button.setTitle(temporary, for: .normal)

        let workItem = DispatchWorkItem { [weak self] in
            UIView.transition(with: button, duration: 0.3, options: .transitionCrossDissolve) {
                button.setTitle(original, for: .normal)
            }
            self?.titleRevertWorkItems.removeValue(forKey: button)
        }
        titleRevertWorkItems[button] = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: workItem)
    }

    /// Cancels all pending title-revert timers and immediately restores original titles.
    private func cancelAllTitleReverts() {
        titleRevertWorkItems.values.forEach { $0.cancel() }
        titleRevertWorkItems.removeAll()
    }

    private func noTextPopup() {
        let alert = UIAlertController(title: "No Text Available", message: "Start typing in the text box to get started!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }

}

// MARK: - Text Field Methods

extension MessagesViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if self.presentationStyle == .compact {
            self.requestPresentationStyle(.expanded)
        }
    }

    @objc func textDidChange(_ textField: UITextField) {
        cancelAllTitleReverts()
        sendMessageButton.setTitle("Send Message", for: .normal)
        addToMessageButton.setTitle("Add to Message Box", for: .normal)
        copyToClipboardButton.setTitle("Copy to Clipboard", for: .normal)

        if let text = textField.text {
            if text.isEmpty {
                outputLabel.text = "rAndOmIZeD rEsULt AppEArS hERe"
            } else {
                outputLabel.text = randomizeCase(inputText: text)
            }
        } else {
            outputLabel.text = "rAndOmIZeD rEsULt AppEArS hERe"
        }
    }
}

// MARK: - In-App Purchase Handling

extension MessagesViewController: SKPaymentTransactionObserver {
    /// Payment queue observer method - called from any thread by StoreKit
    /// Marked nonisolated to avoid Swift 6 concurrency warnings, with manual main actor dispatch for UI updates
    nonisolated func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchased:
                print("Purchase worked!")
                Task { @MainActor in
                    self.isProUser = true
                    self.setupUI()
                }
            case .restored:
                print("Purchase restored.")
                Task { @MainActor in
                    self.isProUser = true
                    self.setupUI()
                }
            case .failed:
                print(transaction.error!.localizedDescription)
                print(transaction.transactionIdentifier ?? "Payment failed w/ no transaction ID.")
            default:
                print("Default called")
            }
        }
    }

    @IBAction func goProPressed(_ sender: Any) {
        SKPaymentQueue.default().add(self)
        if SKPaymentQueue.canMakePayments() {
            let paymentRequest = SKMutablePayment()
            paymentRequest.productIdentifier = "com.michaelgagemiles.randomcaser.proversion"
            SKPaymentQueue.default().add(paymentRequest)
        } else {
            print("SKPaymentQueue didn't work")
        }
    }

    @IBAction func restoreButtonPressed(_ sender: Any) {
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
}
