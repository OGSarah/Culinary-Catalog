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
    /// Backed by `@State` to own the `@Observable` `YouTubeVideoViewModel`, ensuring changes in the model (like video ID changes) trigger UI updates.
    @State private var viewModel: YouTubeVideoViewModel

    /// Initializes the view with a specific YouTube video ID.
    ///
    /// - Parameter videoID: The unique identifier for the YouTube video to be embedded. This ID is used to construct the YouTube embed URL.
    init(videoID: String) {
        _viewModel = State(wrappedValue: YouTubeVideoViewModel(videoID: videoID))
    }

    /// Creates and returns an instance of `WKWebView` for embedding the video.
    ///
    /// This method is invoked once when the view is created to set up the web view for video playback.
    ///
    /// - Parameter context: The context provided by SwiftUI for managing the view lifecycle, including coordinator if needed.
    /// - Returns: A new `WKWebView` instance configured for YouTube video playback.
    func makeUIView(context: Context) -> WKWebView {
        let configuration = WKWebViewConfiguration()
        configuration.allowsInlineMediaPlayback = true
        configuration.mediaTypesRequiringUserActionForPlayback = []

        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.scrollView.isScrollEnabled = false
        webView.accessibilityIdentifier = AccessibilityIdentifiers.YouTubeVideo.webView
        webView.accessibilityLabel = "Recipe video player"
        return webView
    }

    /// Updates the `WKWebView` with the YouTube video to be displayed.
    ///
    /// Loads the embed inside an HTML iframe with a `https://www.youtube.com` base URL.
    /// Loading the embed URL directly as a top-level navigation causes YouTube's player
    /// to report "Error 153: video player configuration error" because the script
    /// detects it isn't running inside an iframe on a YouTube-origin host page.
    func updateUIView(_ uiView: WKWebView, context: Context) {
        guard let youtubeURL = viewModel.embedURL else { return }

        let html = """
        <!DOCTYPE html>
        <html>
        <head>
        <meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=no">
        <style>
        html, body { margin: 0; padding: 0; background: #000; height: 100%; }
        .wrapper { position: relative; width: 100%; height: 100%; }
        iframe { position: absolute; top: 0; left: 0; width: 100%; height: 100%; border: 0; }
        </style>
        </head>
        <body>
        <div class="wrapper">
        <iframe src="\(youtubeURL.absoluteString)?playsinline=1&rel=0&modestbranding=1"
                allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture"
                allowfullscreen></iframe>
        </div>
        </body>
        </html>
        """

        // Use a non-YouTube baseURL so the iframe is treated as a normal
        // cross-origin embed. Using `youtube.com` as the base made the player's
        // initialization sometimes fail with embed errors (e.g. 152).
        uiView.loadHTMLString(html, baseURL: URL(string: "https://culinarycatalog.local"))
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
