//
//  ProfileCard.swift
//  The Site Accessible Route Navigator
//
//  Created by Abdelaziz Salah on 25/11/25.
//

import SwiftUI

/// Reusable card component for profile selection
struct ProfileCard: View {
    let profile: AccessibilityProfile
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: {
            // Provide haptic feedback when selecting profile
            let feedback = UIImpactFeedbackGenerator(style: .medium)
            feedback.impactOccurred()
            action()
        }) {
            VStack(spacing: 16) {
                // Profile icon
                Image(systemName: profile.icon)
                    .font(.system(size: 44))
                    .foregroundStyle(isSelected ? .white : .primary)
                
                // Profile name
                Text(profile.rawValue)
                    .font(.headline)
                    .foregroundStyle(isSelected ? .white : .primary)
                    .multilineTextAlignment(.center)
                
                // Profile description
                Text(profile.description)
                    .font(.caption)
                    .foregroundStyle(isSelected ? .white.opacity(0.9) : .secondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(4)
            }
            .padding(20)
            .frame(maxWidth: .infinity, minHeight: 220)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(isSelected ? Color.accentColor : Color(.systemGray6))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(isSelected ? Color.accentColor : Color.clear, lineWidth: 3)
            )
            .shadow(color: isSelected ? Color.accentColor.opacity(0.3) : Color.black.opacity(0.1), 
                    radius: isSelected ? 8 : 4, 
                    x: 0, 
                    y: isSelected ? 4 : 2)
        }
        .buttonStyle(.plain)
        // Accessibility enhancements
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(profile.rawValue)")
        .accessibilityHint(isSelected ? "Selected. \(profile.description)" : "Double tap to select. \(profile.description)")
        .accessibilityAddTraits(isSelected ? [.isSelected, .isButton] : .isButton)
    }
}

#Preview("Selected") {
    ProfileCard(
        profile: .wheelchair,
        isSelected: true,
        action: {}
    )
    .padding()
}

#Preview("Not Selected") {
    ProfileCard(
        profile: .visualImpairment,
        isSelected: false,
        action: {}
    )
    .padding()
}

