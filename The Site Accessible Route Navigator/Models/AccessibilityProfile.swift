//
//  AccessibilityProfile.swift
//  The Site Accessible Route Navigator
//
//  Created by Abdelaziz Salah on 25/11/25.
//

import Foundation

/// Represents different accessibility profiles for tourists
enum AccessibilityProfile: String, CaseIterable, Identifiable, Codable {
    case wheelchair = "Wheelchair User"
    case stroller = "Stroller"
    case visualImpairment = "Visual Impairment"
    case hearingImpairment = "Hearing Impairment"
    
    var id: String { rawValue }
    
    /// SF Symbol icon for the profile
    var icon: String {
        switch self {
        case .wheelchair:
            return "figure.roll"
        case .stroller:
            return "figure.and.child.holdinghands"
        case .visualImpairment:
            return "eye.slash"
        case .hearingImpairment:
            return "ear.badge.waveform"
        }
    }
    
    /// Description of accessibility needs for this profile
    var description: String {
        switch self {
        case .wheelchair:
            return "Routes without stairs, with ramps and elevators. Wide paths suitable for wheelchair access."
        case .stroller:
            return "Step-free routes with smooth surfaces. Accessible paths for parents with strollers."
        case .visualImpairment:
            return "Routes with tactile paving, audio guides, and clear signage. Safe pedestrian crossings."
        case .hearingImpairment:
            return "Visual information displays, clear signage, and accessible communication points."
        }
    }
    
    /// Color associated with the profile for UI consistency
    var colorName: String {
        switch self {
        case .wheelchair:
            return "blue"
        case .stroller:
            return "green"
        case .visualImpairment:
            return "purple"
        case .hearingImpairment:
            return "orange"
        }
    }
}

/// Severity level for obstacles
enum ObstacleSeverity: String, Codable {
    case low = "Low"
    case medium = "Medium"
    case high = "High"
    case blocking = "Blocking"
    
    var icon: String {
        switch self {
        case .low:
            return "exclamationmark.circle"
        case .medium:
            return "exclamationmark.triangle"
        case .high:
            return "exclamationmark.triangle.fill"
        case .blocking:
            return "xmark.octagon.fill"
        }
    }
    
    var colorName: String {
        switch self {
        case .low:
            return "yellow"
        case .medium:
            return "orange"
        case .high:
            return "red"
        case .blocking:
            return "red"
        }
    }
}

/// Type of accessibility feature available
enum AccessibilityFeatureType: String, Codable {
    case ramp = "Ramp"
    case elevator = "Elevator"
    case tactilePaving = "Tactile Paving"
    case audioGuide = "Audio Guide"
    case widePath = "Wide Path"
    case restArea = "Rest Area"
    case accessibleToilet = "Accessible Toilet"
    case visualSignage = "Visual Signage"
    case smoothSurface = "Smooth Surface"
    
    var icon: String {
        switch self {
        case .ramp:
            return "arrow.up.right"
        case .elevator:
            return "arrow.up.arrow.down"
        case .tactilePaving:
            return "grid"
        case .audioGuide:
            return "speaker.wave.2"
        case .widePath:
            return "arrow.left.and.right"
        case .restArea:
            return "chair"
        case .accessibleToilet:
            return "toilet"
        case .visualSignage:
            return "signpost.right"
        case .smoothSurface:
            return "road.lanes"
        }
    }
}

