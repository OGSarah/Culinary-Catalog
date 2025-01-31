//
//  YouTubeVideoViewProtocol.swift
//  CulinaryCatalog
//
//  Created by Sarah Clark on 1/31/25.
//

import Foundation

protocol YouTubeVideoViewModelProtocol: ObservableObject {
    var embedURL: URL? { get }
    var error: Error? { get }

    func validateVideoID(_ videoID: String)
}
