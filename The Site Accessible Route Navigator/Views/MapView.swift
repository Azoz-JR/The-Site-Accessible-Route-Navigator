//
//  MapView.swift
//  The Site Accessible Route Navigator
//
//  Created by Abdelaziz Salah on 25/11/25.
//

import SwiftUI
import MapKit

/// Map screen showing POIs and route selection
struct MapView: View {
    let selectedProfile: AccessibilityProfile
    
    @State private var navigationService = NavigationService()
    @State private var selectedOrigin: POI?
    @State private var selectedDestination: POI?
    @State private var showingRoutes = false
    @State private var cameraPosition: MapCameraPosition
    
    // Map region for Trieste
    private let triesteRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 45.6478, longitude: 13.7650),
        span: MKCoordinateSpan(latitudeDelta: 0.015, longitudeDelta: 0.015)
    )
    
    init(selectedProfile: AccessibilityProfile) {
        self.selectedProfile = selectedProfile
        _cameraPosition = State(initialValue: .region(
            MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: 45.6478, longitude: 13.7650),
                span: MKCoordinateSpan(latitudeDelta: 0.015, longitudeDelta: 0.015)
            )
        ))
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // Map with POI annotations
            Map(position: $cameraPosition) {
                ForEach(navigationService.allPOIs) { poi in
                    Annotation(poi.name, coordinate: poi.clCoordinate) {
                        POIAnnotationView(
                            poi: poi,
                            profile: selectedProfile,
                            isOrigin: selectedOrigin?.id == poi.id,
                            isDestination: selectedDestination?.id == poi.id
                        )
                        .onTapGesture {
                            handlePOITap(poi)
                        }
                    }
                }
                
                // Draw route polylines if routes are calculated
                if !navigationService.availableRoutes.isEmpty {
                    ForEach(navigationService.availableRoutes) { route in
                        MapPolyline(coordinates: route.waypoints.map { $0.clCoordinate })
                            .stroke(routeColor(for: route), lineWidth: 4)
                    }
                }
            }
            .mapStyle(.standard(elevation: .realistic))
            .accessibilityLabel("Map of Trieste showing accessible routes")
            .accessibilityHint("Tap on points of interest to select origin and destination")
            
            // Bottom sheet for destination selection
            VStack(spacing: 0) {
                // Handle bar
                RoundedRectangle(cornerRadius: 2.5)
                    .fill(Color.secondary.opacity(0.5))
                    .frame(width: 40, height: 5)
                    .padding(.top, 8)
                    .accessibilityHidden(true)
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        // Profile indicator
                        HStack {
                            Image(systemName: selectedProfile.icon)
                                .foregroundStyle(.black)
                            Text("Profile: \(selectedProfile.rawValue)")
                                .font(.subheadline)
                                .fontWeight(.medium)
                            Spacer()
                        }
                        .padding(.horizontal)
                        .padding(.top, 12)
                        .accessibilityElement(children: .combine)
                        .accessibilityLabel("Selected profile: \(selectedProfile.rawValue)")
                        
                        Divider()
                        
                        // Origin selection
                        VStack(alignment: .leading, spacing: 12) {
                            Label("Starting Point", systemImage: "mappin.circle.fill")
                                .font(.headline)
                                .foregroundStyle(.green)
                            
                            if let origin = selectedOrigin {
                                SelectedPOIRow(poi: origin, profile: selectedProfile)
                                    .accessibilityLabel("Starting point: \(origin.name)")
                            } else {
                                Text("Tap a location on the map")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                                    .accessibilityLabel("No starting point selected. Tap a location on the map")
                            }
                        }
                        .padding(.horizontal)
                        
                        // Destination selection
                        VStack(alignment: .leading, spacing: 12) {
                            Label("Destination", systemImage: "mappin.circle.fill")
                                .font(.headline)
                                .foregroundStyle(.red)
                            
                            if let destination = selectedDestination {
                                SelectedPOIRow(poi: destination, profile: selectedProfile)
                                    .accessibilityLabel("Destination: \(destination.name)")
                            } else {
                                Text("Tap a location on the map")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                                    .accessibilityLabel("No destination selected. Tap a location on the map")
                            }
                        }
                        .padding(.horizontal)
                        
                        // Find Route button
                        if selectedOrigin != nil && selectedDestination != nil {
                            Button(action: findRoute) {
                                HStack {
                                    Image(systemName: "arrow.triangle.turn.up.right.circle.fill")
                                    Text("Find Accessible Routes")
                                        .fontWeight(.semibold)
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(Color.accentColor)
                                .foregroundStyle(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                            }
                            .padding(.horizontal)
                            .sensoryFeedback(.success, trigger: showingRoutes)
                            .accessibilityLabel("Find accessible routes")
                            .accessibilityHint("Calculate and display route options")
                        }
                    }
                    .padding(.bottom, 20)
                }
                .frame(maxHeight: 320)
            }
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(.ultraThinMaterial)
                    .shadow(radius: 10)
            )
            .padding(.horizontal, 8)
        }
        .navigationTitle("Find Your Route")
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(isPresented: $showingRoutes) {
            if !navigationService.availableRoutes.isEmpty {
                RouteDetailView(
                    routes: navigationService.availableRoutes,
                    selectedProfile: selectedProfile
                )
            }
        }
        .dynamicTypeSize(...DynamicTypeSize.xxxLarge)
    }
    
    // MARK: - Helper Methods
    
    private func handlePOITap(_ poi: POI) {
        // Haptic feedback
        let feedback = UIImpactFeedbackGenerator(style: .light)
        feedback.impactOccurred()
        
        if selectedOrigin == nil {
            selectedOrigin = poi
        } else if selectedDestination == nil && poi.id != selectedOrigin?.id {
            selectedDestination = poi
        } else {
            // Reset and start over
            selectedOrigin = poi
            selectedDestination = nil
            navigationService.availableRoutes = []
        }
    }
    
    private func findRoute() {
        guard let origin = selectedOrigin,
              let destination = selectedDestination else { return }
        
        navigationService.calculateRoutes(from: origin, to: destination, for: selectedProfile)
        
        // Haptic feedback for route calculation
        let feedback = UINotificationFeedbackGenerator()
        feedback.notificationOccurred(.success)
        
        showingRoutes = true
    }
    
    private func routeColor(for route: Route) -> Color {
        switch route.routeColor {
        case "green":
            return .green
        case "yellow":
            return .yellow
        case "red":
            return .red
        default:
            return .blue
        }
    }
}

// MARK: - Supporting Views

/// Custom annotation view for POI markers
struct POIAnnotationView: View {
    let poi: POI
    let profile: AccessibilityProfile
    let isOrigin: Bool
    let isDestination: Bool
    
    var body: some View {
        VStack(spacing: 4) {
            ZStack {
                Circle()
                    .fill(markerColor)
                    .frame(width: 36, height: 36)
                    .shadow(radius: 4)
                
                Image(systemName: poi.category.icon)
                    .foregroundStyle(.white)
                    .font(.system(size: 16, weight: .semibold))
            }
            
            Text(poi.name)
                .font(.caption2)
                .fontWeight(.medium)
                .padding(.horizontal, 6)
                .padding(.vertical, 2)
                .background(
                    Capsule()
                        .fill(.ultraThinMaterial)
                )
                .lineLimit(1)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(poi.name). Accessibility rating: \(Int(poi.accessibilityRating(for: profile) * 100))%")
        .accessibilityHint("Tap to select as \(isOrigin ? "origin" : isDestination ? "destination" : "waypoint")")
    }
    
    private var markerColor: Color {
        if isOrigin {
            return .green
        } else if isDestination {
            return .red
        } else {
            let rating = poi.accessibilityRating(for: profile)
            if rating >= 0.8 {
                return .blue
            } else if rating >= 0.5 {
                return .orange
            } else {
                return .gray
            }
        }
    }
}

/// Row showing selected POI information
struct SelectedPOIRow: View {
    let poi: POI
    let profile: AccessibilityProfile
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: poi.category.icon)
                .font(.title3)
                .foregroundStyle(.black)
                .frame(width: 32)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(poi.name)
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                HStack(spacing: 8) {
                    Label("\(Int(poi.accessibilityRating(for: profile) * 100))%", systemImage: "checkmark.circle.fill")
                        .font(.caption)
                        .foregroundStyle(ratingColor)
                    
                    Text(poi.category.rawValue)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            
            Spacer()
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(.systemGray6))
        )
    }
    
    private var ratingColor: Color {
        let rating = poi.accessibilityRating(for: profile)
        if rating >= 0.8 {
            return .green
        } else if rating >= 0.5 {
            return .orange
        } else {
            return .red
        }
    }
}

// MARK: - Helper Extension

extension Coordinate {
    var clCoordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}

#Preview {
    NavigationStack {
        MapView(selectedProfile: .wheelchair)
    }
}

