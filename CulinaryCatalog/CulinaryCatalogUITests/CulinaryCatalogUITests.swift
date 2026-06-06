//
//  CulinaryCatalogUITests.swift
//  CulinaryCatalogUITests
//
//  Created by Sarah Clark on 1/27/25.
//

import XCTest

/// End-to-end UI tests for the CulinaryCatalog app.
///
/// These tests launch the app with the `-uiTesting` flag, which swaps the persistent Core Data
/// stack for an in-memory store pre-seeded with three known recipes. This makes the tests
/// deterministic and removes any dependency on the live network.
final class CulinaryCatalogUITests: XCTestCase {

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

    // MARK: - Recipe List

    @MainActor
    func testRecipeListShowsSeededRecipes() {
        let appleCrumble = app.cells.containing(
            NSPredicate(format: "identifier == %@", UITestIdentifiers.RecipeList.row(for: "Apple & Blackberry Crumble"))
        ).firstMatch
        XCTAssertTrue(appleCrumble.waitForExistence(timeout: 5), "Seeded 'Apple & Blackberry Crumble' should be in the list")

        let banoffee = app.cells.containing(
            NSPredicate(format: "identifier == %@", UITestIdentifiers.RecipeList.row(for: "Banoffee Pie"))
        ).firstMatch
        XCTAssertTrue(banoffee.exists, "Seeded 'Banoffee Pie' should be in the list")

        let pizza = app.cells.containing(
            NSPredicate(format: "identifier == %@", UITestIdentifiers.RecipeList.row(for: "Pizza Margherita"))
        ).firstMatch
        XCTAssertTrue(pizza.exists, "Seeded 'Pizza Margherita' should be in the list")
    }

    @MainActor
    func testNavigationTitleIsRecipes() {
        XCTAssertTrue(app.navigationBars["Recipes"].waitForExistence(timeout: 5))
    }

    @MainActor
    func testRefreshButtonExistsAndIsHittable() {
        let refreshButton = app.buttons[UITestIdentifiers.ContentView.refreshButton]
        XCTAssertTrue(refreshButton.waitForExistence(timeout: 5))
        XCTAssertTrue(refreshButton.isHittable)
    }

    // MARK: - Search

    @MainActor
    func testSearchFiltersRecipesByName() {
        let firstRow = app.cells.firstMatch
        XCTAssertTrue(firstRow.waitForExistence(timeout: 5))

        let searchField = app.searchFields.firstMatch
        XCTAssertTrue(searchField.waitForExistence(timeout: 5))
        searchField.tap()
        searchField.typeText("Pizza")

        let pizza = app.cells.containing(
            NSPredicate(format: "identifier == %@", UITestIdentifiers.RecipeList.row(for: "Pizza Margherita"))
        ).firstMatch
        XCTAssertTrue(pizza.waitForExistence(timeout: 3))

        let banoffee = app.cells.containing(
            NSPredicate(format: "identifier == %@", UITestIdentifiers.RecipeList.row(for: "Banoffee Pie"))
        ).firstMatch
        XCTAssertFalse(banoffee.exists, "'Banoffee Pie' should be filtered out when searching for 'Pizza'")
    }

    @MainActor
    func testSearchFiltersByCuisine() {
        let firstRow = app.cells.firstMatch
        XCTAssertTrue(firstRow.waitForExistence(timeout: 5))

        let searchField = app.searchFields.firstMatch
        XCTAssertTrue(searchField.waitForExistence(timeout: 5))
        searchField.tap()
        searchField.typeText("Italian")

        let pizza = app.cells.containing(
            NSPredicate(format: "identifier == %@", UITestIdentifiers.RecipeList.row(for: "Pizza Margherita"))
        ).firstMatch
        XCTAssertTrue(pizza.waitForExistence(timeout: 3))

        let appleCrumble = app.cells.containing(
            NSPredicate(format: "identifier == %@", UITestIdentifiers.RecipeList.row(for: "Apple & Blackberry Crumble"))
        ).firstMatch
        XCTAssertFalse(appleCrumble.exists, "British recipes should be filtered out when searching for 'Italian'")
    }

    @MainActor
    func testClearingSearchRestoresAllRecipes() {
        let firstRow = app.cells.firstMatch
        XCTAssertTrue(firstRow.waitForExistence(timeout: 5))

        let searchField = app.searchFields.firstMatch
        XCTAssertTrue(searchField.waitForExistence(timeout: 5))
        searchField.tap()
        searchField.typeText("Pizza")

        // Clear the search via the clear button when present
        let clearButton = searchField.buttons["Clear text"]
        if clearButton.exists {
            clearButton.tap()
        } else {
            // Fall back to deleting characters
            searchField.typeText(String(repeating: XCUIKeyboardKey.delete.rawValue, count: 5))
        }

        let banoffee = app.cells.containing(
            NSPredicate(format: "identifier == %@", UITestIdentifiers.RecipeList.row(for: "Banoffee Pie"))
        ).firstMatch
        XCTAssertTrue(banoffee.waitForExistence(timeout: 3))
    }

    // MARK: - Navigation to Detail

    @MainActor
    func testTappingRowNavigatesToDetail() {
        let pizzaRow = app.cells.containing(
            NSPredicate(format: "identifier == %@", UITestIdentifiers.RecipeList.row(for: "Pizza Margherita"))
        ).firstMatch
        XCTAssertTrue(pizzaRow.waitForExistence(timeout: 5))
        pizzaRow.tap()

        let nameLabel = app.staticTexts[UITestIdentifiers.RecipeDetail.nameLabel]
        XCTAssertTrue(nameLabel.waitForExistence(timeout: 5))
        XCTAssertEqual(nameLabel.label, "Pizza Margherita")
    }

    @MainActor
    func testDetailViewShowsCuisineFlag() {
        let pizzaRow = app.cells.containing(
            NSPredicate(format: "identifier == %@", UITestIdentifiers.RecipeList.row(for: "Pizza Margherita"))
        ).firstMatch
        XCTAssertTrue(pizzaRow.waitForExistence(timeout: 5))
        pizzaRow.tap()

        let flag = app.staticTexts[UITestIdentifiers.RecipeDetail.cuisineFlag]
        XCTAssertTrue(flag.waitForExistence(timeout: 5))
    }

    @MainActor
    func testDetailViewShowsSourceLinkWhenAvailable() {
        let pizzaRow = app.cells.containing(
            NSPredicate(format: "identifier == %@", UITestIdentifiers.RecipeList.row(for: "Pizza Margherita"))
        ).firstMatch
        XCTAssertTrue(pizzaRow.waitForExistence(timeout: 5))
        pizzaRow.tap()

        // SwiftUI's Link can be surfaced as either a link or a button depending on the platform.
        let predicate = NSPredicate(format: "identifier == %@", UITestIdentifiers.RecipeDetail.sourceLink)
        let asLink = app.links.matching(predicate).firstMatch
        let asButton = app.buttons.matching(predicate).firstMatch

        let exists = asLink.waitForExistence(timeout: 3) || asButton.waitForExistence(timeout: 3)
        XCTAssertTrue(exists, "Source link should appear in the detail view")
    }

    @MainActor
    func testBackNavigationFromDetailRestoresList() {
        let pizzaRow = app.cells.containing(
            NSPredicate(format: "identifier == %@", UITestIdentifiers.RecipeList.row(for: "Pizza Margherita"))
        ).firstMatch
        XCTAssertTrue(pizzaRow.waitForExistence(timeout: 5))
        pizzaRow.tap()

        XCTAssertTrue(app.staticTexts[UITestIdentifiers.RecipeDetail.nameLabel].waitForExistence(timeout: 5))

        // Navigate back using the navigation bar's back button
        let backButton = app.navigationBars.buttons.element(boundBy: 0)
        backButton.tap()

        XCTAssertTrue(app.navigationBars["Recipes"].waitForExistence(timeout: 5))
    }

}
