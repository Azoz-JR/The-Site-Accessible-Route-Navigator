//
//  OnboardingView.swift
//  The Site Accessible Route Navigator
//
//  Created by Abdelaziz Salah on 25/11/25.
//

import SwiftUI

/// Onboarding screen for selecting accessibility profile
struct OnboardingView: View {
    @State private var selectedProfile: AccessibilityProfile?
    @State private var navigateToMap = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 32) {
                    // Header
                    VStack(spacing: 16) {
                        Image(systemName: "location.circle.fill")
                            .font(.system(size: 60))
                            .foregroundStyle(.black)
                            .accessibilityHidden(true)
                        
                        Text("Accessible Routes")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.center)
                        
                        Text("Choose your accessibility profile to find the best routes for you in Trieste")
                            .font(.body)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                    .padding(.top, 20)
                    .accessibilityElement(children: .combine)
                    .accessibilityLabel("Accessible Routes. Choose your accessibility profile to find the best routes for you in Trieste")
                    
                    // Profile selection grid
                    LazyVGrid(columns: [
                        GridItem(.flexible(), spacing: 16),
                        GridItem(.flexible(), spacing: 16)
                    ], spacing: 16) {
                        ForEach(AccessibilityProfile.allCases) { profile in
                            ProfileCard(
                                profile: profile,
                                isSelected: selectedProfile == profile,
                                action: {
                                    selectedProfile = profile
                                }
                            )
                        }
                    }
                    .padding(.horizontal)
                    
                    // Continue button
                    Button(action: {
                        if selectedProfile != nil {
                            // Provide haptic feedback on navigation
                            let feedback = UINotificationFeedbackGenerator()
                            feedback.notificationOccurred(.success)
                            navigateToMap = true
                        }
                    }) {
                        HStack {
                            Text("Continue")
                                .fontWeight(.semibold)
                            Image(systemName: "arrow.right")
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(selectedProfile != nil ? Color.accentColor : Color.gray)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    .disabled(selectedProfile == nil)
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                    .accessibilityLabel("Continue to map")
                    .accessibilityHint(selectedProfile != nil ? "Navigate to route map" : "Please select a profile first")
                    .accessibilityAddTraits(selectedProfile != nil ? .isButton : [.isButton, .isSelected])
                }
            }
            .navigationDestination(isPresented: $navigateToMap) {
                if let profile = selectedProfile {
                    MapView(selectedProfile: profile)
                }
            }
        }
        // Support for Dynamic Type with reasonable limits
        .dynamicTypeSize(...DynamicTypeSize.xxxLarge)
    }
}

#Preview {
    OnboardingView()
}

