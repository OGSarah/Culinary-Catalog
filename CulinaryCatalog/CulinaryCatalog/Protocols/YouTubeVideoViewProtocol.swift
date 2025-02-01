//
//  YouTubeVideoViewProtocol.swift
//  CulinaryCatalog
//
//  Created by Sarah Clark on 1/31/25.
//

import Foundation

/// Protocol to define the interface for view models managing YouTube video data within the application.
protocol YouTubeVideoViewModelProtocol: ObservableObject {
    /// The URL for embedding the YouTube video, if valid and available.
    var embedURL: URL? { get }

    /// Holds any error that occurred during video ID processing or URL generation.
    var error: Error? { get }

    /// Validates whether the provided YouTube video ID is correctly formatted.
    ///
    /// - Parameter videoID: The YouTube video ID string to validate.
    /// - Note: This method should set the `error` property if the ID is invalid or clear it if valid.
    func validateVideoID(_ videoID: String)
}
