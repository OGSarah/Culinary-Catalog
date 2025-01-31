//
//  String+Extension.swift
//  CulinaryCatalog
//
//  Created by Sarah Clark on 1/30/25.
//

import Foundation

extension String {
    func extractYouTubeID() -> String? {
        // Multiple regex patterns to handle different YouTube URL formats
        let patterns = [
            "(?:https?:\\/\\/)?(?:www\\.)?(?:youtube\\.com\\/(?:[^\\/\\n\\s]+\\/\\S+\\/|(?:v|e(?:mbed)?)\\/|\\S*?[?&]v=)|youtu\\.be\\/)([a-zA-Z0-9_-]{11})",
            "v=([a-zA-Z0-9_-]{11})",
            "be\\/([a-zA-Z0-9_-]{11})"
        ]

        for pattern in patterns {
            if let regex = try? NSRegularExpression(pattern: pattern, options: []),
               let match = regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: self.utf16.count)),
               match.numberOfRanges > 1 {
                let nsString = self as NSString
                return nsString.substring(with: match.range(at: 1))
            }
        }
        return nil
    }
}
