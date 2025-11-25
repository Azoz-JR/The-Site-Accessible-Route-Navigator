# Quick Enhancements (30-60 minutes each)

These are ready-to-implement features you can add during the hackathon if you have extra time or want to respond to judge feedback.

---

## 1. Dark Mode Support (30 minutes)

The app already uses semantic colors, but you can test and verify dark mode:

### Test Dark Mode
1. Run app in simulator
2. Go to Settings > Developer > Dark Appearance
3. Verify all screens look good

### If adjustments needed:
```swift
// In any view where colors need adjustment
@Environment(\.colorScheme) var colorScheme

var backgroundColor: Color {
    colorScheme == .dark ? Color(.systemGray6) : Color(.systemBackground)
}
```

---

## 2. Share Route Feature (30 minutes)

Add ability to share route with friends/family.

### Add to RouteDetailView.swift

```swift
// Add to RouteDetailView
.toolbar {
    ToolbarItem(placement: .topBarTrailing) {
        Button(action: shareRoute) {
            Image(systemName: "square.and.arrow.up")
        }
        .accessibilityLabel("Share route")
    }
}

// Add method
private func shareRoute() {
    let text = """
    Check out this accessible route in Trieste!
    
    From: \(selectedRoute.origin.name)
    To: \(selectedRoute.destination.name)
    Distance: \(selectedRoute.distanceFormatted)
    Time: \(selectedRoute.estimatedTime) minutes
    Accessibility Score: \(Int(selectedRoute.accessibilityScore * 100))%
    
    Obstacles: \(selectedRoute.obstacles.count)
    Features: \(selectedRoute.features.count)
    
    Shared from Accessible Route Navigator
    """
    
    let activityVC = UIActivityViewController(
        activityItems: [text],
        applicationActivities: nil
    )
    
    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
       let window = windowScene.windows.first,
       let rootVC = window.rootViewController {
        rootVC.present(activityVC, animated: true)
    }
}
```

---

## 3. Route Favorites (45 minutes)

Allow users to save favorite routes.

### Add to NavigationService.swift

```swift
// Add property
@Published var favoriteRoutes: [Route] = []

// Add methods
func toggleFavorite(_ route: Route) {
    if let index = favoriteRoutes.firstIndex(where: { $0.id == route.id }) {
        favoriteRoutes.remove(at: index)
    } else {
        favoriteRoutes.append(route)
    }
    saveFavorites()
}

func isFavorite(_ route: Route) -> Bool {
    favoriteRoutes.contains(where: { $0.id == route.id })
}

private func saveFavorites() {
    // In production, save to UserDefaults or CloudKit
    // For demo, just keep in memory
}
```

### Add to RouteDetailView.swift

```swift
// Add button next to share
Button(action: {
    navigationService.toggleFavorite(selectedRoute)
    let feedback = UINotificationFeedbackGenerator()
    feedback.notificationOccurred(.success)
}) {
    Image(systemName: navigationService.isFavorite(selectedRoute) ? "heart.fill" : "heart")
        .foregroundStyle(navigationService.isFavorite(selectedRoute) ? .red : .primary)
}
.accessibilityLabel(navigationService.isFavorite(selectedRoute) ? "Remove from favorites" : "Add to favorites")
```

---

## 4. Profile Comparison View (60 minutes)

Show how same route differs for different profiles.

### Create new file: Views/ProfileComparisonView.swift

```swift
import SwiftUI

struct ProfileComparisonView: View {
    let route: Route
    let profiles: [AccessibilityProfile]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("How different users experience this route")
                    .font(.headline)
                    .padding()
                
                ForEach(profiles, id: \.rawValue) { profile in
                    ProfileRouteCard(route: route, profile: profile)
                }
            }
            .padding()
        }
        .navigationTitle("Profile Comparison")
    }
}

struct ProfileRouteCard: View {
    let route: Route
    let profile: AccessibilityProfile
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Profile header
            HStack {
                Image(systemName: profile.icon)
                    .font(.title2)
                Text(profile.rawValue)
                    .font(.headline)
                Spacer()
                
                // Suitability indicator
                Image(systemName: route.isSuitableFor(profile: profile) ? "checkmark.circle.fill" : "xmark.circle.fill")
                    .foregroundStyle(route.isSuitableFor(profile: profile) ? .green : .red)
            }
            
            // Relevant obstacles
            let relevantObstacles = route.obstacles.filter { $0.affectsProfiles.contains(profile) }
            if !relevantObstacles.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Obstacles: \(relevantObstacles.count)")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    
                    ForEach(relevantObstacles.prefix(2)) { obstacle in
                        HStack {
                            Image(systemName: obstacle.severity.icon)
                                .foregroundStyle(.orange)
                            Text(obstacle.type.rawValue)
                                .font(.caption)
                        }
                    }
                }
            }
            
            // Relevant features
            let relevantFeatures = route.features.filter { $0.benefitsProfiles.contains(profile) }
            if !relevantFeatures.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Helpful Features: \(relevantFeatures.count)")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    
                    ForEach(relevantFeatures.prefix(2)) { feature in
                        HStack {
                            Image(systemName: feature.type.icon)
                                .foregroundStyle(.green)
                            Text(feature.type.rawValue)
                                .font(.caption)
                        }
                    }
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemGray6))
        )
    }
}
```

### Add to RouteDetailView.swift

```swift
// Add button in toolbar
.toolbar {
    ToolbarItem(placement: .topBarTrailing) {
        NavigationLink {
            ProfileComparisonView(
                route: selectedRoute,
                profiles: AccessibilityProfile.allCases
            )
        } label: {
            Image(systemName: "person.2")
        }
        .accessibilityLabel("Compare profiles")
    }
}
```

---

## 5. Filter POIs by Accessibility (30 minutes)

Add filter to show only highly accessible POIs.

### Add to MapView.swift

```swift
// Add state
@State private var showOnlyAccessible = false

// Add computed property
private var filteredPOIs: [POI] {
    if showOnlyAccessible {
        return navigationService.allPOIs.filter { poi in
            poi.accessibilityRating(for: selectedProfile) >= 0.8
        }
    }
    return navigationService.allPOIs
}

// Update Map to use filteredPOIs instead of navigationService.allPOIs
Map(position: $cameraPosition) {
    ForEach(filteredPOIs) { poi in
        // ... existing code
    }
}

// Add toggle in bottom sheet
Toggle("Only show accessible locations", isOn: $showOnlyAccessible)
    .padding(.horizontal)
```

---

## 6. Estimated Calories Burned (15 minutes)

Add health benefit information.

### Add to Route.swift

```swift
// Add computed property
var estimatedCalories: Int {
    // Rough estimate: ~80 calories per km walking
    Int(distance / 1000 * 80)
}
```

### Add to RouteDetailView.swift

```swift
// Add to metrics row
MetricView(
    icon: "flame",
    value: "\(selectedRoute.estimatedCalories)",
    label: "Calories"
)
```

---

## 7. Weather-Aware Suggestions (30 minutes)

Mock weather warnings for obstacles.

### Add to RouteDetailView.swift

```swift
// Add state
@State private var currentWeather: Weather = .sunny

enum Weather {
    case sunny, rainy, windy
    
    var icon: String {
        switch self {
        case .sunny: return "sun.max.fill"
        case .rainy: return "cloud.rain.fill"
        case .windy: return "wind"
        }
    }
}

// Add weather warning section
if currentWeather == .rainy {
    HStack {
        Image(systemName: "exclamationmark.triangle.fill")
            .foregroundStyle(.orange)
        VStack(alignment: .leading) {
            Text("Rain Alert")
                .font(.headline)
            Text("Cobblestone sections may be slippery. Consider alternative route.")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
    .padding()
    .background(
        RoundedRectangle(cornerRadius: 12)
            .fill(Color.orange.opacity(0.1))
    )
}
```

---

## 8. Route History (45 minutes)

Show previously calculated routes.

### Add to NavigationService.swift

```swift
@Published var routeHistory: [Route] = []

func addToHistory(_ route: Route) {
    // Remove duplicates
    routeHistory.removeAll { $0.id == route.id }
    // Add to front
    routeHistory.insert(route, at: 0)
    // Keep only last 10
    if routeHistory.count > 10 {
        routeHistory = Array(routeHistory.prefix(10))
    }
}
```

### Add to MapView.swift

```swift
// Add section in bottom sheet
if !navigationService.routeHistory.isEmpty {
    VStack(alignment: .leading, spacing: 12) {
        Text("Recent Routes")
            .font(.headline)
            .padding(.horizontal)
        
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(navigationService.routeHistory.prefix(5)) { route in
                    Button(action: {
                        selectedOrigin = route.origin
                        selectedDestination = route.destination
                        findRoute()
                    }) {
                        VStack(alignment: .leading) {
                            Text(route.origin.name)
                                .font(.caption)
                            Image(systemName: "arrow.down")
                                .font(.caption2)
                            Text(route.destination.name)
                                .font(.caption)
                        }
                        .padding(8)
                        .background(Color(.systemGray6))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}
```

---

## 9. Accessibility Score Breakdown (30 minutes)

Show detailed scoring components.

### Add to RouteDetailView.swift

```swift
struct ScoreBreakdownView: View {
    let route: Route
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Score Breakdown")
                .font(.headline)
            
            ScoreComponent(label: "Surface Quality", score: surfaceScore)
            ScoreComponent(label: "Path Width", score: widthScore)
            ScoreComponent(label: "Obstacles", score: obstacleScore)
            ScoreComponent(label: "Features", score: featureScore)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemGray6))
        )
    }
    
    private var surfaceScore: Double {
        // Mock calculation
        0.9
    }
    
    private var widthScore: Double {
        0.85
    }
    
    private var obstacleScore: Double {
        let severity = route.obstacles.map { Double($0.severity == .blocking ? 0 : $0.severity == .high ? 0.3 : $0.severity == .medium ? 0.6 : 0.8) }.min() ?? 1.0
        return severity
    }
    
    private var featureScore: Double {
        min(1.0, Double(route.features.count) * 0.2)
    }
}

struct ScoreComponent: View {
    let label: String
    let score: Double
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(label)
                    .font(.subheadline)
                Spacer()
                Text("\(Int(score * 100))%")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(scoreColor)
            }
            
            ProgressView(value: score)
                .tint(scoreColor)
        }
    }
    
    private var scoreColor: Color {
        score >= 0.8 ? .green : score >= 0.5 ? .orange : .red
    }
}

// Add to route detail view
ScoreBreakdownView(route: selectedRoute)
```

---

## 10. Export Route to PDF (Advanced, 60+ minutes)

Generate shareable PDF with route details.

### Add to RouteDetailView.swift

```swift
import PDFKit

func generatePDF() -> PDFDocument {
    let pdfMetaData = [
        kCGPDFContextCreator: "Accessible Route Navigator",
        kCGPDFContextTitle: selectedRoute.name
    ]
    let format = UIGraphicsPDFRendererFormat()
    format.documentInfo = pdfMetaData as [String: Any]
    
    let pageRect = CGRect(x: 0, y: 0, width: 595, height: 842) // A4 size
    let renderer = UIGraphicsPDFRenderer(bounds: pageRect, format: format)
    
    let data = renderer.pdfData { (context) in
        context.beginPage()
        
        let titleFont = UIFont.boldSystemFont(ofSize: 24)
        let bodyFont = UIFont.systemFont(ofSize: 12)
        
        // Title
        let title = selectedRoute.name
        title.draw(at: CGPoint(x: 20, y: 20), withAttributes: [.font: titleFont])
        
        // Route info
        var yPosition: CGFloat = 60
        let routeInfo = [
            "From: \(selectedRoute.origin.name)",
            "To: \(selectedRoute.destination.name)",
            "Distance: \(selectedRoute.distanceFormatted)",
            "Time: \(selectedRoute.estimatedTime) minutes",
            "Accessibility Score: \(Int(selectedRoute.accessibilityScore * 100))%"
        ]
        
        for info in routeInfo {
            info.draw(at: CGPoint(x: 20, y: yPosition), withAttributes: [.font: bodyFont])
            yPosition += 20
        }
        
        // Obstacles
        yPosition += 20
        "Obstacles:".draw(at: CGPoint(x: 20, y: yPosition), withAttributes: [.font: titleFont])
        yPosition += 30
        
        for obstacle in selectedRoute.obstacles {
            let obstacleText = "• \(obstacle.type.rawValue) - \(obstacle.severity.rawValue)"
            obstacleText.draw(at: CGPoint(x: 30, y: yPosition), withAttributes: [.font: bodyFont])
            yPosition += 20
        }
    }
    
    return PDFDocument(data: data)!
}
```

---

## Testing Checklist After Adding Features

- [ ] Build succeeds without errors
- [ ] All new buttons have accessibility labels
- [ ] VoiceOver announces new features correctly
- [ ] Haptic feedback added where appropriate
- [ ] Colors work in both light and dark mode
- [ ] Layout works on different screen sizes
- [ ] No performance issues (60fps maintained)

---

## Priority Order (if time is limited)

1. **Share Route** (30 min) - Demonstrates practical utility
2. **Profile Comparison** (60 min) - Shows off the main feature
3. **Filter POIs** (30 min) - Improves usability
4. **Route Favorites** (45 min) - Shows consideration for repeat users
5. **Score Breakdown** (30 min) - Adds transparency

---

## Remember

- Test each feature before moving to the next
- Keep commits small and focused
- Don't break existing functionality
- Prioritize features judges will notice
- Keep accessibility in mind for all additions

**Good luck! 🚀**

