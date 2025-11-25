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
            ZStack(alignment: .bottom) {
                ScrollView {
                    VStack(spacing: 32) {
                        // Header
                        VStack(spacing: 16) {
                            Image(systemName: "location.circle.fill")
                                .font(.system(size: 60))
                                .foregroundStyle(Color.accentColor)
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
                                .aspectRatio(0.85, contentMode: .fit)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 100) // Space for bottom button
                    }
                }
                
                // Continue button overlay
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
                    .foregroundStyle(.white)
                    .glassEffect(.clear.tint(Color.accentColor.opacity(0.9)), in: .capsule)
                    .padding(.horizontal, 30)
                }
                .opacity(selectedProfile == nil ? 0.3 : 1.0)
                .disabled(selectedProfile == nil)
                .accessibilityLabel("Continue to map")
                .accessibilityHint(selectedProfile != nil ? "Navigate to route map" : "Please select a profile first")
                .accessibilityAddTraits(selectedProfile != nil ? .isButton : [.isButton, .isSelected])
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

