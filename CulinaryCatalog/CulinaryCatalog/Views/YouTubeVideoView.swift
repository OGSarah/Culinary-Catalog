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
/// This component utilizes `UIViewRepresentable` to integrate `WKWebView` into SwiftUI, allowing for the seamless embedding and playback of YouTube videos. It provides a bridge between SwiftUI's declarative interface and UIKit's imperative web view capabilities for video content.
struct YouTubeVideoView: UIViewRepresentable {
    /// The view model that holds the logic and state for managing the YouTube video.
    ///
    /// This `@StateObject` lifecycle manages the `YouTubeVideoViewModel`, ensuring that changes in the model (like video ID changes) trigger UI updates.
    @StateObject private var viewModel: YouTubeVideoViewModel

    /// Initializes the view with a specific YouTube video ID.
    ///
    /// - Parameter videoID: The unique identifier for the YouTube video to be embedded. This ID is used to construct the YouTube embed URL.
    init(videoID: String) {
        _viewModel = StateObject(wrappedValue: YouTubeVideoViewModel(videoID: videoID))
    }

    /// Creates and returns an instance of `WKWebView` for embedding the video.
    ///
    /// This method is invoked once when the view is created to set up the web view for video playback.
    ///
    /// - Parameter context: The context provided by SwiftUI for managing the view lifecycle, including coordinator if needed.
    /// - Returns: A new `WKWebView` instance configured for YouTube video playback.
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }

    /// Updates the `WKWebView` with the URL of the YouTube video to be displayed.
    ///
    /// This method is called whenever the view needs updating, such as when the video ID changes or the view reappears. It checks for a valid URL from the view model and loads it into the web view.
    ///
    /// - Parameters:
    ///   - uiView: The `WKWebView` instance to update with the new or current video URL.
    ///   - context: The context provided by SwiftUI for managing updates, can be used for coordinator-related operations.
    func updateUIView(_ uiView: WKWebView, context: Context) {
        // Check if there's a valid URL for the YouTube video to embed
        guard let youtubeURL = viewModel.embedURL else { return }

        // Load the video URL into the web view
        let request = URLRequest(url: youtubeURL)
        uiView.load(request)
    }

}

// MARK: - Preview
/// Provides previews for `YouTubeVideoView` to visualize how it appears in both light and dark mode settings.
///
/// These previews use a sample YouTube video ID to simulate the embedding of a video, allowing developers to see how the component will look in the app's UI before actual implementation.
#Preview("Light Mode") {
    YouTubeVideoView(videoID: "1ahpSTf_Pvk")
        .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    YouTubeVideoView(videoID: "1ahpSTf_Pvk")
        .preferredColorScheme(.dark)
}
