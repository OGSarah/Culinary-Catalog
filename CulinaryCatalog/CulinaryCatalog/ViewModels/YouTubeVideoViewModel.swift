//
//  YouTubeVideoViewModel.swift
//  CulinaryCatalog
//
//  Created by Sarah Clark on 1/31/25.
//

import Foundation

class YouTubeVideoViewModel: ObservableObject, YouTubeVideoViewModelProtocol {
    private let model: YouTubeVideoModel

    @Published var embedURL: URL?
    @Published var error: Error?

    init(videoID: String) {
        let model = YouTubeVideoModel(videoID: videoID)
        self.model = model
        self.embedURL = model.embedURL

        validateVideoID(videoID)
    }

    internal func validateVideoID(_ videoID: String) {
        guard !videoID.isEmpty, videoID.count == 11 else {
            error = YouTubeVideoError.invalidVideoID
            return
        }
    }
}
