//
//  MockRecipeDataRepository.swift
//  CulinaryCatalog
//
//  Created by Sarah Clark on 2/6/25.
//

import Foundation
import Testing
@testable import CulinaryCatalog

class MockRecipeDataRepository {
    var recipesToReturn: [RecipeModel] = []
    var shouldThrowError = false

    func fetchRecipes() async throws -> [RecipeModel] {
        if shouldThrowError {
            throw NSError(domain: "TestError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Simulated fetch error"])
        }
        return recipesToReturn
    }

    func refreshRecipes() async throws -> [RecipeModel] {
        if shouldThrowError {
            throw NSError(domain: "TestError", code: 2, userInfo: [NSLocalizedDescriptionKey: "Simulated refresh error"])
        }
        return recipesToReturn
    }
}
