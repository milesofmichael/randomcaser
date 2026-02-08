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
    
    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var outputLabel: UILabel!
    @IBOutlet weak var randomizeButton: UIButton!
    @IBOutlet weak var sendMessageButton: UIButton!
    @IBOutlet weak var addToMessageButton: UIButton!
    @IBOutlet weak var copyToClipboardButton: UIButton!
    @IBOutlet weak var goProButton: UIButton!
    @IBOutlet weak var restorePurchaseButton: UIButton!
    
    let defaults = UserDefaults.standard
    
    var isProUser = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    //MARK: UI Setup
    func setupUI() {
        overrideUserInterfaceStyle = .light

        // These buttons need autoresizing for programmatic layout adjustments
        copyToClipboardButton.translatesAutoresizingMaskIntoConstraints = true
        addToMessageButton.translatesAutoresizingMaskIntoConstraints = true
        sendMessageButton.translatesAutoresizingMaskIntoConstraints = true

        inputTextField.addTarget(self, action: #selector(textDidChange(_:)), for: UIControl.Event.editingChanged)

        applyTheme(Theme.current)

        if isProUser {
            restorePurchaseButton.isHidden = true
            goProButton.isUserInteractionEnabled = false
            goProButton.setTitle("Thanks for being a PRO user!", for: .normal)
        }
    }

    /// Applies the given theme's color palette to all UI elements.
    /// Storyboard handles layout (constraints, corner radii); this handles color.
    func applyTheme(_ theme: Theme) {
        view.backgroundColor = theme.background

        // Primary action button
        randomizeButton.backgroundColor = theme.primaryButtonBackground
        randomizeButton.setTitleColor(theme.primaryButtonText, for: .normal)

        // Secondary action buttons
        for button in [copyToClipboardButton, addToMessageButton, sendMessageButton] {
            button?.backgroundColor = theme.secondaryButtonBackground
            button?.setTitleColor(theme.secondaryButtonText, for: .normal)
        }

        // Subtle pro/restore buttons
        goProButton.backgroundColor = theme.subtleButtonBackground
        goProButton.setTitleColor(theme.subtleButtonText, for: .normal)
        restorePurchaseButton.backgroundColor = theme.subtleButtonBackground
        restorePurchaseButton.setTitleColor(theme.subtleButtonText, for: .normal)

        // Output label
        outputLabel.backgroundColor = theme.outputBackground
        outputLabel.textColor = theme.outputText
    }
    
    // MARK: - Conversation Handling
    override func willBecomeActive(with conversation: MSConversation) {
        isProUser = defaults.bool(forKey: "Is Pro User")
        
        setupUI()
        
        if let savedString = defaults.string(forKey: "Initial Text") {
            inputTextField.text = savedString
            outputLabel.text = randomizeCase(inputText: savedString)
        } else {
            print("Saved string == nil")
        }
    }
    
    override func didBecomeActive(with conversation: MSConversation) {
        if activeConversation == nil {
            sendMessageButton.removeFromSuperview()
            addToMessageButton.removeFromSuperview()
            view.addConstraint(NSLayoutConstraint(item: copyToClipboardButton!, attribute: .top, relatedBy: .equal, toItem: randomizeButton, attribute: .bottom, multiplier: 1, constant: 8))
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
    
    //MARK: Randomcasing Method
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
    
    //MARK: Button IBActions
    @IBAction func randomizeButtonPressed(_ sender: Any) {
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
            if isProUser {
                activeConversation?.sendText(text) { error in
                    print(error?.localizedDescription ?? "Insert message worked as PRO user")
                }
            } else {
                activeConversation?.sendText("\(text)\n\n-Powered by the RandomCaser iMessage App") { error in
                    print(error?.localizedDescription ?? "Insert message worked as non-PRO user")
                }
            }
            sendMessageButton.setTitle("Sent!", for: .normal)
        } else {
            sendMessageButton.setTitle("Error", for: .normal)
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
            if isProUser {
                activeConversation?.insertText(text) { error in
                    print(error?.localizedDescription ?? "Insert message worked as PRO user")
                }
            } else {
                activeConversation?.insertText("\(text)\n\n-Powered by the RandomCaser iMessage App") { error in
                    print(error?.localizedDescription ?? "Insert message worked as non-PRO user")
                }
            }
            addToMessageButton.setTitle("Added!", for: .normal)
            
        } else {
            addToMessageButton.setTitle("Error", for: .normal)
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
            if isProUser {
                pasteboard.string = text
            } else {
                pasteboard.string = "\(text)\n\n-Powered by the RandomCaser iMessage App"
            }
            copyToClipboardButton.setTitle("Copied!", for: .normal)
        } else {
            copyToClipboardButton.setTitle("Error Copying", for: .normal)
        }
        if self.presentationStyle == .expanded {
            self.requestPresentationStyle(.compact)
        }
    }
    
    private func noTextPopup() {
        let alert = UIAlertController(title: "No Text Available", message: "Start typing in the text box to get started!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
}

//MARK: Text Field Methods
extension MessagesViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if self.presentationStyle == .compact {
            self.requestPresentationStyle(.expanded)
        }
    }
    
    @objc func textDidChange(_ textField: UITextField) {
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

//MARK: In-App Purchase Handling
extension MessagesViewController: SKPaymentTransactionObserver {
    /// Payment queue observer method - called from any thread by StoreKit
    /// Marked nonisolated to avoid Swift 6 concurrency warnings, with manual main actor dispatch for UI updates
    nonisolated func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchased:
                print("Purchase worked!")
                // Dispatch UI updates to main actor
                Task { @MainActor in
                    self.isProUser = true
                    self.setupUI()
                }
            case .restored:
                print("Purchase restored.")
                // Dispatch UI updates to main actor
                Task { @MainActor in
                    self.isProUser = true
                    self.setupUI()
                }
            case .failed:
                print(transaction.error!.localizedDescription)
                print(transaction.transactionIdentifier ?? "Payment failed w/ no transaction ID.")
//                inAppPurchaseFailNotice()
            default:
                print("Default called")
            }
        }
    }
    
//    private func inAppPurchaseFailNotice() {
//        let alert = UIAlertController(title: "In-App Purchase Failed", message: "Check your internet connection/payment methods and try again!", preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
//        self.present(alert, animated: true)
//    }
    
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
