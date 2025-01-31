//
//  RecipeDataRepository.swift
//  CulinaryCatalog
//
//  Created by Sarah Clark on 1/31/25.
//

protocol RecipeRepositoryProtocol {
    func fetchRecipes() async throws -> [RecipeModel]
    func refreshRecipes() async throws -> [RecipeModel]
}
