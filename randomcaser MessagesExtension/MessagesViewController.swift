//
//  MessagesViewController.swift
//  randomcaser MessagesExtension
//
//  Created by Michael Miles on 11/12/19.
//  Copyright © 2019 Michael Miles. All rights reserved.
//

import UIKit
import Messages

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
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    //MARK: UI Setup
    func setupUI() {
        randomizeButton.layer.cornerRadius = 5
        
        copyToClipboardButton.layer.cornerRadius = 5
        copyToClipboardButton.translatesAutoresizingMaskIntoConstraints = true
        
        addToMessageButton.layer.cornerRadius = 5
        addToMessageButton.translatesAutoresizingMaskIntoConstraints = true
        
        sendMessageButton.layer.cornerRadius = 5
        sendMessageButton.translatesAutoresizingMaskIntoConstraints = true
        
        outputLabel.layer.borderColor = UIColor.white.cgColor
        outputLabel.layer.borderWidth = 1
        
        inputTextField.addTarget(self, action: #selector(textDidChange(_:)), for: UIControl.Event.editingChanged)
        
        if #available(iOSApplicationExtension 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
    }
    
    // MARK: - Conversation Handling
    override func willBecomeActive(with conversation: MSConversation) {
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
    }
    
    override func didTransition(to presentationStyle: MSMessagesAppPresentationStyle) {
        if presentationStyle == .expanded {
            inputTextField.becomeFirstResponder()
        }
    }
    
    //MARK: Randomcaser Method
    func randomizeCase(inputText: String) -> String {
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
            activeConversation?.sendText(text) { error in
                print(error?.localizedDescription ?? "Send Message Worked")
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
            activeConversation?.insertText(text) { error in
                print(error?.localizedDescription ?? "Insert Message Worked")
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
            pasteboard.string = text
            copyToClipboardButton.setTitle("Copied!", for: .normal)
        } else {
            copyToClipboardButton.setTitle("Error Copying", for: .normal)
        }
        if self.presentationStyle == .expanded {
            self.requestPresentationStyle(.compact)
        }
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
