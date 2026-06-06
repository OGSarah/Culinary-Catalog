<div align="center">
  <img src="https://github.com/OGSarah/Culinary-Catalog/blob/5744962eb9e533a2cef942dfb2e6c7651a1c4ac9/screenshots/AppIcon.png" width="300" style="border: 3px solid white; border-radius: 15px; vertical-align: middle; margin-right: 20px;">
  <h1 style="display: inline-block; vertical-align: middle;">Culinary Catalog</h1>
</div>

A polished iOS recipe management app built with SwiftUI that seamlessly integrates CoreData and async/await networking to provide a smooth, responsive recipe browsing experience. The app fetches and displays recipe data from a remote API, allowing users to explore, search, and interact with a comprehensive collection of culinary inspirations, with full accessibility support and end-to-end test coverage.


## Screenshots:

Here are some screenshots showcasing the app's features:

<div align="center">
  <div style="border: 2px solid white; border-radius: 10px;">
    <img width="16%" src="https://github.com/OGSarah/Culinary-Catalog/blob/315cb3822a1957dda208750d117d26a357d1b883/screenshots/recipelistdarkmode.png">
    <img width="16%" src="https://github.com/OGSarah/Culinary-Catalog/blob/315cb3822a1957dda208750d117d26a357d1b883/screenshots/recipelistlightmode.png">
    <img width="16%" src="https://github.com/OGSarah/Culinary-Catalog/blob/315cb3822a1957dda208750d117d26a357d1b883/screenshots/searchfunctionalitydarkmode.png">
    <img width="16%" src="https://github.com/OGSarah/Culinary-Catalog/blob/315cb3822a1957dda208750d117d26a357d1b883/screenshots/searchfunctionalitylightmode.png">
    <img width="16%" src="https://github.com/OGSarah/Culinary-Catalog/blob/b91e80f9bfbf8e00c8ce36ac5d311e66a049072e/screenshots/recipedetaildarkmode.png">
    <img width="16%" src="https://github.com/OGSarah/Culinary-Catalog/blob/b91e80f9bfbf8e00c8ce36ac5d311e66a049072e/screenshots/recipedetaillightmode.png">
  </div>
</div>

## Key Features:
- SwiftUI interface with light and dark mode support
- CoreData local storage with on-disk and in-memory store types
- Asynchronous API data fetching with `async/await`
- Image caching backed by CoreData binary attributes
- Responsive search across recipe names and cuisine types
- Pull-to-refresh and animated toolbar refresh button
- Embedded YouTube video player for selected recipes
- Robust error handling with user-facing alerts
- Full VoiceOver support with descriptive labels and hints
- Dynamic Type support up to accessibility content size categories
- Centralized accessibility identifiers shared between app and UI test target
- Code quality enforcement through SwiftLint
- Comprehensive test coverage (unit + UI + accessibility tests)

## Technologies:
- Swift 6
- SwiftUI
- Swift Testing framework (unit tests)
- XCTest + XCUIAutomation (UI tests)
- CoreData
- Async/Await
- WebKit
- RESTful API Integration
- iOS 26 minimum OS target

## Architecture & Design Patterns:
- MVVM
- Dependency Injection (network manager and URL session protocols)
- Protocol-oriented design (`NetworkManagerProtocol`, `URLSessionProtocol`, `RecipeListViewModelProtocol`, `RecipeRowViewModelProtocol`, `YouTubeVideoViewModelProtocol`, `CountryFlagProtocol`)
- Repository-like CoreData access through `CoreDataController`
- Strict `@MainActor` boundaries on view models
- Single source of truth for accessibility identifiers (`AccessibilityIdentifiers`)

### Focus Areas:
1. **CoreData Integration**
   - Clean separation between persistent and in-memory stores
   - Proper use of `NSInMemoryStoreType` for tests and previews
   - A dedicated `uiTestingSeeded()` factory provides deterministic fixtures for UI tests, eliminating the need to hit the live network during automation.

2. **SwiftUI Implementation**
   - Composable view structure with private computed sub-views (`recipeHeaderSection`, `recipeDetailsCard`, `sourceURLSection`, `youtubeVideoSection`)
   - Modern `containerRelativeFrame` sizing rather than deprecated geometry readers
   - Multiple preview configurations (light/dark, empty state) per view

3. **Networking and Data Flow**
   - `NetworkManager` is an `actor` for thread-safe network access
   - `URLSession` is hidden behind `URLSessionProtocol` so tests can inject `MockURLSession` and assert on every error branch
   - JSON decoded via Codable DTOs (`RecipeDTO`) and mapped into domain models (`RecipeModel`) to keep transport and domain concerns separate

4. **Error Handling**
   - Typed errors (`NetworkError`, `YouTubeVideoError`) with case-by-case test coverage
   - `RecipeListViewModel.errorMessage` surfaces failures to the UI via SwiftUI alerts
   - Network failures during refresh do not leave the UI stuck in a loading state

5. **Accessibility**
   - Every interactive element has an accessibility identifier and a descriptive label
   - Country flag emojis are read as `"<Cuisine> cuisine"` instead of the underlying glyph
   - Recipe rows combine cuisine and name into a single VoiceOver-friendly announcement
   - Dynamic Type behavior is exercised in `CulinaryCatalogAccessibilityTests`

### Testing

- **99 total tests** (unit + UI), all passing
- **Unit tests** use the Swift Testing framework with `@Test` and `#expect`, organized by feature:
  - `CoreDataControllerTests`, `RecipeModelTests`, `RecipeDTOTests`, `RecipeDetailStateTests`, `YouTubeVideoModelTests`
  - `NetworkManagerTests` (uses `MockURLSession` — no network access required)
  - `NetworkErrorTests`, `YouTubeVideoErrorTests`
  - `RecipeListViewModelTests`, `RecipeDetailViewModelTests`, `RecipeRowViewModelTests`, `YouTubeViewModelTests`
  - `StringExtensionTests` (YouTube ID extraction across multiple URL formats)
- **UI tests** (XCUITest) launch the app with `-uiTesting`, swapping the persistent stack for a seeded in-memory store so tests are deterministic and network-independent:
  - `CulinaryCatalogUITests` — list, search, navigation, refresh
  - `CulinaryCatalogAccessibilityTests` — VoiceOver labels, descriptive hints, Dynamic Type at `AccessibilityXL`
- CoreData test suites use `.serialized` so parallel `NSPersistentContainer` initialization cannot race
- Test plan keeps unit tests parallel (fast) and UI tests sequential (reliable)

### Time Spent:
- 40% on data modeling, Core Data setup, and protocol boundaries
- 30% on SwiftUI views, view models, and previews
- 20% on networking, error handling, and offline/online consistency
- 10% on testing, accessibility wiring, and documentation

### Trade-offs and Decisions:
- I went with CoreData to save the download images and the rest of the data from the network. 

### Weakest Part of the Project:
- Testing. See below.

### Additional Information:
A few insights and constraints:

- Testing: If I had more time I would have updated the unit tests after I did the latest code changes, I would do accessibility testing, and added UI testing.
- **CoreData over file/SQLite** for caching: chosen so downloaded image data can travel with each recipe record and benefit from CoreData's faulting and migration story if the schema evolves.
- **Live in-memory seed for UI tests** rather than mocking `NetworkManager` at the SwiftUI layer: the launch-argument approach (`-uiTesting`) keeps production code paths untouched while still giving tests a deterministic state.
- **Mirror copy of accessibility identifiers** in the UI test target: UI test targets cannot use `@testable import`, so a thin mirror is the pragmatic alternative to a shared package.
- **Serialized CoreData test suites**: parallel `NSPersistentContainer(name:)` initialization can hit a model-cache race; `.serialized` is a low-cost fix that keeps the rest of the unit-test run parallel and fast.

## License

Released under the [MIT License](LICENSE). © 2026 SarahUniverse
