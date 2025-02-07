//
//  String+Extension.swift
//  CulinaryCatalog
//
//  Created by Sarah Clark on 1/30/25.
//

extension String {
    /// Extracts the YouTube video ID from a given URL string.
    ///
    /// This method attempts to find and return the 11-character YouTube video ID from
    /// various URL formats including standard YouTube links, shortened youtu.be links,
    /// and embedded video links. It uses regular expressions to match against several
    /// common patterns for YouTube video URLs.
    ///
    /// - Returns: An optional `String` containing the extracted YouTube video ID if found,
    ///            otherwise `nil`.
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
