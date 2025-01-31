//
//  CountryFlagProtocol.swift
//  CulinaryCatalog
//
//  Created by Sarah Clark on 1/31/25.
//

/// Protocol defining the contract for country flag retrieval
protocol CountryFlagProtocol {
    /// Retrieves the country flag emoji for a given cuisine type
    /// - Parameter cuisineType: The type of cuisine
    /// - Returns: A country flag emoji
    func getCountryFlag(for cuisineType: String) -> String
}
