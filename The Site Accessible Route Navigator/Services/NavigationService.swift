//
//  NavigationService.swift
//  The Site Accessible Route Navigator
//
//  Created by Abdelaziz Salah on 25/11/25.
//

import Foundation
import Observation

/// Service managing navigation data and route calculations
/// Acts as the brain of the app, providing mock data for demonstration
@Observable
class NavigationService {
    
    // MARK: - Properties
    
    var selectedProfile: AccessibilityProfile?
    var selectedOrigin: POI?
    var selectedDestination: POI?
    var availableRoutes: [Route] = []
    
    // MARK: - Mock Data
    
    /// All Points of Interest in Trieste
    let allPOIs: [POI] = [
        POI(
            name: "Piazza Unità d'Italia",
            description: "The largest sea-facing square in Europe, surrounded by elegant buildings.",
            latitude: 45.6467,
            longitude: 13.7628,
            category: .square,
            accessibilityRatings: [
                .wheelchair: 0.95,
                .stroller: 0.95,
                .visualImpairment: 0.85,
                .hearingImpairment: 0.90
            ],
            features: [.smoothSurface, .widePath, .restArea, .accessibleToilet, .visualSignage]
        ),
        POI(
            name: "Castello di San Giusto",
            description: "Historic castle and fortress with panoramic views of Trieste.",
            latitude: 45.6478,
            longitude: 13.7700,
            category: .historicalSite,
            accessibilityRatings: [
                .wheelchair: 0.40,
                .stroller: 0.45,
                .visualImpairment: 0.60,
                .hearingImpairment: 0.80
            ],
            features: [.audioGuide, .restArea, .visualSignage]
        ),
        POI(
            name: "Teatro Romano",
            description: "Ancient Roman theater dating back to the 1st century AD.",
            latitude: 45.6485,
            longitude: 13.7656,
            category: .historicalSite,
            accessibilityRatings: [
                .wheelchair: 0.50,
                .stroller: 0.55,
                .visualImpairment: 0.70,
                .hearingImpairment: 0.85
            ],
            features: [.visualSignage, .audioGuide]
        ),
        POI(
            name: "Molo Audace",
            description: "Historic pier extending into the Adriatic Sea, perfect for walks.",
            latitude: 45.6478,
            longitude: 13.7640,
            category: .waterfront,
            accessibilityRatings: [
                .wheelchair: 0.90,
                .stroller: 0.90,
                .visualImpairment: 0.75,
                .hearingImpairment: 0.95
            ],
            features: [.smoothSurface, .widePath, .restArea, .tactilePaving]
        ),
        POI(
            name: "Canal Grande",
            description: "Picturesque canal in the heart of Trieste's historic center.",
            latitude: 45.6495,
            longitude: 13.7655,
            category: .waterfront,
            accessibilityRatings: [
                .wheelchair: 0.85,
                .stroller: 0.85,
                .visualImpairment: 0.80,
                .hearingImpairment: 0.90
            ],
            features: [.smoothSurface, .widePath, .visualSignage, .tactilePaving]
        ),
        POI(
            name: "Museo Revoltella",
            description: "Modern art gallery housed in a 19th-century palace.",
            latitude: 45.6482,
            longitude: 13.7625,
            category: .museum,
            accessibilityRatings: [
                .wheelchair: 0.75,
                .stroller: 0.70,
                .visualImpairment: 0.80,
                .hearingImpairment: 0.85
            ],
            features: [.elevator, .accessibleToilet, .audioGuide, .visualSignage, .restArea]
        )
    ]
    
    // MARK: - Initialization
    
    init() {
        // Initialize with default state
    }
    
    // MARK: - Public Methods
    
    /// Calculate routes between origin and destination based on selected profile
    func calculateRoutes(from origin: POI, to destination: POI, for profile: AccessibilityProfile) {
        self.selectedOrigin = origin
        self.selectedDestination = destination
        self.selectedProfile = profile
        
        // Generate mock routes based on the POI pair
        availableRoutes = generateMockRoutes(from: origin, to: destination, for: profile)
    }
    
    /// Get POIs sorted by accessibility rating for the given profile
    func sortedPOIs(for profile: AccessibilityProfile) -> [POI] {
        allPOIs.sorted { poi1, poi2 in
            poi1.accessibilityRating(for: profile) > poi2.accessibilityRating(for: profile)
        }
    }
    
    // MARK: - Private Methods
    
    /// Generate mock routes with realistic Trieste data
    private func generateMockRoutes(from origin: POI, to destination: POI, for profile: AccessibilityProfile) -> [Route] {
        var routes: [Route] = []
        
        // Route 1: Most Accessible (Main roads, ramps, elevators)
        let accessibleRoute = createAccessibleRoute(from: origin, to: destination, for: profile)
        routes.append(accessibleRoute)
        
        // Route 2: Partially Accessible (Some obstacles but alternatives available)
        let partialRoute = createPartialRoute(from: origin, to: destination, for: profile)
        routes.append(partialRoute)
        
        // Route 3: Direct but challenging (Shortest but with significant obstacles)
        let directRoute = createDirectRoute(from: origin, to: destination, for: profile)
        routes.append(directRoute)
        
        // Filter routes based on profile suitability
        return routes.filter { route in
            // Show all routes but highlight suitability
            true
        }.sorted { $0.accessibilityScore > $1.accessibilityScore }
    }
    
    /// Create the most accessible route option
    private func createAccessibleRoute(from origin: POI, to destination: POI, for profile: AccessibilityProfile) -> Route {
        let midLat = (origin.coordinate.latitude + destination.coordinate.latitude) / 2
        let midLon = (origin.coordinate.longitude + destination.coordinate.longitude) / 2 + 0.002
        
        let waypoints = [
            origin.coordinate,
            Coordinate(latitude: midLat, longitude: midLon),
            destination.coordinate
        ]
        
        let obstacles: [Obstacle] = [
            Obstacle(
                type: .crowdedArea,
                latitude: midLat,
                longitude: midLon - 0.001,
                description: "Busy pedestrian area near shops. May be crowded during peak hours.",
                severity: .low,
                affectsProfiles: [.wheelchair, .visualImpairment],
                alternative: "Wait for less busy times or use parallel street"
            )
        ]
        
        let features: [AccessibilityFeature] = [
            AccessibilityFeature(
                type: .ramp,
                latitude: midLat + 0.0005,
                longitude: midLon,
                description: "Modern ramp with handrails, compliant with accessibility standards.",
                benefitsProfiles: [.wheelchair, .stroller]
            ),
            AccessibilityFeature(
                type: .tactilePaving,
                latitude: midLat - 0.0005,
                longitude: midLon + 0.0003,
                description: "Tactile paving at crosswalk with audio signal.",
                benefitsProfiles: [.visualImpairment]
            ),
            AccessibilityFeature(
                type: .restArea,
                latitude: midLat,
                longitude: midLon + 0.0005,
                description: "Benches and rest area with shade.",
                benefitsProfiles: AccessibilityProfile.allCases
            ),
            AccessibilityFeature(
                type: .smoothSurface,
                latitude: midLat + 0.0003,
                longitude: midLon - 0.0002,
                description: "Well-maintained sidewalk with smooth surface.",
                benefitsProfiles: [.wheelchair, .stroller, .visualImpairment]
            )
        ]
        
        return Route(
            name: "Most Accessible Route",
            origin: origin,
            destination: destination,
            waypoints: waypoints,
            distance: calculateDistance(waypoints: waypoints),
            estimatedTime: 18,
            accessibilityScore: 0.92,
            obstacles: obstacles,
            features: features,
            recommendedFor: AccessibilityProfile.allCases,
            notRecommendedFor: []
        )
    }
    
    /// Create a partially accessible route
    private func createPartialRoute(from origin: POI, to destination: POI, for profile: AccessibilityProfile) -> Route {
        let midLat1 = (origin.coordinate.latitude + destination.coordinate.latitude) / 2 - 0.001
        let midLon1 = (origin.coordinate.longitude + destination.coordinate.longitude) / 2
        let midLat2 = (origin.coordinate.latitude + destination.coordinate.latitude) / 2 + 0.001
        let midLon2 = (origin.coordinate.longitude + destination.coordinate.longitude) / 2 + 0.001
        
        let waypoints = [
            origin.coordinate,
            Coordinate(latitude: midLat1, longitude: midLon1),
            Coordinate(latitude: midLat2, longitude: midLon2),
            destination.coordinate
        ]
        
        let obstacles: [Obstacle] = [
            Obstacle(
                type: .unevenSurface,
                latitude: midLat1,
                longitude: midLon1,
                description: "Cobblestone street section approximately 50 meters long.",
                severity: .medium,
                affectsProfiles: [.wheelchair, .stroller, .visualImpairment],
                alternative: "Alternative paved route available via Via Roma (adds 3 minutes)"
            ),
            Obstacle(
                type: .narrowPath,
                latitude: midLat2,
                longitude: midLon2,
                description: "Narrow sidewalk (1.2m width) between buildings.",
                severity: .medium,
                affectsProfiles: [.wheelchair, .stroller],
                alternative: "Proceed slowly during off-peak hours"
            )
        ]
        
        let features: [AccessibilityFeature] = [
            AccessibilityFeature(
                type: .visualSignage,
                latitude: midLat1 + 0.0002,
                longitude: midLon1,
                description: "Clear directional signage with icons and multiple languages.",
                benefitsProfiles: [.visualImpairment, .hearingImpairment]
            ),
            AccessibilityFeature(
                type: .widePath,
                latitude: midLat2 - 0.0003,
                longitude: midLon2,
                description: "Wide pedestrian area for most of the route.",
                benefitsProfiles: [.wheelchair, .stroller]
            )
        ]
        
        return Route(
            name: "Scenic Route",
            origin: origin,
            destination: destination,
            waypoints: waypoints,
            distance: calculateDistance(waypoints: waypoints) * 1.15,
            estimatedTime: 15,
            accessibilityScore: 0.68,
            obstacles: obstacles,
            features: features,
            recommendedFor: [.hearingImpairment, .visualImpairment],
            notRecommendedFor: []
        )
    }
    
    /// Create the most direct route (potentially with challenges)
    private func createDirectRoute(from origin: POI, to destination: POI, for profile: AccessibilityProfile) -> Route {
        let waypoints = [
            origin.coordinate,
            destination.coordinate
        ]
        
        let midLat = (origin.coordinate.latitude + destination.coordinate.latitude) / 2
        let midLon = (origin.coordinate.longitude + destination.coordinate.longitude) / 2
        
        let obstacles: [Obstacle] = [
            Obstacle(
                type: .stairs,
                latitude: midLat,
                longitude: midLon,
                description: "Stone staircase with 45 steps, no handrail. Historic section.",
                severity: .blocking,
                affectsProfiles: [.wheelchair, .stroller],
                alternative: "Use elevator at nearby building (Palazzo Comunale) or take accessible route"
            ),
            Obstacle(
                type: .steepSlope,
                latitude: midLat + 0.0003,
                longitude: midLon + 0.0002,
                description: "Steep uphill section (15% grade) for 80 meters.",
                severity: .high,
                affectsProfiles: [.wheelchair, .stroller],
                alternative: "Take longer route via Via San Nicolò with gentle slope"
            ),
            Obstacle(
                type: .unevenSurface,
                latitude: midLat - 0.0002,
                longitude: midLon - 0.0001,
                description: "Historic cobblestone section, uneven and potentially slippery.",
                severity: .high,
                affectsProfiles: [.wheelchair, .stroller, .visualImpairment],
                alternative: "Modern paved alternate route available"
            )
        ]
        
        let features: [AccessibilityFeature] = [
            AccessibilityFeature(
                type: .audioGuide,
                latitude: midLat,
                longitude: midLon + 0.0005,
                description: "Audio guide available describing historic route.",
                benefitsProfiles: [.visualImpairment]
            )
        ]
        
        return Route(
            name: "Direct Historic Route",
            origin: origin,
            destination: destination,
            waypoints: waypoints,
            distance: calculateDistance(waypoints: waypoints),
            estimatedTime: 12,
            accessibilityScore: 0.35,
            obstacles: obstacles,
            features: features,
            recommendedFor: [],
            notRecommendedFor: [.wheelchair, .stroller]
        )
    }
    
    /// Calculate approximate distance from waypoints
    private func calculateDistance(waypoints: [Coordinate]) -> Double {
        guard waypoints.count >= 2 else { return 0 }
        
        var totalDistance: Double = 0
        for i in 0..<(waypoints.count - 1) {
            let coord1 = waypoints[i]
            let coord2 = waypoints[i + 1]
            
            // Simplified distance calculation (Haversine formula approximation)
            let latDiff = coord2.latitude - coord1.latitude
            let lonDiff = coord2.longitude - coord1.longitude
            let distance = sqrt(latDiff * latDiff + lonDiff * lonDiff) * 111000 // Rough meters conversion
            totalDistance += distance
        }
        
        return totalDistance
    }
}

