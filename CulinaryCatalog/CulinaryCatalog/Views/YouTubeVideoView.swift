//
//  YouTubeVideoView.swift
//  CulinaryCatalog
//
//  Created by Sarah Clark on 1/30/25.
//

import SwiftUI
import WebKit

/// A view that embeds a YouTube video using `WKWebView`.
///
/// This view uses `UIViewRepresentable` to wrap `WKWebView` for displaying YouTube videos within SwiftUI.
struct YouTubeVideoView: UIViewRepresentable {
    /// The view model that holds the logic and state for managing the YouTube video.
    @StateObject private var viewModel: YouTubeVideoViewModel

    /// Initializes the view with a specific YouTube video ID.
    ///
    /// - Parameter videoID: The unique identifier for the YouTube video to be embedded.
    init(videoID: String) {
        _viewModel = StateObject(wrappedValue: YouTubeVideoViewModel(videoID: videoID))
    }

    /// Creates and returns an instance of `WKWebView` for embedding the video.
    ///
    /// - Parameter context: The context provided by SwiftUI for managing the view lifecycle.
    /// - Returns: A new `WKWebView` instance.
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }

    /// Updates the `WKWebView` with the URL of the YouTube video to be displayed.
    ///
    /// This method is called when the view needs to be updated, typically when the `videoID` changes.
    /// - Parameters:
    ///   - uiView: The `WKWebView` instance to update.
    ///   - context: The context provided by SwiftUI for managing updates.
    func updateUIView(_ uiView: WKWebView, context: Context) {
        // Check if there's a valid URL for the YouTube video to embed
        guard let youtubeURL = viewModel.embedURL else { return }

        // Load the video URL into the web view
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
