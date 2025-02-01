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
/// - Note: Conforms to `ObservableObject` for reactive UI updates
/// - SeeAlso: `YouTubeVideoModel`, `YouTubeVideoView`
class YouTubeVideoViewModel: ObservableObject, YouTubeVideoViewModelProtocol {
    /// The underlying data model for the YouTube video
    ///
    /// Provides core data and URL generation logic for the video
    private let model: YouTubeVideoModel

    /// The generated embed URL for the YouTube video
    ///
    /// - Note: Published to trigger UI updates when the URL changes
    /// - Returns: A valid YouTube embed URL or `nil` if generation fails
    @Published var embedURL: URL?

    /// Stores any errors that occur during video ID validation or URL generation
    ///
    /// - Note: Published to allow UI to react to error states
    /// - Important: Can be set to various error types defined in `YouTubeVideoError`
    @Published var error: Error?

    /// Initializes a new YouTube video view model
    ///
    /// - Parameters:
    ///   - videoID: The unique identifier for the YouTube video
    ///
    /// - Note: Automatically validates the video ID and generates an embed URL
    /// - Precondition: Video ID should be a valid 11-character string
    init(videoID: String) {
        // Create the underlying model
        let model = YouTubeVideoModel(videoID: videoID)
        self.model = model

        // Set initial embed URL
        self.embedURL = model.embedURL

        // Validate the video ID
        validateVideoID(videoID)
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
        // Validate video ID length and non-emptiness
        guard !videoID.isEmpty, videoID.count == 11 else {
            // Set error if validation fails
            error = YouTubeVideoError.invalidVideoID
            return
        }
    }

}
