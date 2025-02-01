//
//  YouTubeVideoModel.swift
//  CulinaryCatalog
//
//  Created by Sarah Clark on 1/31/25.
//

import Foundation

/// Represents a model for a YouTube video, encapsulating video-specific data and utilities.
struct YouTubeVideoModel {
    /// The unique identifier for the YouTube video.
    let videoID: String

    /// Generates the full YouTube embed URL for the video.
    ///
    /// - Returns: An optional `URL` representing the YouTube embed link, or `nil` if the URL cannot be created.
    var embedURL: URL? {
        URL(string: "https://www.youtube.com/embed/\(videoID)")
    }

}
