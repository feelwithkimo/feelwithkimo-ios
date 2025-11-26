//
//  AccessibilityManager.swift
//  feelwithkimo
//
//  Created by Ferdinand Lunardy on 27/10/25.
//
import Foundation
import UIKit
import SwiftUI

/// Comprehensive accessibility manager for VoiceOver support throughout the app
final class AccessibilityManager: ObservableObject {
    static let shared = AccessibilityManager()
    
    private init() {}
    
    /// Checks if VoiceOver is currently running (static method)
    static var isVoiceOverRunning: Bool {
        return UIAccessibility.isVoiceOverRunning
    }
    
    /// Checks if VoiceOver is currently running (instance method)
    var isVoiceOverRunning: Bool {
        return UIAccessibility.isVoiceOverRunning
    }
    
    /// Posts an accessibility announcement that works well with VoiceOver
    static func announce(_ message: String, important: Bool = false) {
        // Only announce if VoiceOver is running
        guard isVoiceOverRunning else { return }
        
        DispatchQueue.main.async {
            var announcement = message
            
            // Add priority prefix for important announcements
            if important {
                announcement = "Penting: \(message)"
            }
            
            UIAccessibility.post(notification: .announcement, argument: announcement)
        }
    }
    
    /// Instance method for announcements
    func announce(_ message: String, important: Bool = false) {
        AccessibilityManager.announce(message, important: important)
    }
    
    /// Posts a screen changed notification for major navigation
    static func announceScreenChange(_ message: String? = nil) {
        DispatchQueue.main.async {
            UIAccessibility.post(notification: .screenChanged, argument: message)
        }
    }
    
    /// Instance method for screen changes
    func announceScreenChange(_ message: String? = nil) {
        AccessibilityManager.announceScreenChange(message)
    }
    
    /// Posts a layout changed notification for UI updates
    static func announceLayoutChange(_ message: String? = nil) {
        DispatchQueue.main.async {
            UIAccessibility.post(notification: .layoutChanged, argument: message)
        }
    }
    
    /// Instance method for layout changes
    func announceLayoutChange(_ message: String? = nil) {
        AccessibilityManager.announceLayoutChange(message)
    }
    
    /// Creates a standard accessibility identifier for consistent naming
    static func createIdentifier(for component: String, in feature: String) -> String {
        return "\(feature).\(component)"
    }
    
    /// Provides Indonesian accessibility hints for common UI elements
    static func standardHint(for elementType: AccessibilityElementType) -> String {
        switch elementType {
        case .button:
            return "Ketuk dua kali untuk memilih"
        case .navigationLink:
            return "Ketuk dua kali untuk melanjutkan"
        case .textField:
            return "Ketuk dua kali untuk mengedit"
        case .image:
            return "Gambar"
        case .text:
            return "Teks"
        case .card:
            return "Ketuk dua kali untuk memilih kartu"
        case .slider:
            return "Geser untuk mengubah nilai"
        case .toggle:
            return "Ketuk dua kali untuk mengubah pengaturan"
        }
    }
}

/// Types of accessibility elements for standardized hints
enum AccessibilityElementType {
    case button
    case navigationLink
    case textField
    case image
    case text
    case card
    case slider
    case toggle
}

/// Extension to add comprehensive accessibility support to views
extension View {
    /// Adds comprehensive accessibility support with Indonesian labels
    func kimoAccessibility(
        label: String,
        hint: String? = nil,
        traits: AccessibilityTraits = [],
        value: String? = nil,
        identifier: String? = nil,
        sortPriority: Double? = nil
    ) -> some View {
        var view = self
            .accessibilityLabel(label)
            .accessibilityAddTraits(traits)
        
        if let hint = hint {
            view = view.accessibilityHint(hint)
        }
        
        if let value = value {
            view = view.accessibilityValue(value)
        }
        
        if let identifier = identifier {
            view = view.accessibilityIdentifier(identifier)
        }
        
        if let sortPriority = sortPriority {
            view = view.accessibilitySortPriority(sortPriority)
        }
        
        return view
    }
    
    /// Adds button-specific accessibility with Indonesian labels
    func kimoButtonAccessibility(
        label: String,
        hint: String? = nil,
        identifier: String? = nil
    ) -> some View {
        self.kimoAccessibility(
            label: label,
            hint: hint ?? AccessibilityManager.standardHint(for: .button),
            traits: .isButton,
            identifier: identifier
        )
    }
    
    /// Adds navigation link accessibility with Indonesian labels
    func kimoNavigationAccessibility(
        label: String,
        hint: String? = nil,
        identifier: String? = nil
    ) -> some View {
        self.kimoAccessibility(
            label: label,
            hint: hint ?? AccessibilityManager.standardHint(for: .navigationLink),
            traits: [.isButton, .isLink],
            identifier: identifier
        )
    }
    
    /// Adds text accessibility with Indonesian support
    func kimoTextAccessibility(
        label: String? = nil,
        identifier: String? = nil,
        sortPriority: Double? = nil,
        ignoreAccessibilityChildren: Bool = false
    ) -> some View {
        Group {
            if ignoreAccessibilityChildren {
                self.kimoAccessibility(
                    label: label ?? "",
                    traits: .isStaticText,
                    identifier: identifier,
                    sortPriority: sortPriority
                )
                .accessibilityElement(children: .ignore)
            } else {
                self.kimoAccessibility(
                    label: label ?? "",
                    traits: .isStaticText,
                    identifier: identifier,
                    sortPriority: sortPriority
                )
            }
        }
    }
    
    /// Combines multiple text elements into a single accessibility element
    func kimoTextGroupAccessibility(
        combinedLabel: String,
        identifier: String? = nil,
        sortPriority: Double? = nil
    ) -> some View {
        self
            .accessibilityElement(children: .combine)
            .accessibilityLabel(combinedLabel)
            .accessibilityAddTraits(.isStaticText)
            .accessibilityIdentifier(identifier ?? "")
            .accessibilitySortPriority(sortPriority ?? 0)
    }
    
    /// Adds image accessibility with Indonesian support
    func kimoImageAccessibility(
        label: String,
        isDecorative: Bool = false,
        identifier: String? = nil
    ) -> some View {
        Group {
            if isDecorative {
                self.accessibilityHidden(true)
            } else {
                self.kimoAccessibility(
                    label: label,
                    traits: .isImage,
                    identifier: identifier
                )
            }
        }
    }
    
    /// Adds card/selection accessibility
    func kimoCardAccessibility(
        label: String,
        isSelected: Bool = false,
        hint: String? = nil,
        identifier: String? = nil
    ) -> some View {
        let traits: AccessibilityTraits = isSelected ? [.isButton, .isSelected] : [.isButton]
        let finalHint = hint ?? AccessibilityManager.standardHint(for: .card)
        
        return self.kimoAccessibility(
            label: label,
            hint: finalHint,
            traits: traits,
            identifier: identifier
        )
    }
}
