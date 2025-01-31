//
//  YouTubeVideoModel.swift
//  CulinaryCatalog
//
//  Created by Sarah Clark on 1/31/25.
//

import Foundation

struct YouTubeVideoModel {
    let videoID: String

    /// Generates the full YouTube embed URL
    var embedURL: URL? {
        URL(string: "https://www.youtube.com/embed/\(videoID)")
    }
}
