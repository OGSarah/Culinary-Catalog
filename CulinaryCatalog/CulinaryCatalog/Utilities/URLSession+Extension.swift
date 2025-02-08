//
//  URLSession+Extension.swift
//  CulinaryCatalog
//
//  Created by Sarah Clark on 2/4/25.
//

import Foundation

extension URLSession: URLSessionProtocol {
    /// Conforms `URLSession` to `URLSessionProtocol`.
    ///
    /// This extension allows `URLSession` to act as a default implementation for `URLSessionProtocol`, facilitating dependency injection and making it easier to swap out with mock objects for unit testing. By conforming `URLSession` to this protocol, you can use it in places where an `URLSessionProtocol` is expected, enabling more flexible and testable network code.
}
