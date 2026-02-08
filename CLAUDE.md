# RandomCaser

iMessage extension (only) that randomizes text case and sends messages. Written in Swift.

## Build & Test
- Use xcbeautify for all builds: `xcodebuild ... | xcbeautify`
- Test on iPhone 17 Pro simulator

## In-App Purchases
- uses StoreKit 1

## Theming
- in Theme.swift

## UI
- colors are applied in MessagesViewController
- UI elements/modifiers done in Main.storyboard and setupScrollLayout()
- buttons are maintained in StyledButton.swift
- uses liquid glass in iOS 26+, backwards compatible with older versions
