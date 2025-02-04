//
//  URLSessionProtocol.swift
//  CulinaryCatalog
//
//  Created by Sarah Clark on 2/4/25.
//

import Foundation

protocol URLSessionProtocol {
    func data(from url: URL) async throws -> (Data, URLResponse)
}
