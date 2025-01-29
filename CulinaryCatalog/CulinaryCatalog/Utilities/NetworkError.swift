//
//  NetworkError.swift
//  CulinaryCatalog
//
//  Created by Sarah Clark on 1/29/25.
//

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case invalidData
    case decodingError
}
