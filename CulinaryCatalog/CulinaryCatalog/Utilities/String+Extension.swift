//
//  String+Extension.swift
//  CulinaryCatalog
//
//  Created by Sarah Clark on 1/30/25.
//

extension String {
    func extractYouTubeID() -> String? {
        let patterns = [
            #/(?:https?://)?(?:www\.)?(?:youtube\.com/(?:[^/\n\s]+/\S+/|(?:v|e(?:mbed)?)/|\S*?[?&]v=)|youtu\.be/)([a-zA-Z0-9_-]{11})/#,
            #/v=([a-zA-Z0-9_-]{11})/#,
            #/be\/([a-zA-Z0-9_-]{11})/#
        ]

        for pattern in patterns {
            if let match = self.firstMatch(of: pattern) {
                return String(match.output.1)
            }
        }
        return nil
    }
}
