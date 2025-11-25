//
//  ObstacleRow.swift
//  The Site Accessible Route Navigator
//
//  Created by Abdelaziz Salah on 25/11/25.
//

import SwiftUI

/// Component displaying obstacle information with severity indicator
struct ObstacleRow: View {
    let obstacle: Obstacle
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            // Severity icon
            Image(systemName: obstacle.severity.icon)
                .font(.title2)
                .foregroundStyle(severityColor)
                .frame(width: 32)
                .accessibilityHidden(true)
            
            VStack(alignment: .leading, spacing: 8) {
                // Obstacle type and severity
                HStack {
                    Text(obstacle.type.rawValue)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                    
                    Spacer()
                    
                    Text(obstacle.severity.rawValue)
                        .font(.caption)
                        .fontWeight(.medium)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(
                            Capsule()
                                .fill(severityColor.opacity(0.2))
                        )
                        .foregroundStyle(severityColor)
                }
                
                // Description
                Text(obstacle.description)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
                
                // Alternative if available
                if let alternative = obstacle.alternative {
                    HStack(alignment: .top, spacing: 6) {
                        Image(systemName: "lightbulb.fill")
                            .font(.caption)
                            .foregroundStyle(.yellow)
                        
                        Text(alternative)
                            .font(.caption)
                            .foregroundStyle(.primary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding(8)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.yellow.opacity(0.1))
                    )
                }
                
                // Affected profiles
                if !obstacle.affectsProfiles.isEmpty {
                    HStack(spacing: 6) {
                        Text("Affects:")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                        
                        ForEach(obstacle.affectsProfiles, id: \.rawValue) { profile in
                            HStack(spacing: 3) {
                                Image(systemName: profile.icon)
                                    .font(.caption2)
                            }
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(
                                Capsule()
                                    .fill(Color(.systemGray5))
                            )
                        }
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground))
                .shadow(color: severityColor.opacity(0.2), radius: 4, x: 0, y: 2)
        )
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(obstacle.severity.rawValue) severity obstacle: \(obstacle.type.rawValue)")
        .accessibilityValue(obstacle.description + (obstacle.alternative.map { ". Alternative: \($0)" } ?? ""))
    }
    
    private var severityColor: Color {
        switch obstacle.severity {
        case .low:
            return .yellow
        case .medium:
            return .orange
        case .high, .blocking:
            return .red
        }
    }
}

/// Component displaying accessibility feature information
struct AccessibilityFeatureRow: View {
    let feature: AccessibilityFeature
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            // Feature icon
            Image(systemName: feature.type.icon)
                .font(.title3)
                .foregroundStyle(.green)
                .frame(width: 32)
                .accessibilityHidden(true)
            
            VStack(alignment: .leading, spacing: 6) {
                Text(feature.type.rawValue)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                
                Text(feature.description)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
                
                // Benefiting profiles
                if !feature.benefitsProfiles.isEmpty {
                    HStack(spacing: 6) {
                        Text("Benefits:")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                        
                        ForEach(feature.benefitsProfiles, id: \.rawValue) { profile in
                            HStack(spacing: 3) {
                                Image(systemName: profile.icon)
                                    .font(.caption2)
                            }
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(
                                Capsule()
                                    .fill(Color.green.opacity(0.2))
                            )
                            .foregroundStyle(.green)
                        }
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.green.opacity(0.05))
        )
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Accessibility feature: \(feature.type.rawValue)")
        .accessibilityValue(feature.description)
    }
}

#Preview("Obstacle - High Severity") {
    ObstacleRow(
        obstacle: Obstacle(
            type: .stairs,
            latitude: 45.6478,
            longitude: 13.7628,
            description: "Stone staircase with 45 steps, no handrail. Historic section.",
            severity: .blocking,
            affectsProfiles: [.wheelchair, .stroller],
            alternative: "Use elevator at nearby building or take accessible route"
        )
    )
    .padding()
}

#Preview("Accessibility Feature") {
    AccessibilityFeatureRow(
        feature: AccessibilityFeature(
            type: .ramp,
            latitude: 45.6478,
            longitude: 13.7628,
            description: "Modern ramp with handrails, compliant with accessibility standards.",
            benefitsProfiles: [.wheelchair, .stroller]
        )
    )
    .padding()
}

