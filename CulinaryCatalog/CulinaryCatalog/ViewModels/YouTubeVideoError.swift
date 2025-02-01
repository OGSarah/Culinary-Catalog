//
//  YouTubeVideoError.swift
//  CulinaryCatalog
//
//  Created by Sarah Clark on 1/31/25.
//

/// Represents potential errors that can occur when working with YouTube video functionality.
///
/// This enum provides specific error cases for YouTube video-related operations,
/// allowing for more precise error handling and debugging.
///
/// - Note: Conforms to Swift's `Error` protocol for use with do-catch error handling
/// - SeeAlso: `YouTubeVideoView`, `YouTubeVideoViewModel`
enum YouTubeVideoError: Error {
    /// Indicates that the provided YouTube video ID is invalid.
    ///
    /// This error is raised when:
    /// - The video ID does not meet the expected format
    /// - The video ID is empty or incorrectly structured
    /// - The video ID does not correspond to a valid YouTube video
    ///
    /// - Example: A video ID that is too short or contains invalid characters
    case invalidVideoID

    /// Represents an error that occurred during network-related operations.
    ///
    /// This error can be triggered by various network-related issues, such as:
    /// - No internet connection
    /// - Timeout during video metadata or embed URL retrieval
    /// - Server-side errors
    /// - Inability to load the YouTube video
    ///
    /// - Example: Failed to fetch video information or load the video embed
    case networkError
}
