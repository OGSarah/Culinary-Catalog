//
//  MockURLSession.swift
//  CulinaryCatalog
//
//  Created by Sarah Clark on 2/4/25.
//

import Foundation
@testable import CulinaryCatalog

class MockURLSession: URLSessionProtocol {
    var data: Data?
    var response: URLResponse?
    var error: Error?

    func data(from url: URL) async throws -> (Data, URLResponse) {
        if let error = error {
            throw error
        }
        return (data ?? Data(), response ?? URLResponse())
    }
}
