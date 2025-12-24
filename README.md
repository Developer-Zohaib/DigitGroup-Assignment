# DigitGroup Healthcare App

iOS healthcare app showcasing **MVVM-C** architecture with Clean Architecture principles.

## Features

- **Patient Profile** – View patient info, medical history, emergency contacts
- **Appointments** – Upcoming/past appointments with detail view
- **Vitals** – Health metrics dashboard

## Architecture

**MVVM-C** (Model-View-ViewModel-Coordinator) with three layers:

```
Presentation → Domain → Data
```

- **Presentation**: ViewControllers (UI), ViewModels (logic), Coordinators (navigation)
- **Domain**: Entities, Use Cases, Repository protocols
- **Data**: Repositories, Data Sources (mock for now, swappable to network)

### Key Decisions

- ViewModels have no UIKit dependency
- Coordinators handle all navigation
- Constructor-based dependency injection
- Combine for reactive state management

## Testing

Unit tests cover ViewModels, Use Cases, and Repositories using mock implementations.

## Accessibility

- Dynamic Type support via `UIFontMetrics`
- VoiceOver labels on interactive elements
- Light/Dark mode support

## Requirements

- iOS 15.0+
- Xcode 15.0+
- Swift 5.9+
