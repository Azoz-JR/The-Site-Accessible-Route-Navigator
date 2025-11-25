//
//  POI.swift
//  The Site Accessible Route Navigator
//
//  Created by Abdelaziz Salah on 25/11/25.
//

import Foundation
import CoreLocation

/// Point of Interest representing a tourist destination in Trieste
struct POI: Identifiable, Codable {
    let id: UUID
    let name: String
    let description: String
    let coordinate: Coordinate
    let category: POICategory
    let accessibilityRatings: [AccessibilityProfile: Double] // 0.0 to 1.0
    let features: [AccessibilityFeatureType]
    
    init(
        id: UUID = UUID(),
        name: String,
        description: String,
        latitude: Double,
        longitude: Double,
        category: POICategory,
        accessibilityRatings: [AccessibilityProfile: Double],
        features: [AccessibilityFeatureType]
    ) {
        self.id = id
        self.name = name
        self.description = description
        self.coordinate = Coordinate(latitude: latitude, longitude: longitude)
        self.category = category
        self.accessibilityRatings = accessibilityRatings
        self.features = features
    }
    
    /// Get accessibility rating for a specific profile (0.0 to 1.0)
    func accessibilityRating(for profile: AccessibilityProfile) -> Double {
        accessibilityRatings[profile] ?? 0.5
    }
    
    /// Convert to CLLocationCoordinate2D for MapKit
    var clCoordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
    }
}

/// Codable wrapper for coordinates
struct Coordinate: Codable, Hashable {
    let latitude: Double
    let longitude: Double
}

/// Category of Point of Interest
enum POICategory: String, Codable {
    case historicalSite = "Historical Site"
    case museum = "Museum"
    case monument = "Monument"
    case viewpoint = "Viewpoint"
    case square = "Square"
    case waterfront = "Waterfront"
    
    var icon: String {
        switch self {
        case .historicalSite:
            return "building.columns"
        case .museum:
            return "building.2"
        case .monument:
            return "landmark"
        case .viewpoint:
            return "eye"
        case .square:
            return "square.grid.3x3"
        case .waterfront:
            return "water.waves"
        }
    }
}

