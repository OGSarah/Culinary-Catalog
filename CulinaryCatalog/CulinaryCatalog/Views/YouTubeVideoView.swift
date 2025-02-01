//
//  YouTubeVideoView.swift
//  CulinaryCatalog
//
//  Created by Sarah Clark on 1/30/25.
//

import SwiftUI
import WebKit

struct YouTubeVideoView: UIViewRepresentable {
    @StateObject private var viewModel: YouTubeVideoViewModel

    /// Initializes the view with a video ID
    /// - Parameter videoID: The YouTube video identifier
    init(videoID: String) {
        _viewModel = StateObject(wrappedValue: YouTubeVideoViewModel(videoID: videoID))
    }

    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        guard let youtubeURL = viewModel.embedURL else { return }

        let request = URLRequest(url: youtubeURL)
        uiView.load(request)
    }
}

// MARK: - Preview
#Preview("Light Mode") {
    YouTubeVideoView(videoID: "1ahpSTf_Pvk")
        .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    YouTubeVideoView(videoID: "1ahpSTf_Pvk")
        .preferredColorScheme(.dark)
}
