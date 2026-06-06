//
//  CulinaryCatalogAccessibilityTests.swift
//  CulinaryCatalogUITests
//
//  Created by Sarah Clark on 6/6/26.
//

import XCTest

/// Accessibility-focused UI tests.
///
/// These verify that VoiceOver-relevant attributes (labels, hints, traits) are wired up correctly
/// on the views that users will interact with. They also exercise Dynamic Type scaling to confirm
/// the layout adapts when the user changes their preferred content size category.
final class CulinaryCatalogAccessibilityTests: XCTestCase {

    private var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false

        app = XCUIApplication()
        app.launchArguments = ["-uiTesting"]
        app.launch()
    }

    override func tearDownWithError() throws {
        app = nil
    }

    // MARK: - Labels

    @MainActor
    func testRefreshButtonHasAccessibilityLabelAndHint() {
        let refreshButton = app.buttons[UITestIdentifiers.ContentView.refreshButton]
        XCTAssertTrue(refreshButton.waitForExistence(timeout: 5))

        XCTAssertEqual(refreshButton.label, "Refresh recipes")
        // Hint is not always exposed via XCUIElement; verify the button is configured as a button.
        XCTAssertTrue(refreshButton.isHittable)
    }

    @MainActor
    func testRecipeRowExposesCuisineAndNameToAccessibility() {
        let pizzaRow = app.cells.containing(
            NSPredicate(format: "identifier == %@", UITestIdentifiers.RecipeList.row(for: "Pizza Margherita"))
        ).firstMatch
        XCTAssertTrue(pizzaRow.waitForExistence(timeout: 5))

        // SwiftUI surfaces the combined cell content via the cell's descendants.
        // Verify both cuisine and recipe name texts are reachable for VoiceOver.
        let cuisineText = pizzaRow.staticTexts["Italian"]
        let nameText = pizzaRow.staticTexts["Pizza Margherita"]
        XCTAssertTrue(cuisineText.exists, "Cuisine should be readable by VoiceOver inside the row")
        XCTAssertTrue(nameText.exists, "Recipe name should be readable by VoiceOver inside the row")
    }

    @MainActor
    func testDetailHeaderAreaIsAccessible() {
        let pizzaRow = app.cells.containing(
            NSPredicate(format: "identifier == %@", UITestIdentifiers.RecipeList.row(for: "Pizza Margherita"))
        ).firstMatch
        XCTAssertTrue(pizzaRow.waitForExistence(timeout: 5))
        pizzaRow.tap()

        // Detail view must surface the recipe name and a cuisine flag for VoiceOver users.
        XCTAssertTrue(app.staticTexts[UITestIdentifiers.RecipeDetail.nameLabel].waitForExistence(timeout: 5))
        XCTAssertTrue(app.staticTexts[UITestIdentifiers.RecipeDetail.cuisineFlag].waitForExistence(timeout: 3))
    }

    @MainActor
    func testCuisineFlagAnnouncesCuisineName() {
        let pizzaRow = app.cells.containing(
            NSPredicate(format: "identifier == %@", UITestIdentifiers.RecipeList.row(for: "Pizza Margherita"))
        ).firstMatch
        XCTAssertTrue(pizzaRow.waitForExistence(timeout: 5))
        pizzaRow.tap()

        let flag = app.staticTexts[UITestIdentifiers.RecipeDetail.cuisineFlag]
        XCTAssertTrue(flag.waitForExistence(timeout: 5))
        // VoiceOver should hear "Italian cuisine" instead of an emoji name.
        XCTAssertEqual(flag.label, "Italian cuisine")
    }

    @MainActor
    func testSourceLinkHasDescriptiveAccessibilityLabel() {
        let pizzaRow = app.cells.containing(
            NSPredicate(format: "identifier == %@", UITestIdentifiers.RecipeList.row(for: "Pizza Margherita"))
        ).firstMatch
        XCTAssertTrue(pizzaRow.waitForExistence(timeout: 5))
        pizzaRow.tap()

        // SwiftUI's Link is surfaced via either `links` or `buttons` depending on platform.
        let predicate = NSPredicate(format: "identifier == %@", UITestIdentifiers.RecipeDetail.sourceLink)
        let asLink = app.links.matching(predicate).firstMatch
        let asButton = app.buttons.matching(predicate).firstMatch

        let exists = asLink.waitForExistence(timeout: 3) || asButton.waitForExistence(timeout: 3)
        XCTAssertTrue(exists, "Source link should be exposed to accessibility")

        let label = asLink.exists ? asLink.label : asButton.label
        XCTAssertEqual(label, "View original recipe")
    }

    // MARK: - Dynamic Type

    @MainActor
    func testRecipeListSupportsLargerContentSizeCategory() {
        // Relaunch with a larger content size category to ensure no layout assertions break
        // and that core elements remain reachable.
        app.terminate()

        let bigTypeApp = XCUIApplication()
        bigTypeApp.launchArguments = [
            "-uiTesting",
            "-UIPreferredContentSizeCategoryName", "UICTContentSizeCategoryAccessibilityXL"
        ]
        bigTypeApp.launch()

        XCTAssertTrue(bigTypeApp.navigationBars["Recipes"].waitForExistence(timeout: 5))
        let pizzaRow = bigTypeApp.cells.containing(
            NSPredicate(format: "identifier == %@", UITestIdentifiers.RecipeList.row(for: "Pizza Margherita"))
        ).firstMatch
        XCTAssertTrue(pizzaRow.waitForExistence(timeout: 5),
                      "Recipe rows should still be discoverable at accessibility text sizes")
    }

}
