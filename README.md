<div align="center">
  <img src="https://raw.githubusercontent.com/Pearljam66/Culinary-Catalog/dd591db49ac547498df52a153c09fb687839a26b/CulinaryCatalog/CulinaryCatalog/Assets.xcassets/AppIcon.appiconset/chefhat.jpg" width="150" style="border: 3px solid white; border-radius: 15px; vertical-align: middle; margin-right: 20px;">
  <h1 style="display: inline-block; vertical-align: middle;">Culinary Catalog</h1>
</div>

A modern iOS recipe management app built with SwiftUI that seamlessly integrates CoreData and async/await networking to provide a smooth, responsive recipe browsing experience. The app fetches and displays recipe data from a remote API, allowing users to explore, search, and interact with a comprehensive collection of culinary inspirations.

*TODO:* Add screenshots and video to highlight features

## Key Features:
- SwiftUI interface
- CoreData local storage
- Asynchronous API data fetching
- Responsive search functionality
- Smooth recipe browsing experience
- Code quality enforcement through SwiftLint
- Test coverage with comprehensive unit and UI tests

## Technologies:
- Swift 6
- SwiftUI
- Swift Testing
- CoreData
- Async/Await
- WebKit
- RESTful API Integration
- iOS 17 minimum OS target

## Architecture & Design Patterns:
- MVVM
- Singleton
- Dependency Injection

### Focus Areas:
1. Core Data Integration:
I focused on getting the Core Data setup right (CoreDataController, RecipeDataRepository).

2. SwiftUI Implementation

3. Networking and Data Flow:
I put a lot of effort into designing a solid network layer with NetworkManager and the RecipeDataRepositoryProtocol.

4. Error Handling:
I made sure to handle errors well (NetworkError, error handling in view models) because I wanted the app to be robust.

### Time Spent:
I spent roughly a 5-day work week on this project. Here's how I split my time:

- 40% on data modeling, Core Data setup, and repository patterns.
- 30% went into crafting those SwiftUI views and view models.
- 20% on networking, error handling, and keeping data consistent between offline and online states.
- 10% was dedicated to testing, debugging, and documenting. 

### Trade-offs and Decisions:

### Weakest Part of the Project:

### Additional Information:
A few insights and constraints:

- Testing: If I had more time I would add more unit tests, I would do accessibility testing, and added UI testing.

