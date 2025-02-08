//
//  String+Extension.swift
//  CulinaryCatalog
//
//  Created by Sarah Clark on 1/30/25.
//

extension String {
    /// Extracts the YouTube video ID from a given URL string.
    ///
    /// This method uses regular expressions to parse and extract the 11-character YouTube video ID from various URL formats. It supports:
    /// - Standard YouTube links (e.g., `youtube.com/watch?v=dQw4w9WgXcQ`)
    /// - Shortened youtu.be links (e.g., `youtu.be/dQw4w9WgXcQ`)
    /// - Embedded video links (e.g., `youtube.com/embed/dQw4w9WgXcQ`)
    /// - URLs where the video ID is part of query parameters
    ///
    /// It is case-insensitive to the 'v' in 'v=' and flexible enough to handle slight variations in URL structure.
    ///
    /// - Returns: An optional `String` containing the extracted YouTube video ID if a match is found, otherwise `nil`. If multiple matches are possible, it returns the first valid match.
    ///
    /// - Note: This method does not validate if the extracted ID corresponds to an existing video; it merely extracts what looks like a valid YouTube video ID from the URL.
    func extractYouTubeID() -> String? {
        // Define patterns for matching different YouTube URL formats
        let patterns = [
            #/(?i)(?:https?://)?(?:www\.)?(?:youtube\.com/(?:[^/\n\s]+/\S+/|(?:v|e(?:mbed)?)/|\S*?[?&]v=)|youtu\.be/)([a-zA-Z0-9_-]{11})/#,
            #/(?i)v=([a-zA-Z0-9_-]{11})/#,
            #/(?i)be\/([a-zA-Z0-9_-]{11})/#
        ]

        // Try to match the string against each pattern
        for pattern in patterns {
            if let match = self.firstMatch(of: pattern) {
                return String(match.output.1)
            }
        }
        return nil
    }

}
