//
//  YouTubeVideoViewModel.swift
//  CulinaryCatalog
//
//  Created by Sarah Clark on 1/31/25.
//

import Foundation

/// Manages the data and presentation logic for YouTube video embedding.
///
/// This view model handles YouTube video-specific operations, including:
/// - Validating video IDs
/// - Generating embed URLs
/// - Managing error states
///
/// - Note: Uses the `@Observable` macro for reactive UI updates and is isolated to the `MainActor`.
/// - SeeAlso: `YouTubeVideoModel`, `YouTubeVideoView`
@MainActor
@Observable
final class YouTubeVideoViewModel: YouTubeVideoViewModelProtocol {
    /// The underlying data model for the YouTube video
    ///
    /// Provides core data and URL generation logic for the video
    private let model: YouTubeVideoModel

    /// The generated embed URL for the YouTube video
    ///
    /// - Returns: A valid YouTube embed URL or `nil` if generation fails
    var embedURL: URL?

    /// Stores any errors that occur during video ID validation or URL generation
    ///
    /// - Important: Can be set to various error types defined in `YouTubeVideoError`
    var error: Error?

    /// Initializes a new YouTube video view model
    ///
    /// - Parameters:
    ///   - videoID: The unique identifier for the YouTube video
    ///
    /// - Note: Automatically validates the video ID and generates an embed URL
    /// - Precondition: Video ID should be a valid 11-character string
    init(videoID: String) {
        let model = YouTubeVideoModel(videoID: videoID)
        self.model = model

        validateVideoID(videoID)

        if error == nil {
            self.embedURL = model.embedURL
        } else {
            self.embedURL = nil
        }
    }

    /// Validates the provided YouTube video ID
    ///
    /// Checks the video ID for:
    /// - Non-empty string
    /// - Exactly 11 characters long (standard YouTube video ID format)
    ///
    /// - Parameters:
    ///   - videoID: The YouTube video identifier to validate
    ///
    /// - Note: Sets the `error` property if validation fails
    /// - SeeAlso: `YouTubeVideoError.invalidVideoID`
    internal func validateVideoID(_ videoID: String) {
        guard !videoID.isEmpty, videoID.count == 11 else {
            error = YouTubeVideoError.invalidVideoID
            return
        }
    }

}
