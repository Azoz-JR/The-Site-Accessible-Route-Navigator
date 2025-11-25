//
//  Route.swift
//  The Site Accessible Route Navigator
//
//  Created by Abdelaziz Salah on 25/11/25.
//

import Foundation

/// Represents a navigation route between POIs with accessibility information
struct Route: Identifiable {
    let id: UUID
    let name: String
    let origin: POI
    let destination: POI
    let waypoints: [Coordinate]
    let distance: Double // in meters
    let estimatedTime: Int // in minutes
    let accessibilityScore: Double // 0.0 to 1.0
    let obstacles: [Obstacle]
    let features: [AccessibilityFeature]
    let recommendedFor: [AccessibilityProfile]
    let notRecommendedFor: [AccessibilityProfile]
    
    init(
        id: UUID = UUID(),
        name: String,
        origin: POI,
        destination: POI,
        waypoints: [Coordinate],
        distance: Double,
        estimatedTime: Int,
        accessibilityScore: Double,
        obstacles: [Obstacle],
        features: [AccessibilityFeature],
        recommendedFor: [AccessibilityProfile],
        notRecommendedFor: [AccessibilityProfile]
    ) {
        self.id = id
        self.name = name
        self.origin = origin
        self.destination = destination
        self.waypoints = waypoints
        self.distance = distance
        self.estimatedTime = estimatedTime
        self.accessibilityScore = accessibilityScore
        self.obstacles = obstacles
        self.features = features
        self.recommendedFor = recommendedFor
        self.notRecommendedFor = notRecommendedFor
    }
    
    /// Human-readable distance
    var distanceFormatted: String {
        if distance >= 1000 {
            return String(format: "%.1f km", distance / 1000)
        } else {
            return String(format: "%.0f m", distance)
        }
    }
    
    /// Color for route visualization based on accessibility score
    var routeColor: String {
        if accessibilityScore >= 0.8 {
            return "green"
        } else if accessibilityScore >= 0.5 {
            return "yellow"
        } else {
            return "red"
        }
    }
    
    /// Check if route is suitable for a given profile
    func isSuitableFor(profile: AccessibilityProfile) -> Bool {
        recommendedFor.contains(profile) && !notRecommendedFor.contains(profile)
    }
}

/// Represents an obstacle along the route
struct Obstacle: Identifiable {
    let id: UUID
    let type: ObstacleType
    let location: Coordinate
    let description: String
    let severity: ObstacleSeverity
    let affectsProfiles: [AccessibilityProfile]
    let alternative: String? // Alternative route or solution
    
    init(
        id: UUID = UUID(),
        type: ObstacleType,
        latitude: Double,
        longitude: Double,
        description: String,
        severity: ObstacleSeverity,
        affectsProfiles: [AccessibilityProfile],
        alternative: String? = nil
    ) {
        self.id = id
        self.type = type
        self.location = Coordinate(latitude: latitude, longitude: longitude)
        self.description = description
        self.severity = severity
        self.affectsProfiles = affectsProfiles
        self.alternative = alternative
    }
}

/// Type of obstacle that may affect accessibility
enum ObstacleType: String {
    case stairs = "Stairs"
    case narrowPath = "Narrow Path"
    case unevenSurface = "Uneven Surface"
    case steepSlope = "Steep Slope"
    case construction = "Construction"
    case noCrosswalk = "No Crosswalk"
    case crowdedArea = "Crowded Area"
    
    var icon: String {
        switch self {
        case .stairs:
            return "figure.stairs"
        case .narrowPath:
            return "arrow.left.arrow.right.square"
        case .unevenSurface:
            return "water.waves"
        case .steepSlope:
            return "mountain.2"
        case .construction:
            return "cone"
        case .noCrosswalk:
            return "figure.walk.diamond"
        case .crowdedArea:
            return "person.3"
        }
    }
}

/// Represents an accessibility feature along the route
struct AccessibilityFeature: Identifiable {
    let id: UUID
    let type: AccessibilityFeatureType
    let location: Coordinate
    let description: String
    let benefitsProfiles: [AccessibilityProfile]
    
    init(
        id: UUID = UUID(),
        type: AccessibilityFeatureType,
        latitude: Double,
        longitude: Double,
        description: String,
        benefitsProfiles: [AccessibilityProfile]
    ) {
        self.id = id
        self.type = type
        self.location = Coordinate(latitude: latitude, longitude: longitude)
        self.description = description
        self.benefitsProfiles = benefitsProfiles
    }
}

