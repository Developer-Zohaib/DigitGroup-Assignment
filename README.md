# DigitGroup Healthcare iOS App

A production-grade iOS healthcare application built with **Clean Architecture** and **MVVM-C** pattern.

## Architecture Overview

```
┌─────────────────────────────────────────────────────────────────┐
│                      PRESENTATION LAYER                         │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────────┐ │
│  │ ViewModels  │◄─│ Coordinators│  │    ViewControllers      │ │
│  │ (Combine)   │  │ (Navigation)│  │    (UIKit - UI Only)    │ │
│  └──────┬──────┘  └─────────────┘  └─────────────────────────┘ │
└─────────┼───────────────────────────────────────────────────────┘
          │ depends on
┌─────────▼───────────────────────────────────────────────────────┐
│                        DOMAIN LAYER                             │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────────┐ │
│  │  Use Cases  │  │  Entities   │  │    Repository Protocols │ │
│  │ (Business)  │  │ (Models)    │  │    (Abstractions)       │ │
│  └──────┬──────┘  └─────────────┘  └─────────────────────────┘ │
└─────────┼───────────────────────────────────────────────────────┘
          │ depends on
┌─────────▼───────────────────────────────────────────────────────┐
│                         DATA LAYER                              │
│  ┌─────────────┐  ┌─────────────────────────────────────────┐  │
│  │ Repositories│  │           Data Sources                  │  │
│  │ (Concrete)  │  │  (Mock/Local/Network - swappable)       │  │
│  └─────────────┘  └─────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────────┘
```

## Folder Structure

```
DigitGroup-Assignment/
├── Core/
│   └── DI/
│       └── DependencyContainer.swift      # Dependency injection factory
├── Domain/
│   ├── Entities/
│   │   ├── Patient.swift                  # Patient domain model
│   │   ├── Appointment.swift              # Appointment domain model
│   │   └── Vital.swift                    # Vital domain model
│   ├── Protocols/
│   │   └── RepositoryProtocols.swift      # Repository abstractions
│   └── UseCases/
│       ├── FetchPatientProfileUseCase.swift
│       ├── FetchAppointmentsUseCase.swift
│       └── FetchVitalsUseCase.swift
├── Data/
│   ├── Repositories/
│   │   ├── PatientRepository.swift
│   │   ├── AppointmentRepository.swift
│   │   └── VitalRepository.swift
│   └── DataSources/
│       ├── DataSourceProtocols.swift
│       ├── MockPatientDataSource.swift
│       ├── MockAppointmentDataSource.swift
│       └── MockVitalDataSource.swift
├── Presentation/
│   ├── ViewModels/
│   │   ├── PatientProfileViewModel.swift
│   │   ├── AppointmentsViewModel.swift
│   │   ├── AppointmentDetailViewModel.swift
│   │   └── VitalsViewModel.swift
│   └── Coordinators/
│       ├── Coordinator.swift              # Base protocol
│       ├── AppCoordinator.swift           # Root coordinator
│       ├── PatientFlowCoordinator.swift
│       ├── AppointmentsCoordinator.swift
│       └── VitalsCoordinator.swift
├── Screens/                               # ViewControllers (UI only)
├── Reusable/                              # Reusable UI components
├── DesignSystem/                          # Colors, Fonts, Layout constants
└── DigitGroup-AssignmentTests/
    ├── Mocks/
    ├── ViewModels/
    └── UseCases/
```

## MVVM-C Flow

### Data Flow

```
User Action → ViewController → ViewModel → UseCase → Repository → DataSource
                    ↑              │
                    │              ▼
                    └──── State (Combine) ────┘
```

### Navigation Flow

```
ViewController ──(action)──► ViewModel ──(event)──► Coordinator ──(push/present)──► Next Screen
```

**Key Principle:** ViewControllers do NOT know about navigation or other screens.

## Architecture Rules

### ViewModels
- ✅ No `UIKit` imports
- ✅ Communicate via Combine (`CurrentValueSubject`, `PassthroughSubject`)
- ✅ Handle loading states, data formatting, user actions
- ✅ Depend on protocols only (Use Cases)

### Coordinators
- ✅ Own `UINavigationController`
- ✅ Handle all navigation (push/pop/present)
- ✅ Listen to ViewModel navigation events
- ✅ Create and wire ViewControllers

### Domain Layer
- ✅ No `UIKit` or `Combine` imports in Entities
- ✅ Contains business rules only
- ✅ Fully unit-testable
- ✅ Depends on nothing external

### Repositories
- ✅ Protocol-based abstraction
- ✅ Single source of truth
- ✅ Easy to swap implementations (Mock → Network)

### Dependency Injection
- ✅ No singletons
- ✅ No service locator pattern
- ✅ Constructor-based injection
- ✅ Central factory (`DependencyContainer`)

## Navigation Flows

| From | To | Trigger |
|------|-----|---------|
| Patient Profile | Appointments List | Tap appointments row |
| Patient Profile | Vitals List | Tap vitals row |
| Appointments List | Appointment Detail | Tap appointment cell |
| Vitals List | Vital History | Tap vital card |

## Testability

### What We Test
- **ViewModels**: State transitions, navigation events, data mapping
- **Use Cases**: Business logic, repository interaction
- **Repositories**: Data transformation, filtering logic

### What We Don't Test
- **ViewControllers**: UI layout (use snapshot tests if needed)
- **Coordinators**: Navigation (integration tests)
- **Design System**: Static constants

### Test Doubles
- `MockPatientRepository` - Stubbed repository responses
- `MockFetchPatientProfileUseCase` - Stubbed use case
- All use `Result<T, Error>` for easy success/failure stubbing

## Future Network Extensibility

To replace mock data with real API:

```swift
// 1. Create network data source
final class NetworkPatientDataSource: PatientDataSourceProtocol {
    private let apiClient: APIClient
    
    func fetchCurrentPatient() -> AnyPublisher<Patient, Error> {
        return apiClient.request(.patient)
            .map { dto in dto.toDomain() }
            .eraseToAnyPublisher()
    }
}

// 2. Swap in DependencyContainer
private lazy var patientDataSource: PatientDataSourceProtocol = {
    NetworkPatientDataSource(apiClient: apiClient)  // Changed from MockPatientDataSource
}()
```

No changes needed in:
- ViewModels
- Use Cases
- ViewControllers
- Coordinators

## How to Run

1. Open `DigitGroup-Assignment.xcodeproj` in Xcode
2. Select target device/simulator
3. Press `Cmd + R` to build and run

### Run Tests

```bash
Cmd + U
```

Or via command line:
```bash
xcodebuild test -project DigitGroup-Assignment.xcodeproj \
    -scheme DigitGroup-Assignment \
    -destination 'platform=iOS Simulator,name=iPhone 15'
```

## Trade-offs & Decisions

| Decision | Rationale |
|----------|-----------|
| Combine over closures | Type-safe, composable, first-party framework |
| Coordinators for navigation | Decouples VCs, enables deep linking, testable |
| Protocol-based DI | Enables mocking, no runtime reflection |
| Lazy repository initialization | Performance - only create when needed |
| Grouped UITableView | Native section headers, efficient memory |

## Scalability Notes

- **Adding new features**: Create new Coordinator, wire to parent
- **Adding API integration**: Implement `DataSourceProtocol`, swap in DI
- **Adding caching**: Wrap repository with cache layer
- **Adding analytics**: Inject analytics service into ViewModels
- **Multi-module**: Extract Domain layer to separate Swift Package

## Healthcare Considerations

### Data Privacy & Security

| Consideration | Implementation |
|---------------|----------------|
| **No PII Logging** | ViewModels and Use Cases do not log patient data |
| **Data Isolation** | Domain entities contain no logging statements |
| **Secure by Design** | Repository abstraction prevents direct data access |

### Accessibility Support

| Feature | Implementation |
|---------|----------------|
| **Dynamic Type** | All fonts use `UIFontMetrics` for scalable text |
| **VoiceOver** | Cells include `accessibilityLabel` and `accessibilityHint` |
| **Color Contrast** | WCAG 2.1 AA compliant color combinations |
| **Accessibility Identifiers** | Centralized in `AccessibilityIdentifiers.swift` for UI testing |

### Dynamic Type Example

```swift
static func headline(weight: UIFont.Weight = .semibold) -> UIFont {
    let font = UIFont.systemFont(ofSize: 17, weight: weight)
    return UIFontMetrics(forTextStyle: .headline).scaledFont(for: font)
}
```

### VoiceOver Example

```swift
accessibilityLabel = "\(doctorName), \(specialty). Video consultation at \(time)"
accessibilityHint = "Double tap to view appointment details"
```

## Testing

### Test Coverage

| Layer | Test File | Coverage |
|-------|-----------|----------|
| ViewModels | `PatientProfileViewModelTests.swift` | State transitions, navigation events |
| Use Cases | `FetchPatientProfileUseCaseTests.swift` | Business logic, error handling |
| Repositories | `AppointmentRepositoryTests.swift` | Data filtering, transformation |

### Running Tests

```bash
# Via Xcode
Cmd + U

# Via Command Line
xcodebuild test -project DigitGroup-Assignment.xcodeproj \
    -scheme DigitGroup-Assignment \
    -destination 'platform=iOS Simulator,name=iPhone 15'
```

### What We Test

- **ViewModels**: State transitions, data mapping, navigation events
- **Use Cases**: Repository interactions, business rules
- **Repositories**: Data filtering, transformation logic

### What We Don't Test (and Why)

- **ViewControllers**: UI layout is best tested with snapshot tests
- **Coordinators**: Navigation flow is integration-level concern
- **Design System**: Static constants don't require tests

## Requirements

- iOS 15.0+
- Xcode 15.0+
- Swift 5.9+
