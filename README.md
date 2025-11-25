# Accessible Route Navigator

A prototype iOS app for the SITE Hackathon: "Inclusive Tourism for Everyone" - demonstrating accessible tourism route navigation in Trieste, Italy.

## Overview

This SwiftUI prototype showcases how technology can make tourism more accessible for everyone, including people with disabilities, elderly travelers, and parents with strollers. The app provides intelligent route recommendations based on user accessibility profiles, highlighting obstacles and accessibility features along the way.

## Features

### 1. **Profile-Based Navigation**
- Four accessibility profiles: Wheelchair, Stroller, Visual Impairment, Hearing Impairment
- Routes are filtered and scored based on selected profile
- Personalized recommendations for each user type

### 2. **Interactive Map**
- MapKit integration showing tourist POIs in Trieste
- Color-coded POI markers based on accessibility ratings
- Visual route overlays (green = accessible, yellow = partial, red = challenging)

### 3. **Detailed Route Information**
- Multiple route options with accessibility scores
- Distance and estimated time
- Comprehensive obstacle warnings with alternatives
- Accessibility features highlighted (ramps, elevators, tactile paving, etc.)

### 4. **Real Trieste Data**
Mock data based on actual Trieste landmarks:
- Piazza Unità d'Italia (Main Square)
- Castello di San Giusto (Castle)
- Teatro Romano (Roman Theater)
- Molo Audace (Pier)
- Canal Grande
- Museo Revoltella (Art Museum)

### 5. **Universal Design Principles**
- **VoiceOver Support**: All UI elements have proper accessibility labels and hints
- **Dynamic Type**: Supports system text size preferences (up to xxxLarge)
- **Haptic Feedback**: Tactile feedback for selections and actions
- **High Contrast**: Semantic colors that adapt to accessibility settings
- **Large Touch Targets**: Minimum 44x44pt for all interactive elements

## Architecture

### MV Pattern (Model-View)
- **Models**: Data structures for profiles, POIs, routes, and obstacles
- **Views**: SwiftUI views with built-in state management
- **Services**: `@Observable` NavigationService acts as the app's brain

### Key Technologies
- **SwiftUI**: Modern declarative UI framework
- **MapKit**: Native mapping and location services
- **Observation Framework**: iOS 26 state management
- **Sensory Feedback**: iOS 26 haptic API

## Project Structure

```
The Site Accessible Route Navigator/
├── Models/
│   ├── AccessibilityProfile.swift    # Profile types and enums
│   ├── POI.swift                      # Point of interest model
│   └── Route.swift                    # Route with obstacles/features
├── Services/
│   └── NavigationService.swift       # Mock data and routing logic
├── Views/
│   ├── OnboardingView.swift          # Profile selection
│   ├── MapView.swift                 # Interactive map
│   ├── RouteDetailView.swift         # Route information
│   └── Components/
│       ├── ProfileCard.swift         # Reusable profile card
│       └── ObstacleRow.swift         # Obstacle display
└── The_Site_Accessible_Route_NavigatorApp.swift
```

## How to Use

### Running the App
1. Open `The Site Accessible Route Navigator.xcodeproj` in Xcode
2. Select iPhone simulator (iOS 26+)
3. Press Cmd+R to build and run

### Navigation Flow
1. **Onboarding**: Select your accessibility profile
2. **Map View**: Tap to select starting point and destination
3. **Find Routes**: Calculate accessible route options
4. **Route Details**: Review obstacles, features, and alternatives
5. **Start Navigation**: (Mock) Begin turn-by-turn guidance

## Accessibility Testing

### VoiceOver Testing
1. Enable VoiceOver: Settings > Accessibility > VoiceOver
2. Navigate through the app using swipe gestures
3. All buttons, images, and information are properly labeled

### Dynamic Type Testing
1. Change text size: Settings > Display & Brightness > Text Size
2. App supports sizes up to xxxLarge
3. Layout adapts gracefully to larger text

### High Contrast Testing
1. Enable increased contrast: Settings > Accessibility > Display
2. Color schemes maintain readability
3. Important UI elements remain distinguishable

## Demo Scenarios

### Scenario 1: Wheelchair User
- Select "Wheelchair User" profile
- Navigate from Piazza Unità to Castello di San Giusto
- Observe: Routes prioritize ramps, elevators, and smooth surfaces
- Stairs marked as "Blocking" obstacles

### Scenario 2: Visual Impairment
- Select "Visual Impairment" profile
- Navigate to any destination
- Features: Tactile paving, audio guides highlighted
- VoiceOver provides complete route information

### Scenario 3: Comparing Routes
- Select any profile and destination pair
- View 3 different route options
- Compare accessibility scores, obstacles, and features
- Demonstrates trade-offs between distance and accessibility

## Future Enhancements

For a production version, consider:
1. **Real Routing API**: Integration with OpenStreetMap + accessibility data
2. **User Contributions**: Crowd-sourced obstacle and feature reporting
3. **Real-time Updates**: Construction, temporary obstacles, events
4. **Multi-language Support**: Italian, English, Croatian, Slovenian
5. **Offline Maps**: Download areas for offline navigation
6. **AR Navigation**: Augmented reality wayfinding
7. **Community Features**: Share accessible routes, rate POIs
8. **Transportation Integration**: Bus/tram accessibility information

## Alignment with SITE Project Goals

This prototype addresses key hackathon themes:

✅ **Physical Accessibility**: Routes avoid stairs, prioritize ramps
✅ **Digital Tools**: iOS app with MapKit integration
✅ **Inclusive Communication**: Clear labels, VoiceOver support, visual indicators
✅ **Tailored Experiences**: Profile-based personalization
✅ **Sustainability**: Promotes walking tourism with accessibility
✅ **Universal Design**: Follows WCAG and iOS accessibility guidelines

## Technical Highlights

### Modern iOS Development
- Pure SwiftUI (no UIKit)
- `@Observable` macro for state management (iOS 26)
- Native `sensoryFeedback` API
- MapKit SwiftUI integration
- Comprehensive accessibility implementation

### Code Quality
- Clear separation of concerns
- Reusable components
- Type-safe models
- Documented code
- SwiftUI previews for all views

## Credits

Developed for the SITE Hackathon: "Inclusive Tourism for Everyone"
Trieste, Italy - November 26-27, 2025

### SITE Project Partners
- University of Trieste
- Municipality of Šibenik
- DURA Dubrovnik Development Agency
- Dubrovnik Airport
- Central Marketing Intelligence (Trieste)
- VEASYT (Venice)
- Municipality of Fano
- Faculty of Tourism and Hospitality Management (University of Rijeka)

---

**Note**: This is a prototype with mock data for demonstration purposes. The routing logic, obstacles, and accessibility features are simulated to showcase the concept.

