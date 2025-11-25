//
//  RouteDetailView.swift
//  The Site Accessible Route Navigator
//
//  Created by Abdelaziz Salah on 25/11/25.
//

import SwiftUI

/// Detailed view showing route options with obstacles and accessibility information
struct RouteDetailView: View {
    let routes: [Route]
    let selectedProfile: AccessibilityProfile
    
    @State private var selectedRouteIndex = 0
    @State private var showingNavigationAlert = false
    
    var selectedRoute: Route {
        routes[selectedRouteIndex]
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Route selector if multiple routes available
                if routes.count > 1 {
                    routeSelector
                }
                
                // Route summary card
                routeSummaryCard
                
                // Suitability indicator
                suitabilitySection
                
                // Obstacles section
                if !selectedRoute.obstacles.isEmpty {
                    obstaclesSection
                }
                
                // Accessibility features section
                if !selectedRoute.features.isEmpty {
                    featuresSection
                }
                
                // Start navigation button
                startNavigationButton
            }
            .padding()
        }
        .navigationTitle("Route Details")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Navigation Started", isPresented: $showingNavigationAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("In a full version, turn-by-turn navigation would start here with real-time accessibility updates.")
        }
        .dynamicTypeSize(...DynamicTypeSize.xxxLarge)
    }
    
    // MARK: - View Components
    
    private var routeSelector: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Available Routes")
                .font(.headline)
                .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(Array(routes.enumerated()), id: \.element.id) { index, route in
                        RouteOptionCard(
                            route: route,
                            isSelected: selectedRouteIndex == index
                        )
                        .onTapGesture {
                            withAnimation {
                                selectedRouteIndex = index
                                // Haptic feedback
                                let feedback = UIImpactFeedbackGenerator(style: .light)
                                feedback.impactOccurred()
                            }
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Route options")
    }
    
    private var routeSummaryCard: some View {
        VStack(spacing: 16) {
            // Route name and rating
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(selectedRoute.name)
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("\(selectedRoute.origin.name) → \(selectedRoute.destination.name)")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                // Accessibility score badge
                VStack(spacing: 4) {
                    Text("\(Int(selectedRoute.accessibilityScore * 100))")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundStyle(scoreColor)
                    
                    Text("Score")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
                .frame(width: 70, height: 70)
                .background(
                    Circle()
                        .fill(scoreColor.opacity(0.15))
                )
            }
            
            Divider()
            
            // Route metrics
            HStack(spacing: 20) {
                MetricView(
                    icon: "ruler",
                    value: selectedRoute.distanceFormatted,
                    label: "Distance"
                )
                
                Divider()
                    .frame(height: 40)
                
                MetricView(
                    icon: "clock",
                    value: "\(selectedRoute.estimatedTime) min",
                    label: "Est. Time"
                )
                
                Divider()
                    .frame(height: 40)
                
                MetricView(
                    icon: "exclamationmark.triangle",
                    value: "\(selectedRoute.obstacles.count)",
                    label: "Obstacles"
                )
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
        )
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Route: \(selectedRoute.name). From \(selectedRoute.origin.name) to \(selectedRoute.destination.name). Accessibility score: \(Int(selectedRoute.accessibilityScore * 100))%. Distance: \(selectedRoute.distanceFormatted). Estimated time: \(selectedRoute.estimatedTime) minutes. \(selectedRoute.obstacles.count) obstacles")
    }
    
    private var suitabilitySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Route Suitability")
                .font(.headline)
            
            if selectedRoute.isSuitableFor(profile: selectedProfile) {
                SuitabilityCard(
                    icon: "checkmark.circle.fill",
                    title: "Recommended for \(selectedProfile.rawValue)",
                    message: "This route has good accessibility features for your profile.",
                    color: .green
                )
            } else {
                SuitabilityCard(
                    icon: "exclamationmark.triangle.fill",
                    title: "Not Recommended for \(selectedProfile.rawValue)",
                    message: "This route may have significant obstacles for your profile. Consider an alternative route.",
                    color: .orange
                )
            }
        }
    }
    
    private var obstaclesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("Obstacles Along Route", systemImage: "exclamationmark.triangle.fill")
                .font(.headline)
                .foregroundStyle(.orange)
            
            VStack(spacing: 12) {
                ForEach(selectedRoute.obstacles) { obstacle in
                    ObstacleRow(obstacle: obstacle)
                }
            }
        }
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Obstacles section")
    }
    
    private var featuresSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("Accessibility Features", systemImage: "checkmark.circle.fill")
                .font(.headline)
                .foregroundStyle(.green)
            
            VStack(spacing: 12) {
                ForEach(selectedRoute.features) { feature in
                    AccessibilityFeatureRow(feature: feature)
                }
            }
        }
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Accessibility features section")
    }
    
    private var startNavigationButton: some View {
        Button(action: {
            // Haptic feedback
            let feedback = UINotificationFeedbackGenerator()
            feedback.notificationOccurred(.success)
            showingNavigationAlert = true
        }) {
            HStack {
                Image(systemName: "location.fill")
                Text("Start Navigation")
                    .fontWeight(.semibold)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(Color.accentColor)
            .foregroundStyle(.white)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .sensoryFeedback(.success, trigger: showingNavigationAlert)
        .accessibilityLabel("Start navigation")
        .accessibilityHint("Begin turn-by-turn navigation for this route")
    }
    
    // MARK: - Helper Properties
    
    private var scoreColor: Color {
        let score = selectedRoute.accessibilityScore
        if score >= 0.8 {
            return .green
        } else if score >= 0.5 {
            return .orange
        } else {
            return .red
        }
    }
}

// MARK: - Supporting Views

/// Card for route option selection
struct RouteOptionCard: View {
    let route: Route
    let isSelected: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Circle()
                    .fill(routeColor)
                    .frame(width: 12, height: 12)
                
                Text(route.name)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .lineLimit(1)
            }
            
            Text("\(route.estimatedTime) min")
                .font(.caption)
                .foregroundStyle(.secondary)
            
            Text("\(Int(route.accessibilityScore * 100))%")
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundStyle(routeColor)
        }
        .padding(12)
        .frame(width: 140)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(isSelected ? routeColor.opacity(0.15) : Color(.systemGray6))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(isSelected ? routeColor : Color.clear, lineWidth: 2)
        )
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(route.name). \(route.estimatedTime) minutes. Accessibility: \(Int(route.accessibilityScore * 100))%")
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }
    
    private var routeColor: Color {
        switch route.routeColor {
        case "green":
            return .green
        case "yellow":
            return .orange
        case "red":
            return .red
        default:
            return .blue
        }
    }
}

/// Metric display component
struct MetricView: View {
    let icon: String
    let value: String
    let label: String
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundStyle(.black)
            
            Text(value)
                .font(.headline)
                .fontWeight(.semibold)
            
            Text(label)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(label): \(value)")
    }
}

/// Suitability indicator card
struct SuitabilityCard: View {
    let icon: String
    let title: String
    let message: String
    let color: Color
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(color)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                
                Text(message)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(color.opacity(0.1))
        )
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(title). \(message)")
    }
}

#Preview {
    NavigationStack {
        RouteDetailView(
            routes: [
                Route(
                    name: "Most Accessible Route",
                    origin: POI(
                        name: "Piazza Unità d'Italia",
                        description: "Main square",
                        latitude: 45.6467,
                        longitude: 13.7628,
                        category: .square,
                        accessibilityRatings: [.wheelchair: 0.95],
                        features: []
                    ),
                    destination: POI(
                        name: "Castello di San Giusto",
                        description: "Historic castle",
                        latitude: 45.6478,
                        longitude: 13.7700,
                        category: .historicalSite,
                        accessibilityRatings: [.wheelchair: 0.40],
                        features: []
                    ),
                    waypoints: [
                        Coordinate(latitude: 45.6467, longitude: 13.7628),
                        Coordinate(latitude: 45.6478, longitude: 13.7700)
                    ],
                    distance: 850,
                    estimatedTime: 18,
                    accessibilityScore: 0.92,
                    obstacles: [
                        Obstacle(
                            type: .crowdedArea,
                            latitude: 45.6472,
                            longitude: 13.7664,
                            description: "Busy pedestrian area",
                            severity: .low,
                            affectsProfiles: [.wheelchair],
                            alternative: "Use parallel street"
                        )
                    ],
                    features: [
                        AccessibilityFeature(
                            type: .ramp,
                            latitude: 45.6472,
                            longitude: 13.7664,
                            description: "Modern ramp with handrails",
                            benefitsProfiles: [.wheelchair, .stroller]
                        )
                    ],
                    recommendedFor: [.wheelchair],
                    notRecommendedFor: []
                )
            ],
            selectedProfile: .wheelchair
        )
    }
}

